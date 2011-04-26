Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:33724 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1DZOsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 10:48:22 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "'davinci-linux-open-source@linux.davincidsp.com'"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"'LMML'" <linux-media@vger.kernel.org>,
	"'Kevin Hilman'" <khilman@deeprootsystems.com>,
	"'LAK'" <linux-arm-kernel@lists.infradead.org>,
	"Nori, Sekhar" <nsekhar@ti.com>
Date: Tue, 26 Apr 2011 20:17:45 +0530
Subject: RE: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X
 SoC
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF731@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF730@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent,
  Can you please review the patches with your suggestions from :
http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h=refs/heads/forkhilman2
and let me know if you think all your suggestions are taken care of?

The patch you reviewed was :

http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=commitdiff;h=69f60ed7577ab9184ceabd7efbe5bb3453bf7ef1;hp=a400604f47c339831880c50eda6f6b03221579e3


-Manju


-----Original Message-----
From: Hadli, Manjunath
Sent: Monday, April 25, 2011 2:20 PM
To: 'Laurent Pinchart'
Cc: davinci-linux-open-source@linux.davincidsp.com; LMML; Kevin Hilman; LAK; Nori, Sekhar
Subject: RE: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X SoC

Laurent,
 Thank you for your comments.

Please find my updates below.
The updated patches will follow today.

-Manju

On Thu, Apr 21, 2011 at 15:48:05, Laurent Pinchart wrote:
> Hi Manjunath,
>
> On Wednesday 20 April 2011 17:30:08 Hadli, Manjunath wrote:
> > Hi Laurent,
> >  Thank you for you very valuable and detailed comments. I have fixed a
> > lot of your suggestions and there are a few questions I need more
> > explanation for. I will send the fixed and updated patches as a
> > follow-up after your clarifications.
>
> OK. Please see below for answsers.
>
> > On Thu, Apr 07, 2011 at 17:28:20, Laurent Pinchart wrote:
> > > On Saturday 02 April 2011 11:40:49 Manjunath Hadli wrote:
>
> [snip]
>
> > > > +static u32 video2_numbuffers = 3; static u32 video3_numbuffers =
> > > > +3;
> > >
> > > Why is the number of buffers set by a module parameter ? It should
> > > be negotiated dynamically with REQBUFS.
> >
> > This is the minimum number of buffers to be allocated by the system as
> > there is no scatter-gather mechanism in Davinci. To make sure of
> > availability of a minimum numbers of buffers for the system which may
> > not be available otherwise due to fragmentation, these are used.
>
> But you don't reserve the memory when the driver is probed, so how does this help ?
That was how it was done earlier. A detailed look at the code revealed that it is not applicable anymore. Fixed it.


>
> [snip]
>
> > > > +   struct vpbe_display *disp_dev = (struct vpbe_display
> > > > + *)disp_obj;
> > > > +
> > > > +   /* Convert time represention from jiffies to timeval */
> > > > +   jiffies_to_timeval(jiffies_time, &timevalue);
> > >
> > > Please use ktime_get_ts() or ktime_get_real_ts() to get the timestamp.
> >
> > Fixed. Used do_gettimeofday().
>
> Please use ktime_get_ts() instead. It will return a monotonic clock timestamp.
> Otherwise the buffer timestamp will vary when the system clock is modified (as a result of an NTP time update for instance).
Fixed.

