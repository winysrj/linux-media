Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpjizak.jmnet.cz ([78.108.106.244]:49673 "EHLO
	smtpjizak.jmnet.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0ABADi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jan 2010 19:03:38 -0500
Received: from localhost (wolf01 [127.0.0.1])
	by smtpjizak.jmnet.cz (Postfix) with ESMTP id 937FCC0A04F
	for <linux-media@vger.kernel.org>; Sat,  2 Jan 2010 00:57:36 +0100 (CET)
Received: from smtpjizak.jmnet.cz ([78.108.106.244])
	by localhost (mail.jiznak.czf [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AaNMJ6q5W9uR for <linux-media@vger.kernel.org>;
	Sat,  2 Jan 2010 00:57:34 +0100 (CET)
Received: from [10.38.38.138] (pixla.hellnet.jiznak.czf [10.38.38.138])
	by smtpjizak.jmnet.cz (Postfix) with ESMTP id 53536C0A027
	for <linux-media@vger.kernel.org>; Sat,  2 Jan 2010 00:57:34 +0100 (CET)
Subject: DVBWorld DVB-S2 2005 PCI-Express Card
From: Jakub =?UTF-8?Q?L=C3=A1zni=C4=8Dka?= <jakub@jiznak.cz>
To: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KVsw5h1zZIb3w5sDtLuy"
Date: Sat, 02 Jan 2010 00:57:34 +0100
Message-Id: <1262390254.8927.15.camel@sirius>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KVsw5h1zZIb3w5sDtLuy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello.
At first, sorry for my bad english.

I have problem with card DVBWorld DVB-S2 2005 PCI-Express Card. I have
four pci-expresses slots (with these cards) in computer.

#uname -a
Linux frey 2.6.30-2-686-bigmem #1 SMP Fri Dec 4 02:13:28 UTC 2009 i686
GNU/Linux (Debian)

#frey:/dev/dvb# lspci | grep Conexant
83:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)
84:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)
85:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)
86:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)

Using modules from kernel, i tried to use these cards, but:

modprobe cx23885 card=3D16=20


(from dmesg | grep cx)

[282852.623177] cx23885 driver version 0.0.2
loaded                                                                     =
                                               =20
[282852.623221] cx23885 0000:83:00.0: PCI INT A -> GSI 48 (level, low)
-> IRQ
48                                                                         =
              =20
[282852.623312] CORE cx23885[0]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005 [card=3D16,insmod
option]                                                             =20
[282852.749698] cx23885_dvb_register() allocating 1
frontend(s)                                                                =
                                        =20
[282852.749700] cx23885[0]: cx23885 based dvb
card                                                                       =
                                              =20
[282852.750696] cx23885[0]: frontend initialization
failed                                                                     =
                                        =20
[282852.750727] cx23885_dvb_register() dvb_register failed err =3D
-1                                                                         =
                           =20
[282852.750758] cx23885_dev_setup() Failed to register dvb adapters on
VID_B                                                                      =
                     =20
[282852.750792] cx23885_dev_checkrevision() Hardware revision =3D
0xa5                                                                       =
                            =20
[282852.750798] cx23885[0]/0: found at 0000:83:00.0, rev: 4, irq: 48,
latency: 0, mmio:
0xf5800000                                                                 =
    =20
[282852.750805] cx23885 0000:83:00.0: setting latency timer to
64                                                                         =
                             =20
[282852.750809] IRQ 48/cx23885[0]: IRQF_DISABLED is not guaranteed on
shared
IRQs                                                                       =
               =20
[282852.750827] cx23885 0000:84:00.0: PCI INT A -> GSI 50 (level, low)
-> IRQ
50                                                                         =
              =20
[282852.750917] CORE cx23885[1]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005
[card=3D16,autodetected]                                                   =
           =20
[282852.878287] cx23885_dvb_register() allocating 1
frontend(s)                                                                =
                                        =20
[282852.878289] cx23885[1]: cx23885 based dvb
card                                                                       =
                                              =20
