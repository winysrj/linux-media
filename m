Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36795 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935337AbdLRXGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 18:06:39 -0500
Received: by mail-lf0-f66.google.com with SMTP id f20so19597310lfe.3
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 15:06:39 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 19 Dec 2017 00:06:37 +0100
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 01/15] v4l2-subdev.h: add pad and stream aware
 s_stream
Message-ID: <20171218230637.GE32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-2-niklas.soderlund+renesas@ragnatech.se>
 <20171215115146.rme5bv2qbebft2ba@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171215115146.rme5bv2qbebft2ba@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Tack för dina kommentarer.

On 2017-12-15 13:51:46 +0200, Sakari Ailus wrote:
> Hejssan Niklas,
> 
> Tack för uppdaterade lappor!
> 
> On Thu, Dec 14, 2017 at 08:08:21PM +0100, Niklas Söderlund wrote:
> > To be able to start and stop individual streams of a multiplexed pad the
> > s_stream operation needs to be both pad and stream aware. Add a new
> > operation to pad ops to facilitate this.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  include/media/v4l2-subdev.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index a30a94fad8dbacde..7288209338a48fda 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -669,6 +669,9 @@ struct v4l2_subdev_pad_config {
> >   *
> >   * @set_frame_desc: set the low level media bus frame parameters, @fd array
> >   *                  may be adjusted by the subdev driver to device capabilities.
> > + *
> > + * @s_stream: used to notify the driver that a stream will start or has
> > + *	stopped.
> 
> This is actually the callback which is used to control the stream state.
> The above suggests that it's a notification of something that has happened
> (or about to happen). How about:
> 
> Enable or disable streaming on a sub-device pad.

Better, will use it in next version.

> 
> >   */
> >  struct v4l2_subdev_pad_ops {
> >  	int (*init_cfg)(struct v4l2_subdev *sd,
> > @@ -713,6 +716,8 @@ struct v4l2_subdev_pad_ops {
> >  			   struct v4l2_subdev_routing *route);
> >  	int (*set_routing)(struct v4l2_subdev *sd,
> >  			   struct v4l2_subdev_routing *route);
> > +	int (*s_stream)(struct v4l2_subdev *sd, unsigned int pad,
> > +			unsigned int stream, int enable);
> 
> How about bool for enable?

I tried to use what the current s_stream uses, but I be happy to make 
enable a bool in the next version.

> 
> >  };
> >  
> >  /**
> 
> -- 
> Sakari Ailus
> sakari.ailus@linux.intel.com

-- 
Regards,
Niklas Söderlund
