Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C8EC04EB9
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4E020892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4E020892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbeLFIay (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 03:30:54 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50165 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbeLFIay (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 03:30:54 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id CB45C60007;
        Thu,  6 Dec 2018 08:30:48 +0000 (UTC)
Date:   Thu, 6 Dec 2018 09:30:41 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] media: v4l2-subdev: stub
 v4l2_subdev_get_try_format() ??
Message-ID: <20181206083041.GA5597@w540>
References: <20181128171918.160643-1-lkundrak@v3.sk>
 <20181128171918.160643-2-lkundrak@v3.sk>
 <20181203134800.GA2901@w540>
 <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Lubomir,

On Tue, Dec 04, 2018 at 04:01:43PM +0100, Lubomir Rintel wrote:
> On Mon, 2018-12-03 at 14:48 +0100, jacopo mondi wrote:
> > Hi Lubomir,
> >
> >   thanks for the patches
> >
> > On Wed, Nov 28, 2018 at 06:19:13PM +0100, Lubomir Rintel wrote:
> > > Provide a dummy implementation when configured without
> > > CONFIG_VIDEO_V4L2_SUBDEV_API to avoid ifdef dance in the drivers
> > > that can
> > > be built either with or without the option.
> > >
> > > Suggested-by: Jacopo Mondi <jacopo@jmondi.org>
> > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > ---
> > >  include/media/v4l2-subdev.h | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-
> > > subdev.h
> > > index 9102d6ca566e..906e28011bb4 100644
> > > --- a/include/media/v4l2-subdev.h
> > > +++ b/include/media/v4l2-subdev.h
> > > @@ -967,6 +967,17 @@ static inline struct v4l2_rect
> > >  		pad = 0;
> > >  	return &cfg[pad].try_compose;
> > >  }
> > > +
> > > +#else /* !defined(CONFIG_VIDEO_V4L2_SUBDEV_API) */
> > > +
> > > +static inline struct v4l2_mbus_framefmt
> > > +*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
> > > +			    struct v4l2_subdev_pad_config *cfg,
> > > +			    unsigned int pad)
> > > +{
> > > +	return ERR_PTR(-ENOTTY);
> > > +}
> > > +
> > >  #endif
> >
> > While at there, what about doing the same for get_try_crop and
> > get_try_compose? At lease provide stubs, I let you figure out if
> > you're willing to fix callers too, it seems there are quite a few of
> > them though
> >
> > $ git grep v4l2_subdev_get_try* drivers/media/ | grep -v '_format' |
> > wc -l
> > 44
>
> I'd be happy to do that. However, the drivers that use those seem to
> depend on CONFIG_VIDEO_V4L2_SUBDEV_API anyway. Should those
> dependencies be eventually done away with?
>

I don't think it is the case to drop the dependencies. If you go down
that path you would need to be very careful. It's enough to add stubs
for those functions like you've done for v4l2_subdev_get_try_format().

Now, looking around a bit in more detail, most sensor drivers return
-ENOTTY if you require V4L2_SUBDEV_FORMAT_TRY format when
CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. I would say all drivers
but mt9v111.c, which is one of the most recent ones, and that deals
with the issue as:

static struct v4l2_mbus_framefmt *__mt9v111_get_pad_format(
					struct mt9v111_dev *mt9v111,
					struct v4l2_subdev_pad_config *cfg,
					unsigned int pad,
					enum v4l2_subdev_format_whence which)
{
	switch (which) {
	case V4L2_SUBDEV_FORMAT_TRY:
#if IS_ENABLED(CONFIG_VIDEO_V4L2_SUBDEV_API)
		return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);
#else
		return &cfg->try_fmt;
#endif
	case V4L2_SUBDEV_FORMAT_ACTIVE:
		return &mt9v111->fmt;
	default:
		return NULL;
	}
}

Since I wrote that part, and I recall it had been suggested to me, I
wonder which one of the two approaches it actually correct :/


> Please pardon my ignorance -- I don't actually understand why would
> anyone disable CONFIG_VIDEO_V4L2_SUBDEV_API.

The config options is described as:
Enables the V4L2 sub-device pad-level userspace API used to configure
video format, size and frame rate between hardware blocks.

Some driver simply do not expose a subdev in userspace. It might be
discussed that if selecting MEDIA_CONTROLLER should in facts be enough
and to imply CONFIG_VIDEO_V4L2_SUBDEV_API, but that's a separate
issue.
>
> I'll be following up with a v2 after I get a response from you. It will
> address locking issues found with smatch: one introduced by my patch
> and one that was there before.
>

Yep, ov2659 was b0rken already, thanks for fixing it while at there.

Thanks
   j

> Cheers,
> Lubo
>
> > >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> > > --
> > > 2.19.1
> > >
>

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcCN4mAAoJEHI0Bo8WoVY8rKIQAIT3SV0K+8AkDuJrAk4z98l/
/a3tpcWoDaE5nUeyuZHltlMRCwL94rf1gpIoIpn3xIftxW9oiZz35kNpwcke51ou
J9sqUgTk5K+/PkeneYcM8+ft9G3isSeMFtSXfPpD8mtj6hxpys1THgizx/obPdP+
Wt2CwBS/AS/lpLnBMNJhCZEXM5uzDBmr90XtA78IQ/8rOsaDie/q8WXxIjB2S5Kz
DyoCKJpeMgqy9id4iFlk7OqOdVOWss1NYP0UcjXRKzc35YWIx4kFXADAAJYD6kd3
xG1ACPHTMmMsDE9UPgOa8frlTgaOIHwP+48aIUXBn2VtrrSs6sEz1Bpc66UljLBH
rn1mt3Yn2DopIy+3oqr6ObCcOi8TwKqfmdzBDnpGzdOyVynNuClmWM33VWeWG9uk
kEyDPbIKpMEj4DfaMsv1Y5hxBV3UVGtplaR7WalVwpxr3nvRBnU7YzbkhjEBSdel
GWON0fEDJZJbKQeFafpIWQK9k1AOgy4sbI+Uu4JmeLhRLCQEiWa40rdZ2Do950F1
8uY2xH7uTkGFsN1DR86VlqANsksxtJ0AknFTo0VjRwxAiK2Ga+CN04hr+GOXq1yc
u+CYbAXkp1TtFVh1Wa2IXKA95X3g9svS9jn5GLeTTiC9MInvYeckiu/nPQxVtFLs
rBUF7FyGRc2xPJXe0LDJ
=QBzN
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
