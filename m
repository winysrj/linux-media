Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47932 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730632AbeKWHQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 02:16:57 -0500
Date: Thu, 22 Nov 2018 18:35:49 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: stakanov <stakanov@eclipso.eu>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181122183549.331ecbc4@coco.lan>
In-Reply-To: <12757009.r0OKxgvFl0@roadrunner.suse>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
        <2836654.gWKGMNFOG2@roadrunner.suse>
        <20181122180611.2e7f1123@coco.lan>
        <12757009.r0OKxgvFl0@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Nov 2018 21:19:49 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> Hello Mauro.=20
>=20
> Thank you so much, for this fast reply and especially for the detailed=20
> indications. I expected to have a lack of knowledge.=20
>=20
> Well,  I am replying to the question as of below: (for convenience I did =
cut=20
> the before text, if you deem it useful for the list I can then correct th=
at in=20
> the next posts).
>=20
> In data gioved=C3=AC 22 novembre 2018 21:06:11 CET, Mauro Carvalho Chehab=
 ha=20
> scritto:
> > Are you sure that the difference is just the Kernel version? Perhaps you
> > also updated some other package. =20
>=20
> To be clear: I had the same system(!) with all three kernel 4.18.15-1, 4.=
19.1 =20
> (when the problem did arise) and 4.20.2 rc3 from Takashi's repo) installe=
d.=20

Ok, so rebooting to 4.18.15-1 solves the issue?

Also, what GPU driver are you using?

In any case, by using the old "Universal" LNBf, you're likely missing some
transponders, and missing several channels.

> In this very configuration: if one booted in 4.18 (that is in perfect par=
ity=20
> with all other packages) the card worked. 4.19.1 no. And the last kernel =
the=20
> same. So whatever might be different, forcefully it has to be in the kern=
el.=20
> (Which is not really a problem if I manage to make it work, so settings w=
ill=20
> be known to others or, if not, we will find out what is different, and al=
l=20
> will be happy. As you see I am still optimist). =20

Well, we don't want regressions in Kernel. If there's an issue there,
it should be fixed. However, I can't think on any other changes since
4.18 that would be causing troubles for b2c2 driver.

See, the only change at the driver itself is just a simple API
replacement that wouldn't cause this kind of problems:

	$ git log --oneline v4.18.. drivers/media/common/b2c2/
	c0decac19da3 media: use strscpy() instead of strlcpy()

There were a few changes at the DVB core:

	$ git log --no-merges --oneline v4.18.. drivers/media/dvb-core/
	f3efe15a2f05 media: dvb: use signal types to discover pads
	b5d3206112dd media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
	cc1e6315e83d media: replace strcpy() by strscpy()
	c0decac19da3 media: use strscpy() instead of strlcpy()
	fd89e0bb6ebf media: videobuf2-core: integrate with media requests
	db6e8d57e2cd media: vb2: store userspace data in vb2_v4l2_buffer
	6a2a1ca34ca6 media: dvb_frontend: ensure that the step is ok for both FE a=
nd tuner
	f1b1eabff0eb media: dvb: represent min/max/step/tolerance freqs in Hz
	a3f90c75b833 media: dvb: convert tuner_info frequencies to Hz
	6706fe55af6f media: dvb_ca_en50221: off by one in dvb_ca_en50221_io_do_ioc=
tl()
	4d1e4545a659 media: mark entity-intf links as IMMUTABLE

But, on a first glance, the only ones that has potential to cause issues
were the ones addressed that the patch I wrote (merged by Takashi).

If you're really receiving data from EPG (you may just have it
cached), it means that the DVB driver is doing the right thing.

Btw, to be sure that you're not just seeing the old EPG data, you
should move or remove this file:

	~/.local/share/kaffeine/epgdata.dvb

Kaffeine will generate a new one again once it tunes into a TV channel.

> I will proceed as indicated and report back here tomorrow.=20

Ok.

Thanks,
Mauro
