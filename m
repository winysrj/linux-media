Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57584 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388876AbeKXELp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 23:11:45 -0500
Date: Fri, 23 Nov 2018 15:26:25 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: stakanov <stakanov@eclipso.eu>, Takashi Iwai <tiwai@suse.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>, Brad Love <brad@nextdimension.cc>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181123152625.7992ceb4@coco.lan>
In-Reply-To: <4969775.51lmc1uXLO@roadrunner.suse>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
        <12757009.r0OKxgvFl0@roadrunner.suse>
        <20181122183549.331ecbc4@coco.lan>
        <4969775.51lmc1uXLO@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stakarov,

Em Fri, 23 Nov 2018 16:55:35 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> In data gioved=C3=AC 22 novembre 2018 21:35:49 CET, Mauro Carvalho Chehab=
 ha=20
> scritto:
> > Em Thu, 22 Nov 2018 21:19:49 +0100
> >=20
> > stakanov <stakanov@eclipso.eu> escreveu: =20
> > > Hello Mauro.
> > >=20
> > > Thank you so much, for this fast reply and especially for the detailed
> > > indications. I expected to have a lack of knowledge.
> > >=20
> > > Well,  I am replying to the question as of below: (for convenience I =
did
> > > cut the before text, if you deem it useful for the list I can then
> > > correct that in the next posts).
> > >=20
> > > In data gioved=C3=AC 22 novembre 2018 21:06:11 CET, Mauro Carvalho Ch=
ehab ha
> > >=20
> > > scritto: =20
> > > > Are you sure that the difference is just the Kernel version? Perhap=
s you
> > > > also updated some other package. =20
> > >=20
> > > To be clear: I had the same system(!) with all three kernel 4.18.15-1,
> > > 4.19.1 (when the problem did arise) and 4.20.2 rc3 from Takashi's rep=
o)
> > > installed. =20
> > Ok, so rebooting to 4.18.15-1 solves the issue?
> >=20
> > Also, what GPU driver are you using?
> >=20
> > In any case, by using the old "Universal" LNBf, you're likely missing s=
ome
> > transponders, and missing several channels.
> >  =20
> > > In this very configuration: if one booted in 4.18 (that is in perfect
> > > parity with all other packages) the card worked. 4.19.1 no. And the l=
ast
> > > kernel the same. So whatever might be different, forcefully it has to=
 be
> > > in the kernel. (Which is not really a problem if I manage to make it
> > > work, so settings will be known to others or, if not, we will find out
> > > what is different, and all will be happy. As you see I am still
> > > optimist). =20
> >=20
> > Well, we don't want regressions in Kernel. If there's an issue there,
> > it should be fixed. However, I can't think on any other changes since
> > 4.18 that would be causing troubles for b2c2 driver.
> >=20
> > See, the only change at the driver itself is just a simple API
> > replacement that wouldn't cause this kind of problems:
> >=20
> > 	$ git log --oneline v4.18.. drivers/media/common/b2c2/
> > 	c0decac19da3 media: use strscpy() instead of strlcpy()
> >=20
> > There were a few changes at the DVB core:
> >=20
> > 	$ git log --no-merges --oneline v4.18.. drivers/media/dvb-core/
> > 	f3efe15a2f05 media: dvb: use signal types to discover pads
> > 	b5d3206112dd media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
> > 	cc1e6315e83d media: replace strcpy() by strscpy()
> > 	c0decac19da3 media: use strscpy() instead of strlcpy()
> > 	fd89e0bb6ebf media: videobuf2-core: integrate with media requests
> > 	db6e8d57e2cd media: vb2: store userspace data in vb2_v4l2_buffer
> > 	6a2a1ca34ca6 media: dvb_frontend: ensure that the step is ok for both =
FE
> > and tuner f1b1eabff0eb media: dvb: represent min/max/step/tolerance fre=
qs
> > in Hz a3f90c75b833 media: dvb: convert tuner_info frequencies to Hz
> > 	6706fe55af6f media: dvb_ca_en50221: off by one in
> > dvb_ca_en50221_io_do_ioctl() 4d1e4545a659 media: mark entity-intf links=
 as