[282852.879296] cx23885[1]: frontend initialization failed
[282852.879326] cx23885_dvb_register() dvb_register failed err =3D -1
[282852.879357] cx23885_dev_setup() Failed to register dvb adapters on
VID_B
[282852.879387] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282852.879393] cx23885[1]/0: found at 0000:84:00.0, rev: 4, irq: 50,
latency: 0, mmio: 0xf5a00000
[282852.879400] cx23885 0000:84:00.0: setting latency timer to 64
[282852.879403] IRQ 50/cx23885[1]: IRQF_DISABLED is not guaranteed on
shared IRQs
[282852.879421] cx23885 0000:85:00.0: PCI INT A -> GSI 54 (level, low)
-> IRQ 54
[282852.879495] CORE cx23885[2]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005 [card=3D16,autodetected]
[282853.009718] cx23885_dvb_register() allocating 1 frontend(s)
[282853.009720] cx23885[2]: cx23885 based dvb card
[282853.010713] cx23885[2]: frontend initialization failed
[282853.010743] cx23885_dvb_register() dvb_register failed err =3D -1
[282853.010774] cx23885_dev_setup() Failed to register dvb adapters on
VID_B
[282853.010808] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282853.010813] cx23885[2]/0: found at 0000:85:00.0, rev: 4, irq: 54,
latency: 0, mmio: 0xf5c00000
[282853.010821] cx23885 0000:85:00.0: setting latency timer to 64
[282853.010824] IRQ 54/cx23885[2]: IRQF_DISABLED is not guaranteed on
shared IRQs
[282853.010842] cx23885 0000:86:00.0: PCI INT A -> GSI 56 (level, low)
-> IRQ 56
[282853.011398] CORE cx23885[3]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005 [card=3D16,autodetected]
[282853.141192] cx23885_dvb_register() allocating 1 frontend(s)
[282853.141194] cx23885[3]: cx23885 based dvb card
[282853.142152] DVB: registering new adapter (cx23885[3])
[282853.142318] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282853.142323] cx23885[3]/0: found at 0000:86:00.0, rev: 4, irq: 56,
latency: 0, mmio: 0xf5e00000
[282853.142331] cx23885 0000:86:00.0: setting latency timer to 64
[282853.142334] IRQ 56/cx23885[3]: IRQF_DISABLED is not guaranteed on
shared IRQs

Only one card is in /dev/dvb

If i try modprobe cx23885 card=3D4=20

[282956.988447] cx23885 driver version 0.0.2
loaded                                                                     =
                                               =20
[282956.988490] cx23885 0000:83:00.0: PCI INT A -> GSI 48 (level, low)
-> IRQ
48                                                                         =
              =20
[282956.988570] CORE cx23885[0]: subsystem: 0001:2005, board: DViCO
FusionHDTV5 Express [card=3D4,insmod
option]                                                         =20
[282957.114402] cx23885_dvb_register() allocating 1
frontend(s)                                                                =
                                        =20
[282957.114404] cx23885[0]: cx23885 based dvb
card                                                                       =
                                              =20
[282957.114954] tuner-simple 1-0061: creating new
instance                                                                   =
                                          =20
[282957.114956] tuner-simple 1-0061: type set to 64 (LG
TDVS-H06xF)                                                                =
                                    =20
[282957.114958] DVB: registering new adapter
(cx23885[0])                                                               =
                                               =20
[282957.114960] DVB: registering adapter 0 frontend 0 (LG Electronics
LGDT3303 VSB/QAM
Frontend)...                                                               =
     =20
[282957.115103] cx23885_dev_checkrevision() Hardware revision =3D
0xa5                                                                       =
                            =20
[282957.115109] cx23885[0]/0: found at 0000:83:00.0, rev: 4, irq: 48,
latency: 0, mmio:
0xf5800000                                                                 =
    =20
[282957.115116] cx23885 0000:83:00.0: setting latency timer to
64                                                                         =
                             =20
[282957.115120] IRQ 48/cx23885[0]: IRQF_DISABLED is not guaranteed on
shared
IRQs                                                                       =
               =20
[282957.115136] cx23885 0000:84:00.0: PCI INT A -> GSI 50 (level, low)
-> IRQ
50                                                                         =
              =20
