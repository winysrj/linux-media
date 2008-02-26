Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JU0Ny-0005gZ-VB
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 15:02:23 +0100
Date: Tue, 26 Feb 2008 14:56:43 +0100
From: Florian Lohoff <flo@rfc822.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080226135643.GB18747@paradigm.rfc822.org>
MIME-Version: 1.0
Subject: [linux-dvb] multiproto conversion / stb0899_search: Unsupported
	delivery system
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0355191764=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0355191764==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
i am trying to convert my little dvb streaming application 1) over to
multiproto and having some issues - I am seeing the DVBFE_SET_PARAMS
ioctl fail with "Invalid argument"...

The kernel log shows:

	stb0899_search: Unsupported delivery system

although i am pretty shure i have set dvbfe_param->delivery to
DVBFE_DELSYS_DVBS2...

Card is a SkyStar HD:

00:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 1019
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at dfff7e00 (32-bit, non-prefetchable) [size=3D512]

Modules:

budget_ci              23844  0=20
stb0899                33152  1=20
stb6100                 7492  1=20
firmware_class          9312  1 budget_ci
budget_core            10852  1 budget_ci
ttpci_eeprom            2464  1 budget_core
ir_common              36228  1 budget_ci
lnbp21                  2208  1=20
dvb_core               79996  2 budget_ci,budget_core

Kernel log when trying to start my little app stb0899 and stb6100 with verb=
ose ...:

