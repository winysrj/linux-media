Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from zivlnx17.uni-muenster.de ([128.176.188.79]
	helo=SECMAIL.UNI-MUENSTER.DE)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <viellerlei@uni-muenster.de>) id 1KGKXb-0006Cg-TE
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 23:16:06 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by SECMAIL.UNI-MUENSTER.DE (Postfix) with ESMTP id 9CE98D4800C
	for <linux-dvb@linuxtv.org>; Tue,  8 Jul 2008 23:16:00 +0200 (CEST)
Received: from SECMAIL.UNI-MUENSTER.DE ([127.0.0.1])
	by localhost (ZIVLNX17 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 12541-01 for <linux-dvb@linuxtv.org>;
	Tue,  8 Jul 2008 23:15:58 +0200 (CEST)
Received: from mirkoskleiner (e181225189.adsl.alicedsl.de [85.181.225.189])
	by SECMAIL.UNI-MUENSTER.DE (Postfix) with ESMTP id E991CD48002
	for <linux-dvb@linuxtv.org>; Tue,  8 Jul 2008 23:15:57 +0200 (CEST)
From: Mirko Ebbers <viellerlei@uni-muenster.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Tue, 8 Jul 2008 23:16:03 +0200
Message-Id: <200807082316.03696.viellerlei@uni-muenster.de>
Subject: [linux-dvb] vdr: [5088] frontend 0 timed out while tuning to
	channel 13, tp 538
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0224146134=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0224146134==
Content-Type: multipart/signed;
  boundary="nextPart2565088.k2mKujKycX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2565088.k2mKujKycX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

i have setup a new gentoo system primarily for VDR. (The system information=
 in=20
the end).
I am using a Nova 500T card.

When I start vdr I get the message "vdr: [5088] frontend 0 timed out while=
=20
tuning to channel 13, tp 538" and "vdr: [5091] frontend 1 timed out while=20
tuning to channel 1, tp 474" in my log, and no tv-watching is possible.

I started with vdr 1.6 and also tried vdr 1.4.7 with the exact same results=
=2E I=20
have tried the kernel modules and also the "media-tv/v4l-dvb-hg" modules=20
which are supposedly the "live development version of v4l&dvb-driver for=20
Kernel 2.6" with no difference in behavior. Then I tried older Kernels,=20
2.6.24 and 2.6.23 which didn't make any difference.

This card used to work in my old computer (which I turned off one week ago.=
=2E.)=20
with the antenna at the same spot as it is now. I tried another antenna and=
=20
checked if the cabels are connected correctly and that they are in perfect=
=20
working order. My channels.conf contains stations from the next DVB-T tower=
=20
and from another one, so it shouldn't be a network-problem.
I have "dvb-usb-dib0700 force_lna_activation=3D1" in my kernel-2.6 autoload=
er=20
file, so it shouldn't be the lna-weak-signal-problem, even though I don't=20
know how to check if that module realy is startet with that option.
I used the firmware file "dvb-usb-dib0700-03-pre1.fw" since this solved the=
se=20
disconnect problems for good the last time I had problems with this card.

So maybe there is something in my new computer which influences the recepti=
on=20
physically, or maybe it's an ACPI-Problem (my new mainboard used to have a=
=20
bad ACPI-Table, but I updated the bios and that made all the warnings=20
dissapear)? Disableing ACPI at boot time doesn't make a difference.

But hopefully you have got a (simple :-) ) solution to this problem.

Best regards
Mirko Ebbers

PS: feel free to ask, if you need different information.

lsmod________________________________________________
Module                  Size  Used by
dvb_usb_dib0700        36808  0
dib7000p               15624  1 dvb_usb_dib0700
dib7000m               14532  1 dvb_usb_dib0700
dvb_usb                16588  1 dvb_usb_dib0700
dvb_core               74420  1 dvb_usb
dib3000mc              12232  3 dvb_usb_dib0700
dibx000_common          3780  3 dib7000p,dib7000m,dib3000mc
dib0070                 7492  1 dvb_usb_dib0700
i2c_core               20128  7=20
dvb_usb_dib0700,dib7000p,dib7000m,dvb_usb,dib3000mc,dibx000_common,dib0070