>
> > > > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > > > +           layer = disp_dev->dev[i];
> > > > +           /* If streaming is started in this layer */
> > > > +           if (!layer->started)
> > > > +                   continue;
> > > > +           /* Check the field format */
> > > > +           if ((V4L2_FIELD_NONE == layer->pix_fmt.field) &&
> > > > +               (event & OSD_END_OF_FRAME)) {
> > > > +                   /* Progressive mode */
> > > > +                   if (layer_first_int[i]) {
> > > > +                           layer_first_int[i] = 0;
> > > > +                           continue;
> > > > +                   }
> > > > +                   /*
> > > > +                    * Mark status of the cur_frm to
> > > > +                    * done and unlock semaphore on it
> > > > +                    */
> > > > +
> > > > +                   if (layer->cur_frm != layer->next_frm) {
> > > > +                           layer->cur_frm->ts = timevalue;
> > > > +                           layer->cur_frm->state = VIDEOBUF_DONE;
> > >
> > > Please use videobuf2.
> >
> > I would like to get to videobuf2 as a next set of changes. I want to
> > get the Dm6446 driver fisrt, add it with Dm365 and do the videobuf2
> > later.  I hope it is okay.
>
> We're trying to get rid of videobuf1, so accepting new drivers that make use of videobuf1 is a bit problematic. Have you had a look at videobuf2 ? How much time do you think it would take to convert this driver to videobuf2 ? Let's first address all the other issues, and then tackle that one.
I have gone through the videobuf2 in a limited way. I can get the changes done for videobuf2, but my major objective is to get this version of the driver in. Immediately after that I can take up videobuf2.
>
> [snip]
>
> > > > +/* interrupt service routine */
> > > > +static irqreturn_t venc_isr(int irq, void *arg) {
> > > > +   static unsigned last_event;
> > > > +   unsigned event = 0;
> > > > +
> > > > +   if (venc_is_second_field())
> > > > +           event |= VENC_SECOND_FIELD;
> > > > +   else
> > > > +           event |= VENC_FIRST_FIELD;
> > > > +
> > > > +   if (event == (last_event & ~VENC_END_OF_FRAME)) {
> > > > +           /*
> > > > +           * If the display is non-interlaced, then we need to
> > > > + flag
> > > > the +           * end-of-frame event at every interrupt regardless of
> > > > the +           * value of the FIDST bit.  We can conclude that the
> > > > display is +           * non-interlaced if the value of the FIDST bit
> > > > is unchanged +           * from the previous interrupt.
> > > > +           */
> > >
> > > What about checking pix_fmt.field instead ?
> >
> > Not sure what you mean here. We get the FIRST or second field event
> > from the hardware so we need to check the register value rather than
> > pix_fmt.field.
>
> Interlacing is configured by userspace. When configured in interlaced mode, I expect the device to alternate fields. When configured in progressive mode, I expect it to always return the same field. If that's correct, the FIDST bit is only needed to identify the active field when configured in interlaced mode.
> pix_fmt.field can be use to check whether we're in interlaced or progressive mode.
In the isr we check both for the hardware setting and the pix_fmt.field if you see. It meant as a double check. I would like to keep it this way if you do not mind.
>
> [snip]
>
> > > > +static int vpbe_display_querycap(struct file *file, void  *priv,
> > > > +                          struct v4l2_capability *cap) {
> > > > +   struct vpbe_fh *fh = file->private_data;
> > > > +   struct vpbe_display_obj *layer = fh->layer;
> > > > +
> > > > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> > > > +           "VIDIOC_QUERYCAP, layer id = %d\n", layer->device_id);
> > >
> > > Do you really need a debugging call here ?
> >
> > I am Ok either ways. When debugging is enabled, it is just one of the
> > data points since there are multiple windows.
>
> You could leave it, but a debug call in the querycap handler doesn't look very useful to me.
>
> > > > +   *cap = vpbe_display_videocap;
> > > > +
> > > > +   return 0;
> > > > +}
>
> [snip]
>
> > > > +static int vpbe_display_g_fmt(struct file *file, void *priv,
> > > > +                           struct v4l2_format *fmt) {
> > > > +   struct vpbe_fh *fh = file->private_data;
> > > > +   struct vpbe_display_obj *layer = fh->layer;
> > > > +
> > > > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> > > > +                   "VIDIOC_G_FMT, layer id = %d\n",
> > > > +                   layer->device_id);
> > > > +
> > > > +   /* If buffer type is video output */
> > > > +   if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
> > > > +           struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> > > > +           /* Fill in the information about format */
> > > > +           *pixfmt = layer->pix_fmt;
> > >
> > > I don't see anything wrong in doing
> > >
> > > fmt->fmt.pix = layer->pix_fmt;
> > >
> > > directly.
> >
> > Wel,. In the past patches we had a large amount of multiple
> > indirections, and as part of a suggestion on open source I removed all
> > of them with a general rule of not having more than 2 indirections.
> > What is your take on this? How many indirection levels do you allow?
>
> There's no hard rule for that. I usually use intermediate pointers when the number of indirection levels grow too high, except when I only need to perform the indirection once or twice, like in this case.
OK. Addressed.
>
> > > > +   } else {
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev, "invalid type\n");
> > > > +           return -EINVAL;
> > > > +   }
> > > > +
> > > > +   return 0;
> > > > +}
>
> [snip]
>
> > > > +static int vpbe_display_s_fmt(struct file *file, void *priv,
> > > > +                           struct v4l2_format *fmt) {
> > > > +   int ret = 0;
> > > > +   struct vpbe_fh *fh = file->private_data;
> > > > +   struct vpbe_display *disp_dev = video_drvdata(file);
> > > > +   struct vpbe_display_obj *layer = fh->layer;
> > > > +   struct osd_layer_config *cfg  = &layer->layer_info.config;
> > >
> > > Variables are often declared in longuest to shortest line order in
> > > kernel drivers. It might not be a requirement though, but I find it
> > > to make code more readable.
> >
> > cannot do as suggested since the structure variable assignments  have
> > dependency on previous structure variables.
>
> Oops, my bad.
>
> > > > +
> > > > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> > > > +                   "VIDIOC_S_FMT, layer id = %d\n",
> > > > +                   layer->device_id);
> > > > +
> > > > +   /* If streaming is started, return error */
> > > > +   if (layer->started) {
> > >
> > > I'm pretty sure there's a race condition here.
> >
> > Not sure about this. The entire driver is under V4L2 lock per layer
> > handle and it would not allow another call to come here once in.
>
> I missed that. Probably because I dislike that lock :-)
>
> > Can you elaborate how is it a race condition?
> >
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
> > > > +           return -EBUSY;
> > > > +   }
> > > > +   if (V4L2_BUF_TYPE_VIDEO_OUTPUT != fmt->type) {
> > > > +           v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "invalid type\n");
> > > > +           return -EINVAL;
> > > > +   } else {
> > > > +           struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> > > > +           /* Check for valid pixel format */
> > > > +           ret = vpbe_try_format(disp_dev, pixfmt, 1);
> > > > +           if (ret)
> > > > +                   return ret;
> > > > +
> > > > +           /* YUV420 is requested, check availability of the
> > > > +           other video window */
> > > > +
> > > > +           layer->pix_fmt = *pixfmt;
> > > > +
> > > > +           /* Get osd layer config */
> > > > +           osd_device->ops.get_layer_config(osd_device,
> > > > +                           layer->layer_info.id, cfg);
> > > > +           /* Store the pixel format in the layer object */
> > > > +           cfg->xsize = pixfmt->width;
> > > > +           cfg->ysize = pixfmt->height;
> > > > +           cfg->line_length = pixfmt->bytesperline;
> > > > +           cfg->ypos = 0;
> > > > +           cfg->xpos = 0;
> > > > +           cfg->interlaced =
> > > > + vpbe_dev->current_timings.interlaced;
> > > > +
> > > > +           /* Change of the default pixel format for both video
> > > > windows */ +           if (V4L2_PIX_FMT_NV12 == pixfmt->pixelformat) {
> > > > +                   struct vpbe_display_obj *otherlayer;
> > >
> > > If the requested format isn't NV12, cfg->pixfmt won't be modified.
> > > If it has been set to NV12 by a previous S_FMT call, it won't become
> > > YUYV. Is that intentional ?
> >
> > It is reset to YUYV as part of Open. So it is changed only if it is NV12.
>
> As stated below, you shouldn't reset formats in open().
Addressed.
>
> > > > +                   cfg->pixfmt = PIXFMT_NV12;
> > > > +                   otherlayer = _vpbe_display_get_other_win(disp_dev,
> > > > +                                                            layer);
> > > > +                   otherlayer->layer_info.config.pixfmt = PIXFMT_NV12;
> > > > +           }
> > > > +
> > > > +           /* Set the layer config in the osd window */
> > > > +           ret = osd_device->ops.set_layer_config(osd_device,
> > > > +                                   layer->layer_info.id, cfg);
> > > > +           if (ret < 0) {
> > > > +                   v4l2_err(&vpbe_dev->v4l2_dev,
> > > > +                            "Error in S_FMT params:\n");
> > > > +                   return -EINVAL;
> > > > +           }
> > > > +
> > > > +           /* Readback and fill the local copy of current pix
> > > > + format
> > > > */ +           osd_device->ops.get_layer_config(osd_device,
> > > > +                           layer->layer_info.id, cfg);
> > > > +
> > > > +           /* verify if readback values are as expected */
> > > > +           if (layer->pix_fmt.width != cfg->xsize ||
> > > > +                   layer->pix_fmt.height != cfg->ysize ||
> > > > +                   layer->pix_fmt.bytesperline != layer->layer_info.
> > > > +                   config.line_length || (cfg->interlaced &&
> > > > +                   layer->pix_fmt.field != V4L2_FIELD_INTERLACED) ||
> > > > +                   (!cfg->interlaced && layer->pix_fmt.field !=
> > > > +                   V4L2_FIELD_NONE)) {
> > > > +                   v4l2_err(&vpbe_dev->v4l2_dev,
> > > > +                            "mismatch:layer conf params:\n");
> > > > +                   return -EINVAL;
> > > > +           }
> > > > +   }
> > > > +
> > > > +   return 0;
> > > > +}
>
> [snip]
>
> > > > +/**
> > > > + * vpbe_display_g_std - Get the standard in the current encoder
> > > > + *
> > > > + * Get the standard in the current encoder. Return the status. 0
> > > > +-
> > > > success + * -EINVAL on error
> > > > + */
> > > > +static int vpbe_display_g_std(struct file *file, void *priv,
> > > > +                           v4l2_std_id *std_id) {
> > > > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_G_STD\n");
> > > > +
> > > > +   /* Get the standard from the current encoder */
> > > > +   if (vpbe_dev->current_timings.timings_type & VPBE_ENC_STD) {
> > > > +           *std_id = vpbe_dev->current_timings.timings.std_id;
> > > > +           return 0;
> > > > +   }
> > > > +   return -EINVAL;
> > >
> > > Where do you set timings_type ? When can this return an error ?
> >
> > It can return an error if the driver is set to a DV_PRESET mode.
> > timings_type would tell whether is is an SD standard or a DV_PRESET.
>
> But you don't seem to set it anywhere.
It is set in set_dv_presets and s_std, but is part of vpbe.c file.
>
> > > > +}
>
> [snip]
>
> > > > +static int vpbe_display_cfg_layer_default(enum
> > > > +vpbe_display_device_id
> > > > id, +                   struct vpbe_display *disp_dev)
> > > > +{
> > > > +   int err = 0;
> > > > +   struct osd_layer_config *layer_config;
> > > > +   struct vpbe_display_obj *layer = disp_dev->dev[id];
> > > > +   struct osd_layer_config *cfg  = &layer->layer_info.config;
> > > > +
> > > > +   /* First claim the layer for this device */
> > > > +   err = osd_device->ops.request_layer(osd_device,
> > > > +                                       layer->layer_info.id);
> > > > +   if (err < 0) {
> > > > +           /* Couldn't get layer */
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev,
> > > > +                   "Display Manager failed to allocate layer\n");
> > > > +           return -EBUSY;
> > > > +   }
> > > > +
> > > > +   layer_config = cfg;
> > > > +   /* Set the default image and crop values */
> > > > +   layer_config->pixfmt = PIXFMT_YCbCrI;
> > > > +   layer->pix_fmt.pixelformat = V4L2_PIX_FMT_UYVY;
> > > > +   layer->pix_fmt.bytesperline = layer_config->line_length =
> > > > +       vpbe_dev->current_timings.xres * 2;
> > > > +
> > > > +   layer->pix_fmt.width = layer_config->xsize =
> > > > +           vpbe_dev->current_timings.xres;
> > > > +   layer->pix_fmt.height = layer_config->ysize =
> > > > +           vpbe_dev->current_timings.yres;
> > > > +   layer->pix_fmt.sizeimage =
> > > > +           layer->pix_fmt.bytesperline * layer->pix_fmt.height;
> > > > +   layer_config->xpos = 0;
> > > > +   layer_config->ypos = 0;
> > > > +   layer_config->interlaced =
> > > > + vpbe_dev->current_timings.interlaced;
> > >
> > > You shouldn't reinitialized the format every time the device is opened.
> > > The previously set format should be kept.
> >
> > This strictly followed across drivers? I am Ok if that is the expectation.
>
> It's how V4L2 drivers should behave. Some drivers might not follow that rule, but that would be a bug :-)
Alright. Fixed.
>
> > > > +
> > > > +   /*
> > > > +    * turn off ping-pong buffer and field inversion to fix
> > > > +    * the image shaking problem in 1080I mode
> > > > +    */
> > > > +
> > > > +   if (cfg->interlaced)
> > > > +           layer->pix_fmt.field = V4L2_FIELD_INTERLACED;
> > > > +   else
> > > > +           layer->pix_fmt.field = V4L2_FIELD_NONE;
> > > > +
> > > > +   err = osd_device->ops.set_layer_config(osd_device,
> > > > +                           layer->layer_info.id,
> > > > +                           layer_config);
> > > > +   if (err < 0) {
> > > > +           /* Couldn't set layer */
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev,
> > > > +                   "Display Manager failed to set osd layer\n");
> > > > +           return -EBUSY;
> > > > +   }
> > > > +
> > > > +   return 0;
> > > > +}
>
> [snip]
>
> > > > +/*
> > > > + * vpbe_display_probe()
> > > > + * This function creates device entries by register itself to the
> > > > +V4L2
> > > > driver + * and initializes fields of each layer objects
> > > > + */
> > > > +static __devinit int vpbe_display_probe(struct platform_device
> > > > +*pdev) {
> > > > +   int i, j = 0, k, err = 0;
> > > > +   struct vpbe_display *disp_dev;
> > > > +   struct video_device *vbd = NULL;
> > > > +   struct vpbe_display_obj *vpbe_display_layer = NULL;
> > > > +   struct resource *res;
> > > > +   int irq;
> > > > +
> > > > +   printk(KERN_DEBUG "vpbe_display_probe\n");
> > > > +
> > > > +   /* Allocate memory for vpbe_display */
> > > > +   disp_dev = kzalloc(sizeof(struct vpbe_display), GFP_KERNEL);
> > > > +   if (!disp_dev) {
> > > > +           printk(KERN_ERR "ran out of memory\n");
> > > > +           return -ENOMEM;
> > > > +   }
> > > > +
> > > > +   /* Allocate memory for four plane display objects */
> > > > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > > > +           disp_dev->dev[i] =
> > > > +               kmalloc(sizeof(struct vpbe_display_obj), GFP_KERNEL);
> > > > +           /* If memory allocation fails, return error */
> > > > +           if (!disp_dev->dev[i]) {
> > > > +                   printk(KERN_ERR "ran out of memory\n");
> > > > +                   err = -ENOMEM;
> > > > +                   goto probe_out;
> > > > +           }
> > > > +           spin_lock_init(&disp_dev->dev[i]->irqlock);
> > > > +           mutex_init(&disp_dev->dev[i]->opslock);
> > > > +   }
> > > > +   spin_lock_init(&disp_dev->dma_queue_lock);
> > > > +
> > > > +   err = init_vpbe_layer_objects(i);
> > > > +   if (err) {
> > > > +           printk(KERN_ERR "Error initializing vpbe display\n");
> > > > +           return err;
> > > > +   }
> > > > +
> > > > +   /*
> > > > +    * Scan all the platform devices to find the vpbe
> > > > +    * controller device and get the vpbe_dev object
> > > > +    */
> > > > +   err = bus_for_each_dev(&platform_bus_type, NULL, NULL,
> > > > +                   vpbe_device_get);
> > > > +   if (err < 0)
> > > > +           return err;
> > > > +
> > > > +   /* Initialize the vpbe display controller */
> > > > +   if (NULL != vpbe_dev->ops.initialize) {
> > > > +           err = vpbe_dev->ops.initialize(&pdev->dev, vpbe_dev);
> > > > +           if (err) {
> > > > +                   v4l2_err(&vpbe_dev->v4l2_dev, "Error initing
> > > > vpbe\n"); +                   err = -ENOMEM;
> > > > +                   goto probe_out;
> > > > +           }
> > > > +   }
> > > > +
> > > > +   /* check the name of davinci device */
> > > > +   if (vpbe_dev->cfg->module_name != NULL)
> > > > +           strcpy(vpbe_display_videocap.card,
> > > > +                   vpbe_dev->cfg->module_name);
> > > > +
> > > > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > > > +           /* Get the pointer to the layer object */
> > > > +           vpbe_display_layer = disp_dev->dev[i];
> > > > +           /* Allocate memory for video device */
> > > > +           vbd = video_device_alloc();
> > > > +           if (vbd == NULL) {
> > > > +                   for (j = 0; j < i; j++) {
> > > > +                           video_device_release(
> > > > +                           disp_dev->dev[j]->video_dev);
> > > > +                   }
> > > > +                   v4l2_err(&vpbe_dev->v4l2_dev, "ran out of
> > > > memory\n"); +                   err = -ENOMEM;
> > > > +                   goto probe_out;
> > > > +           }
> > > > +           /* Initialize field of video device */
> > > > +           vbd->release    = video_device_release;
> > > > +           vbd->fops       = &vpbe_fops;
> > > > +           vbd->ioctl_ops  = &vpbe_ioctl_ops;
> > > > +           vbd->minor      = -1;
> > > > +           vbd->v4l2_dev   = &vpbe_dev->v4l2_dev;
> > > > +           vbd->lock       = &vpbe_display_layer->opslock;
> > > > +
> > > > +           if (vpbe_dev->current_timings.timings_type &
> > > > + VPBE_ENC_STD)
> > > > { +                   vbd->tvnorms    = (V4L2_STD_525_60 |
> > > > V4L2_STD_625_50); +                   vbd->current_norm =
> > > > +                           vpbe_dev->current_timings.timings.std_id;
> > > > +           } else
> > > > +                   vbd->current_norm = 0;
> > > > +
> > > > +           snprintf(vbd->name, sizeof(vbd->name),
> > > > +                    "DaVinci_VPBE Display_DRIVER_V%d.%d.%d",
> > > > +                    (VPBE_DISPLAY_VERSION_CODE >> 16) & 0xff,
> > > > +                    (VPBE_DISPLAY_VERSION_CODE >> 8) & 0xff,
> > > > +                    (VPBE_DISPLAY_VERSION_CODE) & 0xff);
> > > > +
> > > > +           /* Set video_dev to the video device */
> > > > +           vpbe_display_layer->video_dev = vbd;
> > > > +           vpbe_display_layer->device_id = i;
> > > > +
> > > > +           vpbe_display_layer->layer_info.id =
> > > > +               ((i == VPBE_DISPLAY_DEVICE_0) ? WIN_VID0 : WIN_VID1);
> > > > +           if (display_buf_config_params.numbuffers[i] == 0)
> > > > +                   vpbe_display_layer->memory = V4L2_MEMORY_USERPTR;
> > > > +           else
> > > > +                   vpbe_display_layer->memory = V4L2_MEMORY_MMAP;
> > > > +
> > > > +           /* Initialize field of the display layer objects */
> > > > +           vpbe_display_layer->usrs = 0;
> > > > +           vpbe_display_layer->io_usrs = 0;
> > > > +           vpbe_display_layer->started = 0;
> > > > +
> > > > +           /* Initialize prio member of layer object */
> > > > +           v4l2_prio_init(&vpbe_display_layer->prio);
> > > > +
> > > > +           /* Register video device */
> > > > +           v4l2_info(&vpbe_dev->v4l2_dev,
> > > > +                  "Trying to register VPBE display device.\n");
> > > > +           v4l2_info(&vpbe_dev->v4l2_dev,
> > > > +                           "layer=%x,layer->video_dev=%x\n",
> > > > +                           (int)vpbe_display_layer,
> > > > +                           (int)&vpbe_display_layer->video_dev);
> > > > +
> > > > +           err = video_register_device(vpbe_display_layer->
> > > > +                                       video_dev,
> > > > +                                       VFL_TYPE_GRABBER,
> > > > +                                       vpbe_display_nr[i]);
> > > > +           if (err)
> > > > +                   goto probe_out;
> > > > +           /* set the driver data in platform device */
> > > > +           platform_set_drvdata(pdev, disp_dev);
> > > > +           video_set_drvdata(vpbe_display_layer->video_dev, disp_dev);
> > > > +   }
> > > > +
> > > > +   res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > > > +   if (!res) {
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev,
> > > > +                    "Unable to get VENC interrupt resource\n");
> > > > +           err = -ENODEV;
> > > > +           goto probe_out;
> > > > +   }
> > > > +   irq = res->start;
> > > > +   if (request_irq(irq, venc_isr,  IRQF_DISABLED, VPBE_DISPLAY_DRIVER,
> > > > +           disp_dev)) {
> > > > +           v4l2_err(&vpbe_dev->v4l2_dev, "Unable to request
> > > > interrupt\n"); +           err = -ENODEV;
> > > > +           goto probe_out;
> > > > +   }
> > >
> > > You probably want to get the resources and register the interrupt
> > > handler before registering the V4L2 devices, otherwise userspace
> > > will be able to open devices before you're done with the initialization.
> >
> > I do not think anyone would attempt to open the device so soon as the
> > boot process is not complete yet.
>
> Unless you compile the driver as a module. In that case an application could open the device as soon as it gets registered. hal is known to do that.
>
> > Also, if the irq is registered before, the interrupts start and the
> > driver crashes for lack of initialized structure variables.
>
> Why would an interrupt occur before the device gets opened ?
I got the interrupt and the driver crashed because of initialized pointers if I put this before. I will see why and fix it.
>
> > > > +   printk(KERN_DEBUG "Successfully completed the probing of vpbe
> > > > + v4l2
> > > > device\n"); +       return 0;
> > > > +probe_out:
> > > > +   kfree(disp_dev);
> > > > +
> > > > +   for (k = 0; k < j; k++) {
> > > > +           /* Get the pointer to the layer object */
> > > > +           vpbe_display_layer = disp_dev->dev[k];
> > > > +           /* Unregister video device */
> > > > +           video_unregister_device(vpbe_display_layer->video_dev);
> > > > +           /* Release video device */
> > > > +           video_device_release(vpbe_display_layer->video_dev);
> > > > +           vpbe_display_layer->video_dev = NULL;
> > > > +   }
> > > > +   return err;
> > > > +}
> > >
> > > [snip]
> > >
> > > > +MODULE_DESCRIPTION("TI DMXXX VPBE Display controller");
> > >
> > > Should this be "TI DM644x" instead ?
> >
> > This is a common IP for DM644x, Dm355 and Dm365 for which the patches
> > will follow after this set. So I think it is OK.
>
> What about "TI DM644x/DM355/DM365" then ? DMXXX makes it look like it supports all DaVinci chips.
>
> --
> Regards,
>
> Laurent Pinchart
>

