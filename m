Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58062 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZDFLvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 07:51:41 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Mon, 6 Apr 2009 17:21:05 +0530
Subject: RE: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FB102FD3@dbde02.ent.ti.com>
In-Reply-To: <200903301506.36134.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please find my comments inline. Most of the comments are taken care of.

Regards,
Hardik Shah

> >  static struct twl4030_hsmmc_info mmc[] __initdata = {
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 19cf3b8..91e4529 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -711,6 +711,26 @@ config VIDEO_CAFE_CCIC
> >  	  CMOS camera controller.  This is the controller found on first-
> >  	  generation OLPC systems.
> >
> > +#config VIDEO_OMAP3
> > +#        tristate "OMAP 3 Camera support"
> > +#	select VIDEOBUF_GEN
> > +#	select VIDEOBUF_DMA_SG
> > +#	depends on VIDEO_V4L2 && ARCH_OMAP34XX
> > +#	---help---
> > +#	  Driver for an OMAP 3 camera controller.
> 
> Why add a commented config?
[Shah, Hardik] To make explicit that camera and display will have same config.  But any way removed and put a comment in config option.
> 
> > +
> > +config VID1_LCD_MANAGER
> > +        bool "Use LCD Managaer"
> > +        help
> > +          Select this option if you want VID1 pipeline on LCD Overlay
> manager
> > +endchoice
> > +
> > +choice
> > +	prompt "VID2 Overlay manager"
> > +	depends on VIDEO_OMAP_VIDEOOUT
> > +	default VID2_LCD_MANAGER
> > +
> > +config VID2_TV_MANAGER
> > +	bool "Use TV Manager"
> > +	help
> > +	  Select this option if you want VID2 pipeline on TV Overlay manager
> > +
> > +config VID2_LCD_MANAGER
> > +	bool "Use LCD Managaer"
> > +	help
> > +	  Select this option if you want VID2 pipeline on LCD Overlay manager
> > +endchoice
> > +
> > +choice
> > +        prompt "TV Mode"
> > +        depends on VID2_TV_MANAGER || VID1_TV_MANAGER
> > +        default NTSC_M
> > +
> > +config NTSC_M
> > +        bool "Use NTSC_M mode"
> > +        help
> > +          Select this option if you want NTSC_M mode on TV
> > +
> > +config PAL_BDGHI
> > +        bool "Use PAL_BDGHI mode"
> > +        help
> > +          Select this option if you want PAL_BDGHI mode on TV
> 
> Why are these config options? Isn't it possible to do this dynamically
> through VIDIOC_S_STD?
[Shah, Hardik] Currently is not tested/supported dynamically. I will add it at todos.
> 
> > +
> > +static u32 video1_numbuffers = 3;
> > +static u32 video2_numbuffers = 3;
> > +static u32 video1_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
> > +static u32 video2_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
> > +module_param(video1_numbuffers, uint, S_IRUGO);
> > +module_param(video2_numbuffers, uint, S_IRUGO);
> > +module_param(video1_bufsize, uint, S_IRUGO);
> > +module_param(video2_bufsize, uint, S_IRUGO);
> 
> I recommend adding MODULE_PARM_DESC() as well to provide a description of
> these module options.
> 
[Shah, Hardik] Added MODULE_PARM_DESC
> > +
> > +static int omap_vout_create_video_devices(struct platform_device *pdev);
> > +static int omapvid_apply_changes(struct omap_vout_device *vout, u32 addr,
> > +		int init);
> > +static int omapvid_setup_overlay(struct omap_vout_device *vout,
> > +		struct omap_overlay *ovl, int posx, int posy,
> > +		int outw, int outh, u32 addr, int tv_field1_offset, int init);
> > +static enum omap_color_mode video_mode_to_dss_mode(struct omap_vout_device
> > +		*vout);
> > +static void omap_vout_isr(void *arg, unsigned int irqstatus);
> > +static void omap_vout_cleanup_device(struct omap_vout_device *vout);
> > +/* module parameters */
> 
> ^^^^^^ This comment should be moved up.
[Shah, Hardik] Done

> > +static int omap_vout_try_format(struct v4l2_pix_format *pix,
> > +				struct v4l2_pix_format *def_pix)
> > +{
> > +	int ifmt, bpp = 0;
> > +
> > +	if (pix->width > VID_MAX_WIDTH)
> > +		pix->width = VID_MAX_WIDTH;
> > +	if (pix->height > VID_MAX_HEIGHT)
> > +		pix->height = VID_MAX_HEIGHT;
> > +
> > +	if (pix->width <= VID_MIN_WIDTH)
> > +		pix->width = def_pix->width;
> > +	if (pix->height <= VID_MIN_HEIGHT)
> > +		pix->height = def_pix->height;
> 
> Linux provides some nice clamp macros for this. See linux/kernel.h.

[Shah, Hardik] I tried using it but still if condition is required as I have four values to select from so I reverted back to same old method.
> 
> The else below should be indented one tab to the left.
> > +		} else {
> > +			dmabuf = videobuf_to_dma(q->bufs[vb->i]);
> > +
> > +			vout->queued_buf_addr[vb->i] = (u8 *) dmabuf->bus_addr;
> > +		}
> 
> Note this it is better to handle the else part first and return.
> Then the large if-part can be handled after that and can be indented
> on tab to the left as well.
> 
> I.e.:
> 
> if (cond) {
> 	// lots of code
> } else {
> 	// small amount of code
> }
> 
> can be rewritten as:
> 
> if (!cond) {
> 	// small amount of code
> 	return 0;
> }
> // lots of code.
> 
> > +		return 0;
[Shah, Hardik] Done, Implemented
> > +}
> > +	/* get the display device attached to the overlay */
> > +	if (!ovl->manager || !ovl->manager->display)
> > +		return -1;
> > +	cur_display = ovl->manager->display;
> > +
> > +	if ((cur_display->type == OMAP_DISPLAY_TYPE_VENC) &&
> > +	    ((win->w.width == crop->width)
> > +	     && (win->w.height == crop->height)))
> > +		vout->flicker_filter = 1;
> > +	else
> > +		vout->flicker_filter = 0;
> > +
> > +	if (1 == vout->mirror && vout->rotation >= 0) {
> > +		rotation_deg = (vout->rotation == 1) ?
> > +			270 : (vout->rotation == 3) ?
> > +			90 : (vout->rotation ==  2) ?
> > +			0 : 180;
> 
> Huh? Here you set rotation_deg to 0, 90, 180 or 270,
[Shah, Hardik] Done
> 
> > +
> > +	} else if (vout->rotation >= 0) {
> > +		rotation_deg = vout->rotation;
> 
> but here it is 0, 1, 2, 3.
> 
> > +	} else {
> > +		rotation_deg = -1;
> 
> And isn't -1 the same as 0?
> 
> Perhaps this should be an enum? It's definitely confusing here.
[Shah, Hardik] Implemented to convert the V4L2 rotation type that is 0, 90, 270 etc to DSS rotation type that is 0, 1, 2 etc. 
-1 and 0 explained below at last.
> 
> > +
> > +static int vidioc_querycap(struct file *file, void *fh,
> > +		struct v4l2_capability *cap)
> > +{
> > +	struct omap_vout_device *vout = ((struct omap_vout_fh *) fh)->vout;
> > +
> > +	memset(cap, 0, sizeof(*cap));
> > +	strncpy(cap->driver, VOUT_NAME,
> > +		sizeof(cap->driver));
> > +	strncpy(cap->card, vout->vfd->name, sizeof(cap->card));
> > +	cap->bus_info[0] = '\0';
> 
> Use strlcpy, that will guarantee a 0 at the end.
[Shah, Hardik] Done
> 
> > +	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
> > +	return 0;
> > +}
> > +static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
> > +			struct v4l2_fmtdesc *fmt)
> > +{
> > +	int index = fmt->index;
> > +	enum v4l2_buf_type type = fmt->type;
> > +
> > +	memset(fmt, 0, sizeof(*fmt));
> 
> I think most of these memsets are unnecessary since v4l2_ioctl2 does this
> for you already.
[Shah, Hardik] Removed unnecessary memsets.
> 
> > +		cropcap->bounds.width = pix->width & ~1;
> > +		cropcap->bounds.height = pix->height & ~1;
> > +
> > +		omap_vout_default_crop(&vout->pix, &vout->fbuf,
> > +				&cropcap->defrect);
> > +		cropcap->pixelaspect.numerator = 1;
> > +		cropcap->pixelaspect.denominator = 1;
> > +		return 0;
> > +	} else
> > +		return -EINVAL;
> 
> See my if-else discussion above.
[Shah, Hardik] Done
> 
> > +}
> > +static int vidioc_g_crop(struct file *file, void *fh,
> > +	struct v4l2_crop *crop)
> > +{
> > +	struct omap_vout_device *vout = ((struct omap_vout_fh *) fh)->vout;
> > +
> > +	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +		crop->c = vout->crop;
> > +		return 0;
> > +	} else
> > +		return -EINVAL;
> 
> Ditto.
[Shah, Hardik] Done
> 