emerge --info______________________________________________________________=
___________________
Portage 2.1.4.4 (default/linux/amd64/2008.0, gcc-4.1.2, glibc-2.6.1-r0,=20
2.6.25-gentoo-r6 x86_64)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
System uname: 2.6.25-gentoo-r6 x86_64 Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz
Timestamp of tree: Tue, 08 Jul 2008 11:30:01 +0000
app-shells/bash:     3.2_p33
dev-lang/python:     2.4.4-r13
dev-python/pycrypto: 2.0.1-r6
sys-apps/baselayout: 1.12.11.1
sys-apps/sandbox:    1.2.18.1-r2
sys-devel/autoconf:  2.61-r2
sys-devel/automake:  1.9.6-r2, 1.10.1
sys-devel/binutils:  2.18-r3
sys-devel/gcc-config: 1.4.0-r4
sys-devel/libtool:   1.5.26
virtual/os-headers:  2.6.23-r3
ACCEPT_KEYWORDS=3D"amd64"
CBUILD=3D"x86_64-pc-linux-gnu"
CFLAGS=3D"-march=3Dnocona -O2 -pipe"
CHOST=3D"x86_64-pc-linux-gnu"
CONFIG_PROTECT=3D"/etc"
CONFIG_PROTECT_MASK=3D"/etc/env.d /etc/fonts/fonts.conf /etc/gconf /etc/ter=
minfo /etc/udev/rules.d"
CXXFLAGS=3D"-march=3Dnocona -O2 -pipe"
DISTDIR=3D"/usr/portage/distfiles"
=46EATURES=3D"distlocks metadata-transfer sandbox sfperms strict unmerge-or=
phans=20
userfetch"
GENTOO_MIRRORS=3D"http://linux.rz.ruhr-uni-bochum.de/download/gentoo-mirror=
/ "
MAKEOPTS=3D"-j3"
PKGDIR=3D"/usr/portage/packages"
PORTAGE_RSYNC_OPTS=3D"--recursive --links --safe-links --perms --times --co=
mpress --force --whole-file --delete --stats --timeout=3D180 --exclude=3D/d=
istfiles --exclude=3D/local --exclude=3D/packages"
PORTAGE_TMPDIR=3D"/var/tmp"
PORTDIR=3D"/usr/portage"
PORTDIR_OVERLAY=3D"/usr/portage/local/layman/voip"
SYNC=3D"rsync://rsync.gentoo.org/gentoo-portage"
USE=3D"3dnow acl acpi amd64 bash-completion berkdb bzip2 cli cracklib crypt=
 cups=20
dbd dri dvb exif fortran gdbm gimp gpm hal iconv ieee1394 imap ipv6 isdnlog=
=20
jabber lzo maildir midi mmx mudflap multilib ncurses nls nptl nptlonly ogg=
=20
openmp pam pcre perl pppd python readline reflection session spl sse sse2 s=
sl=20
tcpd unicode usb v4l v4l2 vhosts vnc xorg zlib" ALSA_CARDS=3D"ali5451 als40=
00=20
atiixp atiixp-modem bt87x ca0106 cmipci emu10k1x ens1370 ens1371 es1938=20
es1968 fm801 hda-intel intel8x0 intel8x0m maestro3 trident usb-audio via82x=
x=20
via82xx-modem ymfpci" ALSA_PCM_PLUGINS=3D"adpcm alaw asym copy dmix dshare=
=20
dsnoop empty extplug file hooks iec958 ioplug ladspa lfloat linear meter=20
mulaw multi null plug rate route share shm softvol" APACHE2_MODULES=3D"acti=
ons=20
alias auth_basic authn_alias authn_anon authn_dbm authn_default authn_file=
=20
authz_dbm authz_default authz_groupfile authz_host authz_owner authz_user=20
autoindex cache dav dav_fs dav_lock deflate dir disk_cache env expires=20
ext_filter file_cache filter headers include info log_config logio mem_cach=
e=20
mime mime_magic negotiation rewrite setenvif speling status unique_id userd=
ir=20
usertrack vhost_alias" DVB_CARDS=3D"dibusb-usb2 usb-dib0700" ELIBC=3D"glibc=
"=20
INPUT_DEVICES=3D"keyboard mouse evdev" KERNEL=3D"linux" LCD_DEVICES=3D"bayr=
ad=20
cfontz cfontz633 glk hd44780 lb216 lcdm001 mtxorb ncurses text"=20
USERLAND=3D"GNU" VIDEO_CARDS=3D"fbdev glint i810 mach64 mga neomagic nv r12=
8=20
radeon savage sis tdfx trident vesa vga via vmware voodoo"
Unset:  CPPFLAGS, CTARGET, EMERGE_DEFAULT_OPTS, INSTALL_MASK, LANG, LC_ALL,=
=20
LDFLAGS, LINGUAS, PORTAGE_COMPRESS, PORTAGE_COMPRESS_FLAGS,=20
PORTAGE_RSYNC_EXTRA_OPTS

--nextPart2565088.k2mKujKycX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIc9kTEwJu/XDbJ4YRAvCBAJ4mMHhnN0u9Eeom7wU3l1dnf4Ym6QCgk7zx
ujSPEEvp2CLRNX3JXSDgkLA=
=FuyQ
-----END PGP SIGNATURE-----

--nextPart2565088.k2mKujKycX--


--===============0224146134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0224146134==--
