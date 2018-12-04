Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:43983 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbeLDPBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 10:01:51 -0500
Message-ID: <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
Subject: Re: [PATCH 1/6] media: v4l2-subdev: stub
 v4l2_subdev_get_try_format() =?ISO-8859-1?Q?=1B=1B?=
From: Lubomir Rintel <lkundrak@v3.sk>
To: jacopo mondi <jacopo@jmondi.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2018 16:01:43 +0100
In-Reply-To: <20181203134800.GA2901@w540>
References: <20181128171918.160643-1-lkundrak@v3.sk>
         <20181128171918.160643-2-lkundrak@v3.sk> <20181203134800.GA2901@w540>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-12-03 at 14:48 +0100, jacopo mondi wrote:
> Hi Lubomir,
> 
>   thanks for the patches
> 
> On Wed, Nov 28, 2018 at 06:19:13PM +0100, Lubomir Rintel wrote:
> > Provide a dummy implementation when configured without
> > CONFIG_VIDEO_V4L2_SUBDEV_API to avoid ifdef dance in the drivers
> > that can
> > be built either with or without the option.
> > 
> > Suggested-by: Jacopo Mondi <jacopo@jmondi.org>
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > ---
> >  include/media/v4l2-subdev.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-
> > subdev.h
> > index 9102d6ca566e..906e28011bb4 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -967,6 +967,17 @@ static inline struct v4l2_rect
> >  		pad = 0;
> >  	return &cfg[pad].try_compose;
> >  }
> > +
> > +#else /* !defined(CONFIG_VIDEO_V4L2_SUBDEV_API) */
> > +
> > +static inline struct v4l2_mbus_framefmt
> > +*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
> > +			    struct v4l2_subdev_pad_config *cfg,
> > +			    unsigned int pad)
> > +{
> > +	return ERR_PTR(-ENOTTY);
> > +}
> > +
> >  #endif
> 
> While at there, what about doing the same for get_try_crop and
> get_try_compose? At lease provide stubs, I let you figure out if
> you're willing to fix callers too, it seems there are quite a few of
> them though
> 
> $ git grep v4l2_subdev_get_try* drivers/media/ | grep -v '_format' |
> wc -l
> 44

I'd be happy to do that. However, the drivers that use those seem to
depend on CONFIG_VIDEO_V4L2_SUBDEV_API anyway. Should those
dependencies be eventually done away with?

Please pardon my ignorance -- I don't actually understand why would
anyone disable CONFIG_VIDEO_V4L2_SUBDEV_API.

I'll be following up with a v2 after I get a response from you. It will
address locking issues found with smatch: one introduced by my patch
and one that was there before.

Cheers,
Lubo

> >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> > --
> > 2.19.1
> > 