> > +static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control
> *a)
> > +{
> > +	struct omap_vout_device *vout = ((struct omap_vout_fh *) fh)->vout;
> > +
> > +	switch (a->id) {
> > +	case V4L2_CID_ROTATION:
> > +	{
> > +		int rotation = a->value;
> > +
> > +		if (vout->pix.pixelformat == V4L2_PIX_FMT_RGB24 &&
> > +				rotation != -1)
> > +			return -EINVAL;
> > +		if (down_interruptible(&vout->lock))
> > +			return -EINVAL;
> 
> This lock is only needed inside the if below.
[Shah, Hardik] done 
> 
> > +	case V4L2_CID_BG_COLOR:
> > +	{
> > +		unsigned int  color = a->value;
> > +		struct omapvideo_info *ovid;
> > +		struct omap_overlay *ovl;
> > +		ovid = &(vout->vid_info);
> > +		ovl = ovid->overlays[0];
> > +
> > +		if (down_interruptible(&vout->lock))
> > +			return -EINVAL;
> 
> General note: unless you have a counting semaphore then it is better to use
> a mutex. It's simpler and more efficient.
[Shah, Hardik] Replaced semaphore with mutex.
> 
> > +static int vidioc_reqbufs(struct file *file, void *fh,
> > +			struct v4l2_requestbuffers *req)
> > +{
> > +	struct omap_vout_device *vout = ((struct omap_vout_fh *) fh)->vout;
> > +	struct videobuf_queue *q = &(((struct omap_vout_fh *) fh)->vbq);
> > +	unsigned int i, num_buffers = 0;
> > +	int ret = 0;
> > +	struct videobuf_dmabuf *dmabuf = NULL;
> > +
> > +	if (down_interruptible(&vout->lock))
> > +		return -EINVAL;
> 
> Move this down two 'ifs' to where it is really needed.
[Shah, Hardik] Done
> 
> camelCase! Please replace this with cur_frm and next_frm. Hmm, this gives me
> a deja vu :-)
[Shah, Hardik] Done
>  
> A general remark: the rotate code needs to be improved a bit: the mix of
> 0, 1, 2, 3 and -1 and 0, 90, 180, 270 is very confusing. Stick to one way
> of doing this internally. The extra value of -1 also makes it hard to
> understand: what's so special about that value? Often the rotate code is
> also a substantial part of a function: see if you can split such functions
> into two parts.
[Shah, Hardik] 
1.  V4L2 is using 90, 180, 270 as degree of rotation while DSS2 library understands 0, 1, 2 etc as degree of rotation.  So I implemented the function which will convert the v4l2 rotation to DSS rotation to avoid confusion.
2.  In DSS rotation is accomplished by some memory algorithm but its quite costly so -1 is essentially same as 0 degree but with out the overhead. But if mirroring is on then we have to do the 0 degree rotation with overhead using some memory techniques.  So from user point of view he will only be setting 0 but internally driver will take it as -1 or 0 depending upon the mirroring selected.
3. Splitted the rotation code wherever possible.

> 
> Regards,
> 
> 	Hans
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

Regards,
Hardik Shah