[282957.115214] CORE cx23885[1]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005
[card=3D16,autodetected]                                                   =
           =20
[282957.244064] cx23885_dvb_register() allocating 1
frontend(s)                                                                =
                                        =20
[282957.244066] cx23885[1]: cx23885 based dvb
card                                                                       =
                                              =20
[282957.245034] Invalid probe, probably not a CX24116
device                                                                     =
                                      =20
[282957.245081] cx23885[1]: frontend initialization
failed                                                                     =
                                        =20
[282957.245111] cx23885_dvb_register() dvb_register failed err =3D
-1                                                                         =
                           =20
[282957.245142] cx23885_dev_setup() Failed to register dvb adapters on
VID_B
[282957.245176] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282957.245182] cx23885[1]/0: found at 0000:84:00.0, rev: 4, irq: 50,
latency: 0, mmio: 0xf5a00000
[282957.245189] cx23885 0000:84:00.0: setting latency timer to 64
[282957.245193] IRQ 50/cx23885[1]: IRQF_DISABLED is not guaranteed on
shared IRQs
[282957.245212] cx23885 0000:85:00.0: PCI INT A -> GSI 54 (level, low)
-> IRQ 54
[282957.245291] CORE cx23885[2]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005 [card=3D16,autodetected]
[282957.373191] cx23885_dvb_register() allocating 1 frontend(s)
[282957.373193] cx23885[2]: cx23885 based dvb card
[282957.374142] Invalid probe, probably not a CX24116 device
[282957.374189] cx23885[2]: frontend initialization failed
[282957.374219] cx23885_dvb_register() dvb_register failed err =3D -1
[282957.374250] cx23885_dev_setup() Failed to register dvb adapters on
VID_B
[282957.374280] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282957.374285] cx23885[2]/0: found at 0000:85:00.0, rev: 4, irq: 54,
latency: 0, mmio: 0xf5c00000
[282957.374293] cx23885 0000:85:00.0: setting latency timer to 64
[282957.374296] IRQ 54/cx23885[2]: IRQF_DISABLED is not guaranteed on
shared IRQs
[282957.374313] cx23885 0000:86:00.0: PCI INT A -> GSI 56 (level, low)
-> IRQ 56
[282957.374377] CORE cx23885[3]: subsystem: 0001:2005, board: DVBWorld
DVB-S2 2005 [card=3D16,autodetected]
[282957.501607] cx23885_dvb_register() allocating 1 frontend(s)
[282957.501609] cx23885[3]: cx23885 based dvb card
[282957.502555] DVB: registering new adapter (cx23885[3])
[282957.502557] DVB: registering adapter 1 frontend 0 (Conexant
CX24116/CX24118)...
[282957.502705] cx23885_dev_checkrevision() Hardware revision =3D 0xa5
[282957.502711] cx23885[3]/0: found at 0000:86:00.0, rev: 4, irq: 56,
latency: 0, mmio: 0xf5e00000
[282957.502718] cx23885 0000:86:00.0: setting latency timer to 64
[282957.502722] IRQ 56/cx23885[3]: IRQF_DISABLED is not guaranteed on
shared IRQs

2 cards looks good.

I tried to compile liplianin original modules too, but there are some
problems with (ir_haupagge...) etc. and module cannot be loaded.

I don`t know where is problem. Asked 2 friends too but they don`t care.
I asked on irc channel too, but i was forwared here.=20

Thank you for reply.=20
Jakub L=C3=A1zni=C4=8Dka <jakub@jiznak.cz>

--=-KVsw5h1zZIb3w5sDtLuy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Toto je =?UTF-8?Q?digit=C3=A1ln=C4=9B?=
 =?ISO-8859-1?Q?_podepsan=E1?= =?UTF-8?Q?_=C4=8D=C3=A1st?=
 =?ISO-8859-1?Q?_zpr=E1vy?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAks+i+kACgkQXR2LPE1XFYt+/wCfQ/yO9zFSD4h99GBrr2gusoKy
kxsAniNXt/y28jZWU7EsDNi3yJOaFwAG
=3C21
-----END PGP SIGNATURE-----

--=-KVsw5h1zZIb3w5sDtLuy--

