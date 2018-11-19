Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41258 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730274AbeKTESG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 23:18:06 -0500
Date: Mon, 19 Nov 2018 15:53:26 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stakanov Schufter <stakanov@freenet.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181119155326.24f6083f@coco.lan>
In-Reply-To: <s5hbm6l5cdi.wl-tiwai@suse.de>
References: <s5hbm6l5cdi.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Takashi,

Em Mon, 19 Nov 2018 16:13:29 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

> Hi,
>=20
> we've got a regression report on openSUSE Bugzilla regarding DVB-S PCI
> card:
>   https://bugzilla.opensuse.org/show_bug.cgi?id=3D1116374
>=20
> According to the reporter (Stakanov, Cc'ed), the card worked fine on
> 4.18.15, but since 4.19, it doesn't give any channels, sound nor
> picture, but only EPG is received.

Receiving just EPG is weird.

>=20
> The following errors might be relevant:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    4.845180] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver=
 chip loaded successfully
> [    4.869703] b2c2-flexcop: MAC address =3D xx:xx:xx:xx:xx:xx
> [    5.100318] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> [    5.100323] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adapter 0 =
frontend 0 (ST STV0299 DVB-S)...
> [    5.100370] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S re=
v 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete


> [  117.513086] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 f=
requency 1549000 out of range (950000..2150)
> [  124.905222] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 f=
requency 1880000 out of range (950000..2150)
> [  127.337079] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 f=
requency 1353500 out of range (950000..2150)

That indicates that it is trying to tune to an unsupported frequency. For
DVB-S, all frequencies above should be in kHz.

It is very weird that the low frequency is bigger than the higher one.

I suspect that this could be the root cause of the issue.

Yet, the entry at stv0299 (with apparently is the used frontend)
seems correct, as both min and max frequencies are in MHz:

static const struct dvb_frontend_ops stv0299_ops =3D {
	.delsys =3D { SYS_DVBS },
	.info =3D {
		.name			=3D "ST STV0299 DVB-S",
		.frequency_min_hz	=3D  950 * MHz,
		.frequency_max_hz	=3D 2150 * MHz,
		.frequency_stepsize_hz	=3D  125 * kHz,
		.symbol_rate_min	=3D 1000000,
		.symbol_rate_max	=3D 45000000,
		.symbol_rate_tolerance	=3D 500,	/* ppm */
		.caps =3D FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
		      FE_CAN_QPSK |
		      FE_CAN_FEC_AUTO
	},

It could be some mistake at the tuner (if this driver loads a
separate tuner).

=46rom the code, it seems that this specific board uses this tuner
from dvb-pll:

static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 =3D {
        .name =3D "Samsung TBMU24112",
        .min    =3D  950000,
        .max    =3D 2150000, /* guesses */
        .iffreq =3D 0,
        .count =3D 2,
        .entries =3D {
                { 1500000, 125, 0x84, 0x18 },
                { 9999999, 125, 0x84, 0x08 },
        }
};

Here, frequencies are in kHz. The code should be converting them to Hz=20
if the TV standard is satellite.


> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The lspci shows:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 06:06.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB=
 chip / Technisat SkyStar2 DVB card (rev 02)
>         Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / T=
echnisat SkyStar2 DVB card
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32
>         Interrupt: pin A routed to IRQ 20
>         NUMA node: 0
>         Region 0: Memory at fe500000 (32-bit, non-prefetchable) [size=3D6=
4K]
>         Region 1: I/O ports at b040 [size=3D32]
>         Kernel driver in use: b2c2_flexcop_pci
>         Kernel modules: b2c2_flexcop_pci
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Other details can be found in the bugzilla entry above.
>=20
> If any fix is known, please let me know.  I'll build a test kernel for
> openSUSE to confirm it.
>=20
>=20
> Thanks!
>=20
> Takashi



Thanks,
Mauro

--

Could you ask the user to apply the enclosed patch and provide us
the results of those prints?

diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst =
b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
index 0f8b31874002..60874a1f3d89 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _media_ioc_request_alloc:
=20
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst =
b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
index 6dd2d7fea714..3f481256f75a 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _media_request_ioc_queue:
=20
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst=
 b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
index febe888494c8..d9c4d308b477 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _media_request_ioc_reinit:
=20
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentat=
ion/media/uapi/mediactl/request-api.rst
index 5f4a23029c48..7a85b346db91 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _media-request-api:
=20
diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Doc=
umentation/media/uapi/mediactl/request-func-close.rst
index 098d7f2b9548..c85275a8870c 100644
--- a/Documentation/media/uapi/mediactl/request-func-close.rst
+++ b/Documentation/media/uapi/mediactl/request-func-close.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _request-func-close:
=20
diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Doc=
umentation/media/uapi/mediactl/request-func-ioctl.rst
index ff7b072a6999..8b69465bd2dd 100644
--- a/Documentation/media/uapi/mediactl/request-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _request-func-ioctl:
=20
diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Docu=
mentation/media/uapi/mediactl/request-func-poll.rst
index 85191254f381..8f58f9948cb6 100644
--- a/Documentation/media/uapi/mediactl/request-func-poll.rst
+++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
@@ -1,4 +1,15 @@
-.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant=
-sections
+.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
+..
+.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
+..
+.. For GFDL-1.1-or-later, see:
+..
+.. Permission is granted to copy, distribute and/or modify this document
+.. under the terms of the GNU Free Documentation License, Version 1.1 or
+.. any later version published by the Free Software Foundation, with no
+.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
+.. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
=20
 .. _request-func-poll:
=20
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core=
/dvb_frontend.c
index 961207cf09eb..bcdfe9939d64 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -917,6 +917,9 @@ static void dvb_frontend_get_frequency_limits(struct dv=
b_frontend *fe,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driv=
er\n",
 			 fe->dvb->num, fe->id);
=20
+printk("%s: frequencies: tuner: %u...%u, frontend: %u...%u",
+       __func__, tuner_min, tuner_max, frontend_min, frontend_max);
+
 	/* If the standard is for satellite, convert frequencies to kHz */
 	switch (c->delivery_system) {
 	case SYS_DVBS:
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-fron=
tends/dvb-pll.c
index 6d4b2eec67b4..62e81010b8cc 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -857,6 +857,8 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend=
 *fe, int pll_addr,
 		fe->ops.tuner_ops.info.frequency_min_hz =3D desc->min;
 		fe->ops.tuner_ops.info.frequency_max_hz =3D desc->max;
 	}
+printk("%s: delsys: %d, frequency range: %u..%u\n",
+       __func__, c->delivery_system, fe->ops.tuner_ops.info.frequency_min_=
hz, fe->ops.tuner_ops.info.frequency_max_hz);
=20
 	if (!desc->initdata)
 		fe->ops.tuner_ops.init =3D NULL;
