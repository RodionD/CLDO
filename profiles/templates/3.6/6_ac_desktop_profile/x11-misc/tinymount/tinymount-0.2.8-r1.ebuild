# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ru uk"
inherit qmake-utils l10n

if [[ ${PV} == *9999 ]]; then
    EGIT_REPO_URI=("https://github.com/limansky/${PN}.git")
    inherit git-r3
else
    SRC_URI="https://github.com/limansky/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple graphical utility for disk mounting"
HOMEPAGE="https://github.com/limansky/tinymount"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug libnotify"

COMMON_DEPEND="
    dev-qt/qtcore:5
    dev-qt/qtdbus:5
    dev-qt/qtgui:5
    libnotify? ( x11-libs/libnotify )"
DEPEND="${COMMON_DEPEND}
    virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
    sys-fs/udisks:0"

DOCS=( ChangeLog README.md )

src_prepare() {
    remove_locale() {
        sed -i -e "/translations\/${PN}_${1}.ts/d" src/src.pro || die
    }

    # Check for locales added/removed from previous version
    l10n_find_plocales_changes src/translations "${PN}_" .ts

    # Prevent disabled locales from being built
    l10n_for_each_disabled_locale_do remove_locale

    # Bug 441986
    sed -i -e 's|-Werror||g' src/src.pro || die

    default
}

src_configure() {
    eqmake5 \
        PREFIX="/usr" \
        $(use libnotify && echo CONFIG+=with_libnotify)
}

src_install() {
     emake INSTALL_ROOT="${D}" install
}