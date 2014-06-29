Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58263 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaF2Uk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jun 2014 16:40:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 03/23] v4l: Support extending the v4l2_pix_format structure
Date: Sun, 29 Jun 2014 22:41:49 +0200
Message-ID: <1472072.9G9DmhPU1u@avalon>
In-Reply-To: <53AD6558.9050403@xs4all.nl>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53AD6558.9050403@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Friday 27 June 2014 14:36:40 Hans Verkuil wrote:
> Hi Laurent,
> 
> Some comments below...
> 
> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
> > The v4l2_pix_format structure has no reserved field. It is embedded in
> > the v4l2_framebuffer structure which has no reserved fields either, and
> > in the v4l2_format structure which has reserved fields that were not
> > previously required to be zeroed out by applications.
> > 
> > To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
> > structure, and use the priv field as a magic value to indicate that the
> > application has set all v4l2_pix_format extended fields and zeroed all
> > reserved fields following the v4l2_pix_format field in the v4l2_format
> > structure.
> > 
> > The availability of this API extension is reported to userspace through
> > the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
> > priv field is still set to the magic value at [GS]_FMT return wouldn't
> > be enough, as older kernels don't zero the priv field on return.
> > 
> > To simplify the internal API towards drivers zero the extended fields
> > and set the priv field to the magic value for applications not aware of
> > the extensions.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >   Documentation/DocBook/media/Makefile               |  2 +-
> >   Documentation/DocBook/media/v4l/pixfmt.xml         | 25 +++++++--
> >   Documentation/DocBook/media/v4l/v4l2.xml           |  8 +++
> >   .../DocBook/media/v4l/vidioc-querycap.xml          |  6 +++
> >   drivers/media/parport/bw-qcam.c                    |  2 -
> >   drivers/media/pci/cx18/cx18-ioctl.c                |  1 -
> >   drivers/media/pci/cx25821/cx25821-video.c          |  3 --
> >   drivers/media/pci/ivtv/ivtv-ioctl.c                |  3 --
> >   drivers/media/pci/meye/meye.c                      |  2 -
> >   drivers/media/pci/saa7134/saa7134-empress.c        |  3 --
> >   drivers/media/pci/saa7134/saa7134-video.c          |  2 -
> >   drivers/media/pci/sta2x11/sta2x11_vip.c            |  1 -
> >   drivers/media/platform/coda.c                      |  2 -
> >   drivers/media/platform/davinci/vpif_display.c      |  1 -
> >   drivers/media/platform/mem2mem_testdev.c           |  1 -
> >   drivers/media/platform/omap/omap_vout.c            |  2 -
> >   drivers/media/platform/sh_veu.c                    |  2 -
> >   drivers/media/platform/vino.c                      |  5 --
> >   drivers/media/platform/vivi.c                      |  1 -
> >   drivers/media/usb/cx231xx/cx231xx-417.c            |  2 -
> >   drivers/media/usb/cx231xx/cx231xx-video.c          |  2 -
> >   drivers/media/usb/gspca/gspca.c                    |  8 +--
> >   drivers/media/usb/hdpvr/hdpvr-video.c              |  1 -
> >   drivers/media/usb/stkwebcam/stk-webcam.c           |  2 -
> >   drivers/media/usb/tlg2300/pd-video.c               |  1 -
> >   drivers/media/usb/tm6000/tm6000-video.c            |  2 -
> >   drivers/media/usb/zr364xx/zr364xx.c                |  3 --
> >   drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 19 +++++--
> >   drivers/media/v4l2-core/v4l2-ioctl.c               | 61 ++++++++++++++--
> >   include/uapi/linux/videodev2.h                     | 15 +++++-
> >   30 files changed, 126 insertions(+), 62 deletions(-)
> > 

[snip]

> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index 16bffd8..01b4588 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c

[snip]

> > @@ -1089,12 +1124,17 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops
> > *ops,
> >   	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> >   	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> >   	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> > +	int ret;
> > +
> > +	v4l_sanitize_format(p);
> 
> Note: before g_fmt is called all fields after 'type' are zeroed.
> So it is enough to just set priv to the magic value here.

Agreed, I can change that.