stb0899_init: Initializing STB0899 ...=20
stb0899_init: init device
stb0899_write_regs [0xf000]: 81
stb0899_write_regs [0xf0a0]: 32
stb0899_write_regs [0xf0a1]: 80
stb0899_write_regs [0xf0a4]: 04
stb0899_write_regs [0xf0a5]: 00
stb0899_write_regs [0xf0a6]: 00
stb0899_write_regs [0xf0a7]: 00
stb0899_write_regs [0xf0a8]: 20
stb0899_write_regs [0xf0a9]: 8c
stb0899_write_regs [0xf0aa]: 9a
stb0899_write_regs [0xf110]: 11
stb0899_write_regs [0xf111]: 0a
stb0899_write_regs [0xf112]: 05
stb0899_write_regs [0xf113]: 00
stb0899_write_regs [0xf114]: 00
stb0899_write_regs [0xf11c]: 00
stb0899_write_regs [0xf11d]: 00
stb0899_write_regs [0xf120]: 30
stb0899_write_regs [0xf121]: 00
stb0899_write_regs [0xf122]: 00
stb0899_write_regs [0xf123]: 00
stb0899_write_regs [0xf124]: f3
stb0899_write_regs [0xf125]: fc
stb0899_write_regs [0xf126]: ff
stb0899_write_regs [0xf127]: ff
stb0899_write_regs [0xf128]: 00
stb0899_write_regs [0xf129]: 88
stb0899_write_regs [0xf12a]: 48
stb0899_write_regs [0xf139]: 00
stb0899_write_regs [0xf13a]: 20
stb0899_write_regs [0xf13b]: c9
stb0899_write_regs [0xf13c]: 90
stb0899_write_regs [0xf13d]: 40
stb0899_write_regs [0xf13e]: 00
stb0899_write_regs [0xf140]: 82
stb0899_write_regs [0xf141]: 82
stb0899_write_regs [0xf142]: 82
stb0899_write_regs [0xf143]: 82
stb0899_write_regs [0xf144]: 82
stb0899_write_regs [0xf145]: 82
stb0899_write_regs [0xf146]: 82
stb0899_write_regs [0xf147]: 82
stb0899_write_regs [0xf148]: 82
stb0899_write_regs [0xf149]: 82
stb0899_write_regs [0xf14a]: 82
stb0899_write_regs [0xf14b]: 82
stb0899_write_regs [0xf14c]: 82
stb0899_write_regs [0xf14d]: 82
stb0899_write_regs [0xf14e]: 82
stb0899_write_regs [0xf14f]: 82
stb0899_write_regs [0xf150]: 82
stb0899_write_regs [0xf151]: 82
stb0899_write_regs [0xf152]: 82
stb0899_write_regs [0xf153]: 82
stb0899_write_regs [0xf154]: 82
stb0899_write_regs [0xf155]: b8
stb0899_write_regs [0xf156]: ba
stb0899_write_regs [0xf157]: 1c
stb0899_write_regs [0xf158]: 82
stb0899_write_regs [0xf159]: 91
stb0899_write_regs [0xf15a]: 82
stb0899_write_regs [0xf15b]: 7e
stb0899_write_regs [0xf15c]: 82
stb0899_write_regs [0xf15d]: 82
stb0899_write_regs [0xf15e]: 82
stb0899_write_regs [0xf15f]: 20
stb0899_write_regs [0xf160]: 82
stb0899_write_regs [0xf161]: 82
stb0899_write_regs [0xf162]: 82
stb0899_write_regs [0xf163]: 82
stb0899_write_regs [0xf164]: 82
stb0899_write_regs [0xf165]: 82
stb0899_write_regs [0xf166]: 82
stb0899_write_regs [0xf167]: 82
stb0899_write_regs [0xf1b3]: 15
stb0899_write_regs [0xf1b6]: 02
stb0899_write_regs [0xf1b7]: 00
stb0899_write_regs [0xf1b8]: 00
stb0899_write_regs [0xf1c2]: 20
stb0899_write_regs [0xf1c3]: 00
stb0899_write_regs [0xf200]: 00
_stb0899_read_reg: Reg=3D[0xf2ff], data=3D00
stb0899_write_regs [0xf201]: 0a
_stb0899_read_reg: Reg=3D[0xf2ff], data=3D00
stb0899_init: init S2 demod
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf300], Data=3D[0x00000103]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf304], Data=3D[0x3ed1da56]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf308], Data=3D[0x00004000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf30c], Data=3D[0x00002ade]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf310], Data=3D[0x000001bc]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf314], Data=3D[0x00000200]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf31c], Data=3D[0x0000000f]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf320], Data=3D[0x03fb4a20]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf324], Data=3D[0x00200c97]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf328], Data=3D[0x00000016]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf32c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf330], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf334], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf338], Data=3D[0x3ed097b6]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf33c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf340], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf344], Data=3D[0x0f6cdc01]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf348], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf34c], Data=3D[0x00003993]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf350], Data=3D[0x000d3c6f]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf354], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf358], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf35c], Data=3D[0x0238e38e]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf360], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf364], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf368], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf36c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf37c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf310], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf314], Data=3D[0x40070000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf358], Data=3D[0x00000001]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf35c], Data=3D[0x00000002]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf360], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf364], Data=3D[0x0000fe01]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf368], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf36c], Data=3D[0x00000001]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf374], Data=3D[0x00005007]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000020], Offset=
=3D[0xf378], Data=3D[0x00000002]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf300], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf304], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf308], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf30c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf310], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf314], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf318], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf31c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf320], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf324], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf328], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf32c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf330], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf334], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf338], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf33c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf340], Data=3D[0x0000ff00]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf344], Data=3D[0x00000100]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf348], Data=3D[0x0000fe01]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf34c], Data=3D[0x000004fe]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf350], Data=3D[0x0000cfe7]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf354], Data=3D[0x0000bec6]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf358], Data=3D[0x0000c2bf]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf35c], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf360], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf364], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf368], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf36c], Data=3D[0x0000c1c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf370], Data=3D[0x0000c0c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf374], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf378], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000040], Offset=
=3D[0xf37c], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf300], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf304], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf308], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf30c], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf310], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf314], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf318], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf31c], Data=3D[0x0000c0c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf320], Data=3D[0x0000c1c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf324], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf328], Data=3D[0x0000c0c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf32c], Data=3D[0x0000c1c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf330], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf334], Data=3D[0x0000c1be]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf338], Data=3D[0x0000c1c9]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf33c], Data=3D[0x0000c0da]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf340], Data=3D[0x0000c0ba]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf344], Data=3D[0x0000c1c4]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf348], Data=3D[0x0000c1bf]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf34c], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf350], Data=3D[0x0000c1c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf354], Data=3D[0x0000c0c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf358], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf35c], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf360], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf364], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf368], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf36c], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf370], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf374], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf378], Data=3D[0x0000c1c1]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000060], Offset=
=3D[0xf37c], Data=3D[0x0000c1c0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf300], Data=3D[0x00000001]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf304], Data=3D[0x00005654]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf30c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf310], Data=3D[0x00020019]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf314], Data=3D[0x004b3237]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf320], Data=3D[0x0003dd17]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf324], Data=3D[0x00008008]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf320], Data=3D[0x002a3106]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf324], Data=3D[0x0006140a]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf328], Data=3D[0x00008000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf32c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf340], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf344], Data=3D[0x00000471]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf34c], Data=3D[0x017b0465]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf350], Data=3D[0x00000002]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf354], Data=3D[0x00196464]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf358], Data=3D[0x00000603]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf35c], Data=3D[0x02046666]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf360], Data=3D[0x10046583]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf364], Data=3D[0x00010404]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf368], Data=3D[0x0002aa8a]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf36c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf370], Data=3D[0x00000001]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf374], Data=3D[0x00000500]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf378], Data=3D[0x0028a0a0]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000400], Offset=
=3D[0xf37c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf308], Data=3D[0x00800c17]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf30c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf310], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf314], Data=3D[0x00054802]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf320], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf324], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf328], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf32c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf330], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf334], Data=3D[0x00000400]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf338], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf33c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf340], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf344], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf348], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf350], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf354], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf358], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf35c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf360], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf364], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf368], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf36c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf370], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf374], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000440], Offset=
=3D[0xf378], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf300], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf304], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf308], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf30c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf310], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf314], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf318], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf31c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf320], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf324], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf328], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf330], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf334], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf338], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf33c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf340], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf344], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf348], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf34c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf350], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf354], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000460], Offset=
=3D[0xf358], Data=3D[0x00000000]
stb0899_init: init S1 demod
stb0899_write_regs [0xf40e]: 00
stb0899_write_regs [0xf410]: c9
stb0899_write_regs [0xf412]: 41
stb0899_write_regs [0xf413]: 10
stb0899_write_regs [0xf417]: 7a
stb0899_write_regs [0xf418]: 4e
stb0899_write_regs [0xf419]: 34
stb0899_write_regs [0xf41a]: 84
stb0899_write_regs [0xf41b]: c7
stb0899_write_regs [0xf41c]: 87
stb0899_write_regs [0xf41d]: 94
stb0899_write_regs [0xf41e]: 41
stb0899_write_regs [0xf41f]: dd
stb0899_write_regs [0xf420]: c9
stb0899_write_regs [0xf425]: b4
stb0899_write_regs [0xf426]: 10
stb0899_write_regs [0xf427]: 30
stb0899_write_regs [0xf428]: fb
stb0899_write_regs [0xf429]: 03
stb0899_write_regs [0xf42a]: 3b
stb0899_write_regs [0xf42b]: 3d
stb0899_write_regs [0xf42c]: 81
stb0899_write_regs [0xf42e]: 80
stb0899_write_regs [0xf436]: 04
stb0899_write_regs [0xf437]: f5
stb0899_write_regs [0xf438]: 25
stb0899_write_regs [0xf439]: 80
stb0899_write_regs [0xf43a]: 00
stb0899_write_regs [0xf43b]: ca
stb0899_write_regs [0xf43e]: f1
stb0899_write_regs [0xf43f]: f3
stb0899_write_regs [0xf440]: 2a
stb0899_write_regs [0xf441]: 05
stb0899_write_regs [0xf444]: 17
stb0899_write_regs [0xf445]: fa
stb0899_write_regs [0xf446]: 2f
stb0899_write_regs [0xf447]: 68
stb0899_write_regs [0xf448]: 40
stb0899_write_regs [0xf44c]: 2f
stb0899_write_regs [0xf44d]: 68
stb0899_write_regs [0xf44e]: 40
stb0899_write_regs [0xf4e0]: fd
stb0899_write_regs [0xf4e1]: 04
stb0899_write_regs [0xf4e2]: 0f
stb0899_write_regs [0xf4e3]: ff
stb0899_write_regs [0xf4e4]: df
stb0899_write_regs [0xf4e5]: fa
stb0899_write_regs [0xf4e6]: 37
stb0899_write_regs [0xf4e7]: 0d
stb0899_write_regs [0xf4e8]: bd
stb0899_write_regs [0xf4e9]: f7
stb0899_write_regs [0xf50c]: 00
stb0899_write_regs [0xf50d]: 00
stb0899_write_regs [0xf50f]: ff
stb0899_write_regs [0xf523]: 2a
stb0899_write_regs [0xf524]: 00
stb0899_write_regs [0xf525]: 00
stb0899_write_regs [0xf526]: 00
stb0899_write_regs [0xf527]: 00
stb0899_write_regs [0xf528]: 00
stb0899_write_regs [0xf529]: 00
stb0899_write_regs [0xf530]: 06
stb0899_write_regs [0xf533]: 01
stb0899_write_regs [0xf534]: f0
stb0899_write_regs [0xf535]: a0
stb0899_write_regs [0xf536]: 78
stb0899_write_regs [0xf537]: 4e
stb0899_write_regs [0xf538]: 48
stb0899_write_regs [0xf539]: 38
stb0899_write_regs [0xf53c]: ff
stb0899_write_regs [0xf53d]: 19
stb0899_write_regs [0xf548]: b1
stb0899_write_regs [0xf549]: 42
stb0899_write_regs [0xf54a]: 40
stb0899_write_regs [0xf54b]: 12
stb0899_write_regs [0xf54c]: 0c
stb0899_write_regs [0xf54d]: 00
stb0899_write_regs [0xf54e]: 0c
stb0899_write_regs [0xf54f]: 0d
stb0899_write_regs [0xf550]: 00
stb0899_write_regs [0xf551]: 02
stb0899_write_regs [0xf552]: 00
stb0899_write_regs [0xf553]: 00
stb0899_write_regs [0xf55a]: 00
stb0899_write_regs [0xf55b]: 00
stb0899_write_regs [0xf55c]: 00
stb0899_write_regs [0xf55d]: ab
stb0899_write_regs [0xf55e]: 00
stb0899_write_regs [0xf55f]: cc
stb0899_write_regs [0xf560]: cc
stb0899_write_regs [0xf561]: 80
stb0899_write_regs [0xf574]: b6
stb0899_write_regs [0xf575]: 96
stb0899_write_regs [0xf576]: 89
stb0899_write_regs [0xf57b]: 27
stb0899_write_regs [0xf57c]: 03
stb0899_write_regs [0xf583]: 5c
stb0899_write_regs [0xf58c]: 1f
stb0899_write_regs [0xf600]: 48
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf601]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf602]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf603]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf604]: 77
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf605]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf606]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf607]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf608]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf609]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60a]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60b]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60c]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60d]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60e]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf60f]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf610]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf611]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf612]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf613]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf614]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf615]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf616]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf617]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf618]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf619]: 10
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf61a]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf61b]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf61c]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf61d]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_write_regs [0xf61e]: 00
_stb0899_read_reg: Reg=3D[0xf6ff], data=3D00
stb0899_init: init S2 FEC
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa04], Data=3D[0x00000008]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa08], Data=3D[0x000000b4]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa10], Data=3D[0x000004b5]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa14], Data=3D[0x00000b4b]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa1c], Data=3D[0x00000078]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa20], Data=3D[0x000001e0]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa24], Data=3D[0x0000a8c0]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000000], Offset=
=3D[0xfa28], Data=3D[0x0000000c]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa00], Data=3D[0x00000001]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa04], Data=3D[0x0000000d]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa08], Data=3D[0x00000040]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa0c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa10], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa14], Data=3D[0x00000008]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa18], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa1c], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa20], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa24], Data=3D[0x00000008]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa28], Data=3D[0x00000000]
stb0899_write_s2reg Device=3D[0xfafc], Base Address=3D[0x00000800], Offset=
=3D[0xfa38], Data=3D[0x00000000]
stb0899_init: init TST
stb0899_write_regs [0xff10]: 00
stb0899_write_regs [0xff11]: 00
stb0899_write_regs [0xff12]: 00
stb0899_write_regs [0xff13]: 00
stb0899_write_regs [0xff14]: 00
stb0899_write_regs [0xff15]: 00
stb0899_write_regs [0xff16]: 00
stb0899_write_regs [0xff17]: 00
stb0899_write_regs [0xff1c]: 00
stb0899_write_regs [0xff1d]: 00
stb0899_write_regs [0xff1e]: 00
stb0899_write_regs [0xff24]: 00
stb0899_write_regs [0xff25]: 00
stb0899_write_regs [0xff28]: 00
stb0899_write_regs [0xff40]: 00
stb0899_write_regs [0xff41]: 00
stb0899_write_regs [0xff42]: 00
stb0899_write_regs [0xff48]: 00
stb0899_write_regs [0xff49]: 00
stb0899_write_regs [0xff4a]: 00
stb0899_write_regs [0xff4b]: 00
stb0899_write_regs [0xff4c]: 00
stb0899_write_regs [0xff4d]: 00
stb0899_write_regs [0xff50]: 00
stb0899_write_regs [0xff51]: 00
stb0899_write_regs [0xff52]: 00
stb0899_write_regs [0xff53]: 00
stb0899_write_regs [0xff54]: 00
stb0899_write_regs [0xff55]: 00
stb0899_write_regs [0xff56]: 00
stb0899_write_regs [0xff58]: 00
stb0899_write_regs [0xff59]: 00
stb0899_write_regs [0xff5a]: 00
stb0899_write_regs [0xff5c]: 00
stb0899_write_regs [0xff5d]: 00
stb0899_write_regs [0xff53]: 00
stb0899_write_regs [0xf000]: 81
_stb0899_read_reg: Reg=3D[0xf412], data=3D41
stb0899_read_regs [0xf413]: 10 00
_stb0899_read_reg: Reg=3D[0xf1b3], data=3D15
stb0899_get_mclk: div=3D21, mclk=3D99000000
_stb0899_read_reg: Reg=3D[0xf40e], data=3D00
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000000], Offset=
=3D[0xf320], Data=3D[0x03fb4a20]
stb0899_write_s2reg Device=3D[0xf3fc], Base Address=3D[0x00000000], Offset=
=3D[0xf320], Data=3D[0x03fb4a20]
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000020], Offset=
=3D[0xf35c], Data=3D[0x00000002]
_stb0899_read_reg: Reg=3D[0xf0a1], data=3D80
stb0899_write_regs [0xf0a1]: 80
_stb0899_read_reg: Reg=3D[0xf0a0], data=3D32
stb0899_write_regs [0xf0a0]: 72
_stb0899_read_reg: Reg=3D[0xf0a0], data=3D72
stb0899_write_regs [0xf0a0]: 32
_stb0899_read_reg: Reg=3D[0xf1b3], data=3D15
stb0899_get_mclk: div=3D21, mclk=3D99000000
stb0899_write_regs [0xf0a9]: 8c
_stb0899_read_reg: Reg=3D[0xf12a], data=3D48
stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
stb0899_write_regs [0xf12a]: c8
stb6100_set_bandwidth: set bandwidth to 36000 Hz
stb6100_write_reg_range:     Write @ 0x60: [9:1]
stb6100_write_reg_range:         FCCK: 0x4d
stb6100_write_reg_range:     Write @ 0x60: [6:1]
stb6100_write_reg_range:         F: 0xc0
stb6100_write_reg_range:     Write @ 0x60: [9:1]
stb6100_write_reg_range:         FCCK: 0x0d
_stb0899_read_reg: Reg=3D[0xf12a], data=3Dc8
stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...
stb0899_write_regs [0xf12a]: 48
_stb0899_read_reg: Reg=3D[0xf0a8], data=3D20
stb0899_write_regs [0xf15f]: 66
_stb0899_read_reg: Reg=3D[0xf110], data=3D11
stb0899_write_regs [0xf110]: 31
stb0899_write_regs [0xf111]: 12
_stb0899_read_reg: Reg=3D[0xf12a], data=3D48
stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...
stb0899_write_regs [0xf12a]: 48
stb0899_sleep: Going to Sleep .. (Really tired .. :-))

Flo
1) http://silicon-verl.de/home/flo/projects/streaming/
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxBqbUaz2rXW+gJcRAnUcAJ47GhswbadUeilz1wPDO0r9d4rQPwCeNjR0
IucOQDpwh7I0ba9LZfjw8OM=
=Kuao
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--


--===============0355191764==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0355191764==--
