Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59474 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036AbcEIVDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 17:03:01 -0400
Date: Tue, 10 May 2016 00:02:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 3/3] v4l: subdev: Call pad init_cfg operation when
 opening subdevs
Message-ID: <20160509210223.GQ26360@valkosipuli.retiisi.org.uk>
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462361133-23887-4-git-send-email-sakari.ailus@linux.intel.com>
 <2951447.PnEFV895ES@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2951447.PnEFV895ES@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, May 09, 2016 at 07:18:11PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 04 May 2016 14:25:33 Sakari Ailus wrote:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > The subdev core code currently rely on the subdev open handler to
> > initialize the file handle's pad configuration, even though subdevs now
> > have a pad operation dedicated for that purpose.
> > 
> > As a first step towards migration to init_cfg, call the operation
> > operation in the subdev core open implementation. Subdevs that are
> > haven't been moved to init_cfg yet will just continue implementing pad
> > config initialization in their open handler.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-subdev.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index 224ea60..9cbd011 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -85,6 +85,8 @@ static int subdev_open(struct file *file)
> >  	}
> >  #endif
> > 
> > +	v4l2_subdev_call(sd, pad, init_cfg, subdev_fh->pad);
> > +
> 
> Given that v4l2_subdev_alloc_pad_config(), called by subdev_fh_init(), already 
> calls the init_cfg operation, is this still needed ?

It's your patch. ;-)

Yeah, after looking at the code, I agree to drop it.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