> >   	switch (p->type) {
> >   	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >   		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
> >   			break;
> > -		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> > +		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> > +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> 
> v4l_sanitize_format already sets priv to PRIV_MAGIC, so there is no need to
> do it again.

Except that the vidioc_g_fmt_vid_cap() implementation might have zeroed it. 
I've removed the priv assignments to zero in drivers wherever I found them, 
but I might have missed one, hence the explicit assignment here.

> > +		return ret;
> >   	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> >   		if (unlikely(!is_rx || !is_vid || !ops-
>vidioc_g_fmt_vid_cap_mplane))
> >   			break;
> > @@ -1114,7 +1154,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops
> > *ops,> 
> >   	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >   		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
> >   			break;
> > -		return ops->vidioc_g_fmt_vid_out(file, fh, arg);
> > +		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
> > +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> 
> Ditto.

Same explanation as above.

> > +		return ret;
> >   	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >   		if (unlikely(!is_tx || !is_vid || !ops-
>vidioc_g_fmt_vid_out_mplane))
> >   			break;
> > @@ -1502,7 +1544,18 @@ static int v4l_create_bufs(const struct
> > v4l2_ioctl_ops *ops,> 
> >   	struct v4l2_create_buffers *create = arg;
> >   	int ret = check_fmt(file, create->format.type);
> > -	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
> > +	if (ret)
> > +		return ret;
> > +
> > +	v4l_sanitize_format(&create->format);
> > +
> > +	ret = ops->vidioc_create_bufs(file, fh, create);
> > +
> > +	if (create->format.type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> > +	    create->format.type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +		create->format.fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> 
> Ditto.

Ditto :-)

> > +
> > +	return ret;
> >   }
> 
> Shouldn't v4l_sanitize_format also be called for s/try_fmt? It makes much
> more sense there.

I can't remember why I haven't added a call to v4l_sanitize_format there, so 
I'll assume it was just an oversight, I'll fix that.

> >   static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 0125f4d..2656a94 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -268,6 +268,7 @@ struct v4l2_capability {
> > 
> >  #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
> >   
> >  #define V4L2_CAP_SDR_CAPTURE	0x00100000  /* Is a SDR capture device */
> > +#define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended
> > pixel format */ 
> >  #define V4L2_CAP_READWRITE      0x01000000  /* read/write systemcalls */
> > #define V4L2_CAP_ASYNCIO         0x02000000  /* async I/O */
> > @@ -448,6 +449,9 @@ struct v4l2_pix_format {
> > 
> >   #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ
> >   u8 */ #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6')
> >   /* IQ u16le */> 
> > +/* priv field value to indicates that subsequent fields are valid. */
> > +#define V4L2_PIX_FMT_PRIV_MAGIC		0xdeadbeef
> 
> Hmm, 'deadbeef' is used quite a lot (git grep deadbeef), perhaps we should
> use another magic number. E.g. 'feedcafe' or something like that.

Sure.

> > +
> >   /*
> >    *	F O R M A T   E N U M E R A T I O N
> >    */
> > @@ -752,7 +756,16 @@ struct v4l2_framebuffer {
> >   /* FIXME: in theory we should pass something like PCI device + memory
> >    * region + offset instead of some physical address */
> >   	void                    *base;
> > -	struct v4l2_pix_format	fmt;
> > +	struct {
> > +		__u32		width;
> > +		__u32		height;
> > +		__u32		pixelformat;
> > +		__u32		field;		/* enum v4l2_field */
> > +		__u32		bytesperline;	/* for padding, zero if unused */
> > +		__u32		sizeimage;
> > +		__u32		colorspace;	/* enum v4l2_colorspace */
> > +		__u32		priv;		/* private data, depends on pixelformat 
*/
> 
> Let's change the comment to '/* Reserved field, set to 0. */.
> Ditto in the documentation. 'priv' has never been used for anything
> framebuffer related, so that whole 'private data' concept that priv was
> once used for should be eradicated.
> 
> Note that DocBook should be updated as well w.r.t. the v4l2_framebuffer
> struct.

Indeed. I'll fix that.

> > +	} fmt;
> > 
> >   };
> >   /*  Flags for the 'capability' field. Read only */
> >   #define V4L2_FBUF_CAP_EXTERNOVERLAY	0x0001
> 
> I would like to see this patch split in two: first adapt try/s_fmt in
> v4l2-ioctl.c to set priv to 0 and all drivers to drop the zeroing of priv
> (since that's now no longer necessary to do explicitly).

How about g_fmt ?

> The next patch would introduce support for the extended pix format.
> 
> That way all the driver 'priv = 0' patches would be in their own trivial
> patch.

-- 
Regards,

Laurent Pinchart
