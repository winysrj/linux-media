Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4028 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3GJOrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 10:47:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 5/5] v4l: Renesas R-Car VSP1 driver
Date: Wed, 10 Jul 2013 16:47:26 +0200
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <201307101434.25019.hverkuil@xs4all.nl> <37123229.iGJOoGNLf7@avalon>
In-Reply-To: <37123229.iGJOoGNLf7@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307101647.26582.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed July 10 2013 16:24:58 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the very quick review.
> 
> On Wednesday 10 July 2013 14:34:24 Hans Verkuil wrote:
> > On Wed 10 July 2013 12:19:32 Laurent Pinchart wrote:
> > > The VSP1 is a video processing engine that includes a blender, scalers,
> > > filters and statistics computation. Configurable data path routing logic
> > > allows ordering the internal blocks in a flexible way.
> > > 
> > > Due to the configurable nature of the pipeline the driver implements the
> > > media controller API and doesn't use the V4L2 mem-to-mem framework, even
> > > though the device usually operates in memory to memory mode.
> > > 
> > > Only the read pixel formatters, up/down scalers, write pixel formatters
> > > and LCDC interface are supported at this stage.
> > > 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/platform/Kconfig            |   10 +
> > >  drivers/media/platform/Makefile           |    2 +
> > >  drivers/media/platform/vsp1/Makefile      |    5 +
> > >  drivers/media/platform/vsp1/vsp1.h        |   73 ++
> > >  drivers/media/platform/vsp1/vsp1_drv.c    |  475 ++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_entity.c |  186 +++++
> > >  drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
> > >  drivers/media/platform/vsp1/vsp1_lif.c    |  237 ++++++
> > >  drivers/media/platform/vsp1/vsp1_lif.h    |   38 +
> > >  drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
> > >  drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
> > >  drivers/media/platform/vsp1/vsp1_rwpf.h   |   56 ++
> > >  drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
> > >  drivers/media/platform/vsp1/vsp1_uds.h    |   41 +
> > >  drivers/media/platform/vsp1/vsp1_video.c  | 1154 ++++++++++++++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
> > >  drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
> > >  include/linux/platform_data/vsp1.h        |   25 +
> > >  19 files changed, 4007 insertions(+)
> > >  create mode 100644 drivers/media/platform/vsp1/Makefile
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
> > >  create mode 100644 include/linux/platform_data/vsp1.h
> > 
> > Hi Laurent,
> > 
> > It took some effort, but I finally did find some things to complain about
> > :-)
> 
> :-)
> 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > > b/drivers/media/platform/vsp1/vsp1_video.c new file mode 100644
> > > index 0000000..47a739a
> > > --- /dev/null
> > > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> 
> [snip]
> 
> > > +static int __vsp1_video_try_format(struct vsp1_video *video,
> > > +				   struct v4l2_pix_format_mplane *pix,
> > > +				   const struct vsp1_format_info **fmtinfo)
> > > +{
> > > +	const struct vsp1_format_info *info;
> > > +	unsigned int width = pix->width;
> > > +	unsigned int height = pix->height;
> > > +	unsigned int i;
> > > +
> > > +	/* Retrieve format information and select the default format if the
> > > +	 * requested format isn't supported.
> > > +	 */
> > > +	info = vsp1_get_format_info(pix->pixelformat);
> > > +	if (info == NULL)
> > > +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> > > +
> > > +	pix->pixelformat = info->fourcc;
> > > +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> > > +	pix->field = V4L2_FIELD_NONE;
> > 
> > pix->priv should be set to 0. v4l2-compliance catches such errors, BTW.
> 
> Isn't this handled by the CLEAR_AFTER_FIELD() macros in v4l2-ioctl2.c ?

For G_FMT, yes, but there is no CLEAR_AFTER_FIELD for S/TRY_FMT. So priv
needs to be zeroed manually.

Regards,

	Hans
