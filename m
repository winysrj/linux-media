Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40796 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcCYORw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 10:17:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 03/54] v4l: subdev: Call pad init_cfg operation when opening subdevs
Date: Fri, 25 Mar 2016 16:17:53 +0200
Message-ID: <5346418.Rs880v9JM0@avalon>
In-Reply-To: <56F531D7.1050700@xs4all.nl>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1458902668-1141-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <56F531D7.1050700@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 25 Mar 2016 13:40:55 Hans Verkuil wrote:
> On 03/25/2016 11:43 AM, Laurent Pinchart wrote:
> > The subdev core code currently rely on the subdev open handler to
> > initialize the file handle's pad configuration, even though subdevs now
> > have a pad operation dedicated for that purpose.
> > 
> > As a first step towards migration to init_cfg, call the operation
> > operation in the subdev core open implementation. Subdevs that haven't
> > been moved to init_cfg yet will just continue implementing pad config
> > initialization in their open handler.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-subdev.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index d4007f8f58d1..1fa6b713ee19
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -83,6 +83,12 @@ static int subdev_open(struct file *file)
> > 
> >  	}
> >  
> >  #endif
> > 
> > +#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> > +	ret = v4l2_subdev_call(sd, pad, init_cfg, subdev_fh->pad);
> > +	if (ret < 0 && ret != -ENOIOCTLCMD)
> > +		goto err;
> > +#endif
> 
> Am I missing something here? Doesn't the subdev_fh_init() call earlier in
> this function call pad.init_cfg already?

You're absolutely right, I'll drop this patch.

> > +
> > 
> >  	if (sd->internal_ops && sd->internal_ops->open) {
> >  	
> >  		ret = sd->internal_ops->open(sd, subdev_fh);
> >  		if (ret < 0)

-- 
Regards,

Laurent Pinchart