> > IMMUTABLE
> >=20
> > But, on a first glance, the only ones that has potential to cause issues
> > were the ones addressed that the patch I wrote (merged by Takashi).
> >=20
> > If you're really receiving data from EPG (you may just have it
> > cached), it means that the DVB driver is doing the right thing.
> >=20
> > Btw, to be sure that you're not just seeing the old EPG data, you
> > should move or remove this file:
> >=20
> > 	~/.local/share/kaffeine/epgdata.dvb
> >=20
> > Kaffeine will generate a new one again once it tunes into a TV channel.
> >  =20
> > > I will proceed as indicated and report back here tomorrow. =20
> >=20
> > Ok.
> >=20
> > Thanks,
> > Mauro =20
> So, I confirm that:
> a) 4.18.15-1 this card worked flawlessly.
> b) above that, included the kernel with correction, it does not work any =
more.
> c) downloading and copying the respective firmware from openelec does not=
=20
> change, the card stays dead.=20
> d) astra: no search of channels, search interrupted after seconds.
> e) hotbird: search without finding any channel - only noise
> f) lnbf setting was to "Astra E" as indicated.=20
> g) after erasing the file in local/share it is clear that EPG data does N=
OT=20
> work either.
> When using the channels as they were recorded before, the signal strength=
 is 0=20
> but the fictional led is green (as if it would receive).=20
>=20
>=20
>=20
> No picture, no tone, no channel sync, no EPG. A brick.=20
> So, with 4.18 that worked, only that now (due to an error I lost access t=
o the=20
> 4.18.15-1 driver of TW, so if Takashi has a link, I can reinstall it and =
we=20
> can check if, parity all packages this is still the case. I assure you th=
at it=20
> was, but that would be a perfect proof.=20
> Firmware downloaded and installed in /lib/firmware was:
> https://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_S2 following the=
 link=20
> to open Elec:
>=20
> https://github.com/OpenELEC/dvb-firmware/blob/master/firmware/dvb-fe-cx24=
120-1.20.58.2.fw

Thank you for the tests. Yeah, from what you're describing, there's
still another Kernel bug that the frequency patch didn't fix.

I'm c/c a few DVB developers. Maybe they may have some ideas about
what's happening or may have some b2c2-based board to run some tests.
I'm very busy up to next Wed, so it is unlikely that I would have any
time to look on it. Also, I don't have any b2c2 board to test.

Yet, let's do one last attempt: could you please test if the
enclosed patch changes anything? This was supposed to be just
a cleanup, but, after thinking a little bit, I guess it may fix
the issue you're reporting.

In order to make easier for people to test it, I'm applying the 3 patch
series I posted on my tree, plus the enclosed followup cleanup
patch at linux_media development tree. With that, everyone will
have a common base for the tests.

Takashi,

Could you please produce a Kernel for Stakanov to test
with the following patches:

https://patchwork.linuxtv.org/patch/53044/
https://patchwork.linuxtv.org/patch/53045/
https://patchwork.linuxtv.org/patch/53046/
https://patchwork.linuxtv.org/patch/53128/

Stakanov,

Before booting the new Kernel, please create a new file
as /etc/modprobe.d/media.conf with:

	options dvb-core debug=3D1
	options dvb-pll debug=3D1

With this, the next time the Kernel boots, it will cause both
dvb-core and dvb-pll to be more verbose, enabling the new debug
messages that the above patches add. Once we get this fixed,
you may remove the file (or comment the lines), in order to
avoid uneeded messages on your dmesg.

Thanks,
Mauro

[PATCH] media: dvb-pll: don't re-validate tuner frequencies

The dvb_frontend core already checks for the frequencies. No
need for any additional check inside the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-fron=
tends/dvb-pll.c
index fff5816f6ec4..29836c1a40e9 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -610,9 +610,6 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u=
8 *buf,
 	u32 div;
 	int i;
=20
-	if (frequency && (frequency < desc->min || frequency > desc->max))
-		return -EINVAL;
-
 	for (i =3D 0; i < desc->count; i++) {
 		if (frequency > desc->entries[i].limit)
 			continue;
