Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F54AC282CB
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D4420881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfA1IfD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:35:03 -0500
Received: from mga17.intel.com ([192.55.52.151]:39146 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbfA1IfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:35:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2019 00:34:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,533,1539673200"; 
   d="scan'208";a="111612207"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 28 Jan 2019 00:34:57 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 5BDC320609; Mon, 28 Jan 2019 10:34:56 +0200 (EET)
Date:   Mon, 28 Jan 2019 10:34:56 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v3 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
Message-ID: <20190128083455.ilql2qtxtlv3doga@paasikivi.fi.intel.com>
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
 <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com>
 <20190123151750.5s5efpear43pq2uj@pengutronix.de>
 <CAC5umyiU02KjY45RbuvO21xsUetpDe-HoVYyjSMWNGN5j3XDTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyiU02KjY45RbuvO21xsUetpDe-HoVYyjSMWNGN5j3XDTg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mita-san, Marco,

On Sun, Jan 27, 2019 at 09:29:30PM +0900, Akinobu Mita wrote:
> 2019年1月24日(木) 0:17 Marco Felsch <m.felsch@pengutronix.de>:
> >
> > Hi Akinobu,
> >
> > sorry for the delayed response.
> >
> > On 19-01-15 23:05, Akinobu Mita wrote:
> > > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> > > is specified.
> > >
> > > Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > Cc: Marco Felsch <m.felsch@pengutronix.de>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > > * v3
> > > - Set initial try format with default configuration instead of
> > >   current one.
> > >
> > >  drivers/media/i2c/mt9m111.c | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> > > index d639b9b..63a5253 100644
> > > --- a/drivers/media/i2c/mt9m111.c
> > > +++ b/drivers/media/i2c/mt9m111.c
> > > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
> > >       if (format->pad)
> > >               return -EINVAL;
> > >
> > > +     if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> > > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > > +             mf = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> > > +             format->format = *mf;
> > > +             return 0;
> > > +#else
> > > +             return -ENOTTY;
> > > +#endif
> >
> > If've checked this again and found the ov* devices do this too. IMO it's
> > not good for other developers to check the upper layer if the '#else'
> > path is reachable. There are also some code analyzer tools which will
> > report this as issue/warning.
> >
> > As I said, I checked the v4l2_subdev_get_try_format() usage again and
> > found the solution made by the mt9v111.c better. Why do you don't add a
> > dependency in the Kconfig, so we can drop this ifdef?
> 
> I'm ok with adding CONFIG_VIDEO_V4L2_SUBDEV_API dependency to this
> driver, because I always enable it.
> 
> But it may cause an issue on some environments that don't require
> CONFIG_VIDEO_V4L2_SUBDEV_API.
> 
> Sakari, do you have any opinion?

I think the dependency is just fine. There are drivers that do not support
MC (and V4L2 sub-device uAPI) but if a driver does, I don't see why it
couldn't depend on the related Kconfig option.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
