Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45740 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731729AbeKTKY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 05:24:57 -0500
Date: Mon, 19 Nov 2018 21:58:41 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: stakanov <stakanov@eclipso.eu>
Cc: linux-media@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181119215841.0a3abd37@coco.lan>
In-Reply-To: <1837109.xExTbI5ikD@roadrunner.suse>
References: <s5hbm6l5cdi.wl-tiwai@suse.de>
        <2988162.jBOhpiBzca@roadrunner.suse>
        <20181119210845.38072faf@coco.lan>
        <1837109.xExTbI5ikD@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Nov 2018 00:19:54 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> In data marted=C3=AC 20 novembre 2018 00:08:45 CET, Mauro Carvalho Chehab=
 ha=20
> scritto:
> >  uname -a
> >  =20
> > > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon N=
ov 19
> > > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux =20
>=20
>  uname -a        =20
> > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon Nov=
 19=20
> > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux =20
>=20
> from https://download.opensuse.org/repositories/home:/tiwai:/bsc1116374/
> standard/x86_64/
>=20
> So I booted this one, should be the right one.=20
> sudo dmesg | grep -i b2c2   should give these additional messages?=20
>=20
> If Takashi is still around, he could confirm.=20

Well, if the patch got applied, you should  now be getting messages similar=
=20
(but not identical) to:

	dvb_frontend_get_frequency_limits: frequencies: tuner: 9150000...2150000, =
frontend: 9150000...2150000
	dvb_pll_attach: delsys: 5, frequency range: 9150000..2150000

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
