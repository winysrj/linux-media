Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94668C07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 21:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426852082F
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 21:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 426852082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbeLIVSX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 16:18:23 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51058 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726194AbeLIVSX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 16:18:23 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 2289D634C7F;
        Sun,  9 Dec 2018 23:17:57 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gW6Sa-0000zz-SY; Sun, 09 Dec 2018 23:17:56 +0200
Date:   Sun, 9 Dec 2018 23:17:56 +0200
From:   sakari.ailus@iki.fi
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     jacopo mondi <jacopo@jmondi.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] media: v4l2-subdev: stub
 v4l2_subdev_get_try_format() ??
Message-ID: <20181209211756.kptepm4a6aufa6vf@valkosipuli.retiisi.org.uk>
References: <20181128171918.160643-1-lkundrak@v3.sk>
 <20181128171918.160643-2-lkundrak@v3.sk>
 <20181203134800.GA2901@w540>
 <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Lubomir, Jacopo,

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
> Please pardon my ignorance -- I don't actually understand why would
> anyone disable CONFIG_VIDEO_V4L2_SUBDEV_API.
> 
> I'll be following up with a v2 after I get a response from you. It will
> address locking issues found with smatch: one introduced by my patch
> and one that was there before.

Hans wrote a patch that enables VIDEO_V4L2_SUBDEV_API if
MEDIA_CAMERA_SUPPORT has been selected. So much of these #ifdefs will not
be needed going forward. It's an RFC for now, but that'd require a lot of
conditional compiling in drivers.

<URL:https://patchwork.linuxtv.org/patch/53370/>

The current use of the get_fmt callback serves the regular V4L2 API use, in
which case getting the try format is not meaningful.

-- 
Regards,

Sakari Ailus
