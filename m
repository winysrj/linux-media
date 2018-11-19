Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41820 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbeKTJex (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 04:34:53 -0500
Date: Mon, 19 Nov 2018 21:08:45 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: stakanov <stakanov@eclipso.eu>
Cc: Takashi Iwai <tiwai@suse.de>,
        Stakanov Schufter <stakanov@freenet.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181119210845.38072faf@coco.lan>
In-Reply-To: <2988162.jBOhpiBzca@roadrunner.suse>
References: <s5hbm6l5cdi.wl-tiwai@suse.de>
        <20181119155326.24f6083f@coco.lan>
        <s5hwop8g88o.wl-tiwai@suse.de>
        <2988162.jBOhpiBzca@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Nov 2018 23:59:39 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> In data luned=C3=AC 19 novembre 2018 20:47:19 CET, Takashi Iwai ha scritt=
o:
> > On Mon, 19 Nov 2018 18:53:26 +0100,
> >=20
> > Mauro Carvalho Chehab wrote: =20
> > > Could you ask the user to apply the enclosed patch and provide us
> > > the results of those prints? =20
> >=20
> > OK, I built a test kernel in OBS home:tiwai:bsc1116374 repo.  Now it's
> > available at
> > =20
> > https://download.opensuse.org/repositories/home:/tiwai:/bsc1116374/stan=
dard
> > /
> >=20
> > Stakanov, could you test it and give the kernel messages?
> >=20
> >=20
> > Thanks!
> >=20
> > Takashi =20
> Here we go, I did saw your mail only late, sorry.
>=20
>=20
> Result of proposed fix (rc3): card has still no function, does not sync, =
EPG=20
> works. No sound no picture.=20

This is not a fix. It just adds some new messages that should help to
explain why the frequency range seems wrong.

>=20
> entropy@silversurfer:~> uname -a        =20
> Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon Nov 1=
9=20
> 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux
>=20
> output of=20
> entropy@silversurfer:~> sudo dmesg | grep -i b2c2  =20
> [    4.831163] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver=
 chip=20
> loaded successfully
> [    4.862648] b2c2-flexcop: MAC address =3D xx:xx:xx:xx:xx:xx
> [    5.094173] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> [    5.094177] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adapter 0=
=20
> frontend 0 (ST STV0299 DVB-S)...
> [    5.094248] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S re=
v=20
> 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> [  121.789236] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1880000 out of range (950000..2150)
> [  128.817325] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1944750 out of range (950000..2150)

Are you sure you booted the right Kernel? I'm not seeing the new messages
here that should be printing the tuner and frontend frequency ranges.

>=20
> sudo lspci -vvv =20
> 06:06.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB=
 chip=20
> / Technisat SkyStar2 DVB card (rev 02)
>         Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /=20
> Technisat SkyStar2 DVB card
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r-=20
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort-=
=20
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32
>         Interrupt: pin A routed to IRQ 20
>         NUMA node: 0
>         Region 0: Memory at fe500000 (32-bit, non-prefetchable) [size=3D6=
4K]
>         Region 1: I/O ports at b040 [size=3D32]
>         Kernel driver in use: b2c2_flexcop_pci
>         Kernel modules: b2c2_flexcop_pci
>=20
>=20
>=20
>=20
> _________________________________________________________________
> ________________________________________________________
> Ihre E-Mail-Postf=C3=A4cher sicher & zentral an einem Ort. Jetzt wechseln=
 und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
>=20
>=20



Thanks,
Mauro
