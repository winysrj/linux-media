Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:33710 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1ESOxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 10:53:49 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "'davinci-linux-open-source@linux.davincidsp.com'"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"'LMML'" <linux-media@vger.kernel.org>,
	"'Kevin Hilman'" <khilman@deeprootsystems.com>,
	"'LAK'" <linux-arm-kernel@lists.infradead.org>,
	"Nori, Sekhar" <nsekhar@ti.com>
Date: Thu, 19 May 2011 20:23:33 +0530
Subject: RE: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X
 SoC
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF732@dbde02.ent.ti.com>
In-Reply-To: <201105021158.23956.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent,
  Thank you for your comments. I have addressed all your suggestions.

Please find my comments inline.

Also,
 Would you please review the patch again?

The branch is at:
http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h=refs/heads/forkhilman2

and the patch that you last reviewed was:

http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=commit;h=690187eb05de65f1e63fc631ad4dc31358d01e55


Thanks,
-Manju

On Mon, May 02, 2011 at 15:28:23, Laurent Pinchart wrote:
> Hi Manjunath,
>
> On Tuesday 26 April 2011 16:47:45 Hadli, Manjunath wrote:
> > Laurent,
> >   Can you please review the patches with your suggestions from :
> > http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h
> > =refs
> > /heads/forkhilman2 and let me know if you think all your suggestions
> > are taken care of?
> >
> > The patch you reviewed was :
> >
> > http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=commitdiff
> > ;h=69
> > f60ed7577ab9184ceabd7efbe5bb3453bf7ef1;hp=a400604f47c339831880c50eda6f
> > 6b032
> > 21579e3
>
> I've reviewed the same patch, here are my comments.
>
> > +/*
> > + * vpbe_display_isr()
> > + * ISR function. It changes status of the displayed buffer, takes
> > +next
> buffer
> > + * from the queue and sets its address in VPBE registers  */ static
> > +void vpbe_display_isr(unsigned int event, struct vpbe_display
> *disp_obj)
> > +{
> > +   struct osd_state *osd_device = disp_obj->osd_device;
> > +   struct timespec timevalue;
> > +   struct vpbe_layer *layer;
> > +   unsigned long addr;
> > +   int fid;
> > +   int i;
> > +
> > +   ktime_get_ts(&timevalue);
> > +
> > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > +           layer = disp_obj->dev[i];
> > +           /* If streaming is started in this layer */
> > +           if (!layer->started)
> > +                   continue;
>
> What about moving everything above to venc_isr(), and having this function handle a single layer only ? It will lower the max indentation level. I also wonder whether you couldn't share some code between the non-interlaced and the interlaced cases by reorganizing the function body (the fid == 1 code looks quite similar to the non-interlaced code).
To make it very clean I have broken the isr in a different way and tried to neatly arrange it. It has now been made qute small and re-usable.Hope you like it.
>
> [snip]
>
> > +/**
> > + * vpbe_try_format()
> > + * If user application provides width and height, and have
> > +bytesperline set
> > + * to zero, driver calculates bytesperline and sizeimage based on
> > +hardware
> > + * limits. If application likes to add pads at the end of each line
> > +and
> > + * end of the buffer , it can set bytesperline to line size and
> > +sizeimage
> to
> > + * bytesperline * height of the buffer. If driver fills zero for
> > + active
> > + * video width and height, and has requested user bytesperline and
> sizeimage,
> > + * width and height is adjusted to maximum display limit or buffer
> > + width
> > + * height which ever is lower
>
> This still sounds a bit cryptic to me.
>
> vpbe_try_format() should return a format closest to what the user requested:
>
> - If the pixel format is invalid, select a default value (done)
> - If the field is invalid or not specified, select a default value (partly
>   done, you don't check for default values)
> - If width and/or height are invalid (including being set to 0), select
>   default values (partly done, you compute width/height based on bytesperline
>   and sizeimage when they're set to 0, and I don't understand why)
> - If bytesperline is invalid (smaller than the minimum value according to the
>   selected width, or larger than the maximum allowable value), fix it
> - If sizeimage is invalid (smaller than the minimum value according the the
>   selected height and bytesperline), fix it
>
> Is there a need to allow sizeimage values different than height * bytesperline ?

Cleaned and taken care of.
>
> > + */
>
> [snip]
>
> > +static int vpbe_display_querycap(struct file *file, void  *priv,
> > +                          struct v4l2_capability *cap) {
> > +   struct vpbe_fh *fh = file->private_data;
> > +   struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
> > +
> > +   cap->version = VPBE_DISPLAY_VERSION_CODE;
> > +   cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> > +   strlcpy(cap->driver, VPBE_DISPLAY_DRIVER, sizeof(cap->driver));
> > +   strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
> > +   /* check the name of davinci device */
> > +   if (vpbe_dev->cfg->module_name != NULL)
>
> module_name can't be NULL, as it's declared as a char[32].
>
> > +           strlcpy(cap->card, vpbe_dev->cfg->module_name,
> > +                   sizeof(cap->card));
> > +
> > +   return 0;
> > +}
>
> [snip]
>
> > +static int vpbe_display_g_fmt(struct file *file, void *priv,
> > +                           struct v4l2_format *fmt)
> > +{
> > +   struct vpbe_fh *fh = file->private_data;
> > +   struct vpbe_layer *layer = fh->layer;
> > +   struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
> > +
> > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> > +                   "VIDIOC_G_FMT, layer id = %d\n",
> > +                   layer->device_id);
> > +
> > +   /* If buffer type is video output */
> > +   if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {
> > +           /* Fill in the information about format */
> > +           fmt->fmt.pix = layer->pix_fmt;
> > +   } else {
> > +           v4l2_err(&vpbe_dev->v4l2_dev, "invalid type\n");
> > +           return -EINVAL;
> > +   }
>
> You should do it the other way around. Return -EINVAL when the type isn't OUTPUT, and remove the else. This will increase code readability by decreasing the max indentation level in the common case.
Done.
>
> > +
> > +   return 0;
> > +}
>
> [snip]
>
> > +/**
> > + * vpbe_display_enum_output - enumerate outputs
> > + *
> > + * Enumerates the outputs available at the vpbe display
> > + * returns the status, -EINVAL if end of output list  */ static int
> > +vpbe_display_enum_output(struct file *file, void *priv,
> > +                               struct v4l2_output *output)
> > +{
> > +   struct vpbe_fh *fh = priv;
> > +   struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
> > +   int ret;
> > +
> > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_ENUM_OUTPUT\n");
> > +
> > +   /* Enumerate outputs */
> > +
> > +   if (NULL != vpbe_dev->ops.enum_outputs) {
> > +           ret = vpbe_dev->ops.enum_outputs(vpbe_dev, output);
> > +           if (ret) {
> > +                   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> > +                           "Failed to enumerate outputs\n");
> > +                   return -EINVAL;
> > +           }
> > +   } else {
> > +           return -EINVAL;
> > +   }
>
> Other way around here too please.
Done.
>
> > +
> > +   return 0;
> > +}
> > +
> > +/**
> > + * vpbe_display_s_output - Set output to
> > + * the output specified by the index
> > + */
> > +static int vpbe_display_s_output(struct file *file, void *priv,
> > +                           unsigned int i)
> > +{
> > +   struct vpbe_fh *fh = priv;
> > +   struct vpbe_layer *layer = fh->layer;
> > +   struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
> > +   int ret;
> > +
> > +   v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_OUTPUT\n");
> > +   /* If streaming is started, return error */
> > +   if (layer->started) {
> > +           v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
> > +           return -EBUSY;
> > +   }
> > +   if (NULL != vpbe_dev->ops.set_output) {
> > +           ret = vpbe_dev->ops.set_output(vpbe_dev, i);
> > +           if (ret) {
> > +                   v4l2_err(&vpbe_dev->v4l2_dev,
> > +                           "Failed to set output for sub devices\n");
> > +                   return -EINVAL;
> > +           }
> > +   } else {
> > +           return -EINVAL;
> > +   }
>
> And here too.
Done.
>
> > +
> > +   return 0;
> > +}
>
> [snip]
>
> > +static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
> > +                                struct platform_device *pdev) {
> > +   struct vpbe_layer *vpbe_display_layer = NULL;
> > +   struct video_device *vbd = NULL;
> > +   int k;
> > +   int err;
> > +
> > +   /* Allocate memory for four plane display objects */
> > +
> > +   disp_dev->dev[i] =
> > +           kmalloc(sizeof(struct vpbe_layer), GFP_KERNEL);
>
> You can use kzalloc() and avoid several initializations to 0 below.
Sure.

>
> > +
> > +   /* If memory allocation fails, return error */
> > +   if (!disp_dev->dev[i]) {
> > +           printk(KERN_ERR "ran out of memory\n");
> > +           err = -ENOMEM;
> > +           goto free_mem;
> > +   }
> > +   spin_lock_init(&disp_dev->dev[i]->irqlock);
> > +   mutex_init(&disp_dev->dev[i]->opslock);
> > +
> > +   /* Get the pointer to the layer object */
> > +   vpbe_display_layer = disp_dev->dev[i];
> > +   /* Allocate memory for video device */
> > +   vbd = video_device_alloc();
>
> There's no need to allocate the device dynamically, you can embed struct video_device into struct vpbe_layer (i.e. replace struct video_device *video_dev with struct video_device video_dev inside struct vpbe_layer)
>
> (and feel free to rename video_dev to something shorter if needed)
Done. Did not do the renaming though.
>
> > +   if (vbd == NULL) {
> > +           v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
> > +                           "ran out of memory\n");
> > +           err = -ENOMEM;
> > +           goto free_mem;
> > +   }
> > +   /* Initialize field of video device */
> > +   vbd->release    = video_device_release;
>
> You should then use video_device_release_empty instead of video_device_release.
Ok.
>
> > +   vbd->fops       = &vpbe_fops;
> > +   vbd->ioctl_ops  = &vpbe_ioctl_ops;
> > +   vbd->minor      = -1;
> > +   vbd->v4l2_dev   = &disp_dev->vpbe_dev->v4l2_dev;
> > +   vbd->lock       = &vpbe_display_layer->opslock;
> > +
> > +   if (disp_dev->vpbe_dev->current_timings.timings_type &
> > +                   VPBE_ENC_STD) {
> > +           vbd->tvnorms = (V4L2_STD_525_60 | V4L2_STD_625_50);
> > +           vbd->current_norm =
> > +                   disp_dev->vpbe_dev->
> > +                   current_timings.timings.std_id;
> > +   } else
> > +           vbd->current_norm = 0;
> > +
> > +   snprintf(vbd->name, sizeof(vbd->name),
> > +                   "DaVinci_VPBE Display_DRIVER_V%d.%d.%d",
> > +                   (VPBE_DISPLAY_VERSION_CODE >> 16) & 0xff,
> > +                   (VPBE_DISPLAY_VERSION_CODE >> 8) & 0xff,
> > +                   (VPBE_DISPLAY_VERSION_CODE) & 0xff);
> > +
> > +   /* Set video_dev to the video device */
> > +   vpbe_display_layer->video_dev = vbd;
> > +   vpbe_display_layer->device_id = i;
> > +
> > +   vpbe_display_layer->layer_info.id =
> > +           ((i == VPBE_DISPLAY_DEVICE_0) ? WIN_VID0 : WIN_VID1);
> > +
> > +   /* Initialize field of the display layer objects */
> > +   vpbe_display_layer->usrs = 0;
> > +   vpbe_display_layer->io_usrs = 0;
> > +   vpbe_display_layer->started = 0;
> > +
> > +   /* Initialize prio member of layer object */
> > +   v4l2_prio_init(&vpbe_display_layer->prio);
> > +
> > +   return 0;
> > +
> > +free_mem:
> > +   for (k = 0; k < i-1; k++) {
> > +           /* Get the pointer to the layer object */
> > +           vpbe_display_layer = disp_dev->dev[k];
> > +           /* Release video device */
> > +           video_device_release(vpbe_display_layer->video_dev);
> > +           vpbe_display_layer->video_dev = NULL;
> > +           /* free layer memory */
> > +           kfree(disp_dev->dev[k]);
> > +   }
>
> This should be moved to the error cleanup part of vpbe_display_probe(). A function that registers a single device shouldn't clean other devices up in case of error.
Done.
>
> > +
> > +   return -ENODEV;
> > +}
> > +
> > +static __devinit int register_devices(int i, struct vpbe_display *disp_dev,
> > +                                 struct platform_device *pdev) {
>
> This registers a single device, so I would call it vpbe_register_device.
>
> > +   struct vpbe_layer *vpbe_display_layer = NULL;
> > +   int err;
> > +   int k;
> > +
> > +   vpbe_display_layer = disp_dev->dev[i];
>
> Please pass disp_dev->dev[i] to the function instead of i.
Done.
>
> > +   v4l2_info(&disp_dev->vpbe_dev->v4l2_dev,
> > +             "Trying to register VPBE display device.\n");
> > +   v4l2_info(&disp_dev->vpbe_dev->v4l2_dev,
> > +             "layer=%x,layer->video_dev=%x\n",
> > +             (int)vpbe_display_layer,
> > +             (int)&vpbe_display_layer->video_dev);
> > +
> > +   err = video_register_device(vpbe_display_layer->video_dev,
> > +                               VFL_TYPE_GRABBER,
> > +                               -1);
> > +   if (err)
> > +           goto video_register_failed;
> > +
> > +   vpbe_display_layer->disp_dev = disp_dev;
> > +   /* set the driver data in platform device */
> > +   platform_set_drvdata(pdev, disp_dev);
> > +   video_set_drvdata(vpbe_display_layer->video_dev,
> > +                     vpbe_display_layer);
> > +
> > +   return 0;
> > +
> > +video_register_failed:
> > +   for (k = 0; k < i-1; k++)
> > +           video_unregister_device(vpbe_display_layer->video_dev);
> > +
> > +   for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
> > +           /* Get the pointer to the layer object */
> > +           vpbe_display_layer = disp_dev->dev[k];
> > +           /* Release video device */
> > +           video_device_release(vpbe_display_layer->video_dev);
> > +           /* Unregister video device */
> > +           video_unregister_device(vpbe_display_layer->video_dev);
> > +           vpbe_display_layer->video_dev = NULL;
> > +           /* free layer memory */
> > +           kfree(disp_dev->dev[k]);
> > +   }
>
> This should be moved to the error cleanup part of vpbe_display_probe() as well.
Done.
>
> > +   return -ENODEV;
> > +}
> > +
> > +
> > +
> > +/*
> > + * vpbe_display_probe()
> > + * This function creates device entries by register itself to the
> > +V4L2
> driver
> > + * and initializes fields of each layer objects  */ static __devinit
> > +int vpbe_display_probe(struct platform_device *pdev) {
> > +   struct vpbe_display *disp_dev;
> > +   struct resource *res;
> > +   int i;
> > +   int err;
> > +   int irq;
> > +
> > +   printk(KERN_DEBUG "vpbe_display_probe\n");
> > +   /* Allocate memory for vpbe_display */
> > +   disp_dev = kzalloc(sizeof(struct vpbe_display), GFP_KERNEL);
> > +   if (!disp_dev) {
> > +           printk(KERN_ERR "ran out of memory\n");
> > +           return -ENOMEM;
> > +   }
> > +
> > +   spin_lock_init(&disp_dev->dma_queue_lock);
> > +   /*
> > +    * Scan all the platform devices to find the vpbe
> > +    * controller device and get the vpbe_dev object
> > +    */
> > +   err = bus_for_each_dev(&platform_bus_type, NULL, disp_dev,
> > +                   vpbe_device_get);
> > +   if (err < 0)
> > +           return err;
> > +   /* Initialize the vpbe display controller */
> > +   if (NULL != disp_dev->vpbe_dev->ops.initialize) {
> > +           err = disp_dev->vpbe_dev->ops.initialize(&pdev->dev,
> > +                                                    disp_dev->vpbe_dev);
> > +           if (err) {
> > +                   v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
> > +                                   "Error initing vpbe\n");
> > +                   err = -ENOMEM;
> > +                   goto probe_out;
> > +           }
> > +   }
> > +
> > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > +           if (init_vpbe_layer(i, disp_dev, pdev)) {
> > +                   err = -ENODEV;
> > +                   goto probe_out;
> > +           }
> > +   }
> > +
> > +   res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +   if (!res) {
> > +           v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
> > +                    "Unable to get VENC interrupt resource\n");
> > +           err = -ENODEV;
> > +           goto probe_out;
> > +   }
> > +
> > +   irq = res->start;
> > +   if (request_irq(irq, venc_isr,  IRQF_DISABLED, VPBE_DISPLAY_DRIVER,
> > +           disp_dev)) {
> > +           v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
> > +                           "Unable to request interrupt\n");
> > +           err = -ENODEV;
> > +           goto probe_out;
> > +   }
> > +
> > +   for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
> > +           if (register_devices(i, disp_dev, pdev)) {
> > +                   err = -ENODEV;
> > +                   goto probe_out;
> > +           }
> > +   }
> > +
> > +   printk(KERN_DEBUG "Successfully completed the probing of vpbe v4l2
> device\n");
> > +   return 0;
> > +
> > +probe_out:
>
> You need to unregister the IRQ handler (and move the cleanup code from the two previous functions here).
Done.
>
> > +   kfree(disp_dev);
> > +   return err;
> > +}
>
> [snip]
>
> > +/* Function for module initialization and cleanup */
> > +module_init(vpbe_display_init); module_exit(vpbe_display_cleanup);
> > +
> > +MODULE_DESCRIPTION("TI DMXXX VPBE Display controller");
>
> What about "TI DM644x/DM355/DM365" then ? DMXXX makes it look like it supports all DaVinci chips.
Done.
>
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Texas Instruments");
>
> --
> Regards,
>
> Laurent Pinchart
>

