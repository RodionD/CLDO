# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

DESCRIPTION="OpenBox device menu"
HOMEPAGE="https://github.com/RodionD/obdevicemenu"
SRC_URI="https://github.com/RodionD/obdevicemenu/archive/1.7.0.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notifications"

DEPEND="
	app-shells/bash
	sys-apps/dbus
	x11-wm/openbox
	sys-fs/udisks:0
	notifications? ( x11-misc/notification-daemon )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PF}"

src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
    fi
}

src_install() {
    insinto /etc
    doins obdevicemenu.conf || die
    exeinto /usr/local/bin
    doexe obdevicemenu || die
}
