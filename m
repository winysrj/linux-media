Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3151 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2EZRuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 13:50:15 -0400
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 26 May 2012 19:50:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205261950.06022.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Ezequiel, your original CC list was mangled, so I'm reposting this)

Thanks!

Here is a quick run through of the code.

Always test your driver using the v4l2-compliance test tool that it part of
v4l-utils! If it passes that, then your code will be in really good shape!

On Sat May 26 2012 18:41:00 Ezequiel Garcia wrote:
> This driver adds support for stk1160 usb bridge as used in some
> video/audio usb capture devices.
> It is a complete rewrite of staging/media/easycap driver and
> it's expected as a future replacement.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> As of today testing has been performed using both vlc and mplayer
> on a gentoo machine, including hot unplug and on-the-fly standard
> change using a device with 1-cvs and 1-audio output.
> However more testing is underway with another device and/or another
> distribution.
> 
> Alsa sound support is a missing feature (work in progress).
> 
> As this is my first complete driver, the patch is (obviously) intended as RFC only.
> Any comments/reviews of *any* kind will be greatly appreciated.
> ---
>  drivers/media/video/Kconfig                 |    2 +
>  drivers/media/video/Makefile                |    1 +
>  drivers/media/video/stk1160/Kconfig         |   11 +
>  drivers/media/video/stk1160/Makefile        |    6 +
>  drivers/media/video/stk1160/stk1160-core.c  |  399 +++++++++++++
>  drivers/media/video/stk1160/stk1160-i2c.c   |  304 ++++++++++
>  drivers/media/video/stk1160/stk1160-reg.h   |   78 +++
>  drivers/media/video/stk1160/stk1160-v4l.c   |  846 +++++++++++++++++++++++++++
>  drivers/media/video/stk1160/stk1160-video.c |  506 ++++++++++++++++
>  drivers/media/video/stk1160/stk1160.h       |  183 ++++++
>  10 files changed, 2336 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/stk1160/Kconfig
>  create mode 100644 drivers/media/video/stk1160/Makefile
>  create mode 100644 drivers/media/video/stk1160/stk1160-core.c
>  create mode 100644 drivers/media/video/stk1160/stk1160-i2c.c
>  create mode 100644 drivers/media/video/stk1160/stk1160-reg.h
>  create mode 100644 drivers/media/video/stk1160/stk1160-v4l.c
>  create mode 100644 drivers/media/video/stk1160/stk1160-video.c
>  create mode 100644 drivers/media/video/stk1160/stk1160.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 99937c9..8d94d56 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -661,6 +661,8 @@ source "drivers/media/video/hdpvr/Kconfig"
>  
>  source "drivers/media/video/em28xx/Kconfig"
>  
> +source "drivers/media/video/stk1160/Kconfig"
> +
>  source "drivers/media/video/tlg2300/Kconfig"
>  
>  source "drivers/media/video/cx231xx/Kconfig"
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d209de0..7698b25 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -125,6 +125,7 @@ obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
>  obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>  obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
>  obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
> +obj-$(CONFIG_VIDEO_STK1160) += stk1160/
>  
>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
> diff --git a/drivers/media/video/stk1160/Kconfig b/drivers/media/video/stk1160/Kconfig
> new file mode 100644
> index 0000000..d481b8e
> --- /dev/null
> +++ b/drivers/media/video/stk1160/Kconfig
> @@ -0,0 +1,11 @@
> +config VIDEO_STK1160
> +	tristate "STK1160 USB video capture support"
> +	depends on VIDEO_DEV && I2C && EASYCAP!=m && EASYCAP!=y
> +	select VIDEOBUF2_VMALLOC
> +	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
> +
> +	---help---
> +	  This is a video4linux driver for STK1160 based video capture devices
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called stk1160
> diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/video/stk1160/Makefile
> new file mode 100644
> index 0000000..30ca209
> --- /dev/null
> +++ b/drivers/media/video/stk1160/Makefile
> @@ -0,0 +1,6 @@
> +stk1160-y := stk1160-core.o stk1160-v4l.o stk1160-video.o stk1160-i2c.o
> +
> +obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
> +
> +ccflags-y += -Wall
> +ccflags-y += -Idrivers/media/video
> diff --git a/drivers/media/video/stk1160/stk1160-core.c b/drivers/media/video/stk1160/stk1160-core.c
> new file mode 100644
> index 0000000..7fdee6b
> --- /dev/null

...

> +++ b/drivers/media/video/stk1160/stk1160-core.c
> +static int stk1160_probe(struct usb_interface *interface,
> +		const struct usb_device_id *id)
> +{
> +	int ifnum;
> +	int rc = 0;
> +
> +	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
> +	struct usb_device *udev;
> +	struct stk1160 *dev = NULL;
> +
> +	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
> +	udev = interface_to_usbdev(interface);
> +
> +	/* Don't register audio interfaces */
> +	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
> +		/* Why spit an error message? */
> +		stk1160_err("audio device (%04x:%04x): "
> +			"interface %i, class %i\n",
> +			le16_to_cpu(udev->descriptor.idVendor),
> +			le16_to_cpu(udev->descriptor.idProduct),
> +			ifnum,
> +			interface->altsetting[0].desc.bInterfaceClass);
> +		return -ENODEV;
> +	}
> +
> +	/* Alloc an array for all possible max_pkt_size */
> +	alt_max_pkt_size = kmalloc(sizeof(alt_max_pkt_size[0]) *
> +			interface->num_altsetting, GFP_KERNEL);
> +	if (alt_max_pkt_size == NULL)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Scan usb posibilities and populate alt_max_pkt_size array.
> +	 * Also, check if device speed is fast enough.
> +	 */
> +	rc = stk1160_scan_usb(interface, udev, alt_max_pkt_size);
> +	if (rc < 0) {
> +		kfree(alt_max_pkt_size);
> +		return rc;
> +	}
> +
> +	dev = kzalloc(sizeof(struct stk1160), GFP_KERNEL);
> +	if (dev == NULL) {
> +		kfree(alt_max_pkt_size);
> +		return -ENOMEM;
> +	}
> +
> +	dev->alt_max_pkt_size = alt_max_pkt_size;
> +	dev->udev = udev;
> +	dev->num_alt = interface->num_altsetting;
> +
> +	/* We save struct device for debug purposes only */
> +	dev->dev = &interface->dev;
> +
> +	usb_set_intfdata(interface, dev);
> +
> +	/* initialize videobuf2 stuff */
> +	rc = stk1160_vb2_setup(dev);
> +	if (rc < 0)
> +		goto free_err;
> +
> +	spin_lock_init(&dev->buf_lock);
> +
> +	/*
> +	 * We take the lock just before device registration,
> +	 * to prevent someone (probably udev) from opening us
> +	 * before we finish initialization
> +	 */
> +	mutex_init(&dev->mutex);
> +	mutex_lock(&dev->mutex);
> +
> +	rc = stk1160_video_register(dev);

It's usually better to register the video node as the very last thing
in probe(). That way when the node appears it's ready for udev to use.
No need to lock the mutex in that case.

> +	if (rc < 0)
> +		goto unreg_video;
> +
> +	rc = stk1160_i2c_register(dev);
> +	if (rc < 0)
> +		goto unlock_free;
> +
> +	/*
> +	 * To the best of my knowledge stk1160 boards only have
> +	 * saa7113, but it doesn't hurt to support them all.
> +	 */
> +	dev->sd_saa7115 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
> +		"saa7115_auto", 0, saa7113_addrs);
> +
> +	stk1160_info("driver ver %s successfully loaded\n",
> +		STK1160_VERSION);
> +
> +	/* i2c reset saa711x */
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
> +			SAA7115_COMPOSITE0, 0, 0);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
> +
> +	stk1160_reg_reset(dev);
> +
> +	mutex_unlock(&dev->mutex);
> +
> +	return 0;
> +
> +	/*
> +	 * Isn't this racy?
> +	 * If i2c_register fails, I unlock mutex, udev opens()
> +	 * but here I free device struct. So what happens
> +	 * with udev?
> +	 */
> +unreg_video:
> +	video_unregister_device(dev->vdev);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +unlock_free:
> +	mutex_unlock(&dev->mutex);
> +free_err:
> +	kfree(alt_max_pkt_size);
> +	kfree(dev);
> +	return rc;
> +}
> +
> +static void stk1160_disconnect(struct usb_interface *interface)
> +{
> +	struct stk1160 *dev;
> +
> +	dev = usb_get_intfdata(interface);
> +	usb_set_intfdata(interface, NULL);
> +
> +	/*
> +	 * Wait until all current v4l2 operation are finished
> +	 * then deallocate resources
> +	 */
> +	mutex_lock(&dev->mutex);
> +
> +	/* Since saa7115 is no longer present, it's better to unregister it */
> +	v4l2_device_unregister_subdev(dev->sd_saa7115);
> +
> +	stk1160_stop_streaming(dev);
> +
> +	v4l2_device_disconnect(&dev->v4l2_dev);
> +
> +	/* This way current users can detect device is gone */
> +	dev->udev = NULL;
> +
> +	mutex_unlock(&dev->mutex);
> +
> +	stk1160_i2c_unregister(dev);
> +	stk1160_video_unregister(dev);

I recommend that you use the same approach as I did in media/radio/dsbr100.c:
use the v4l2_dev->release callback to handle the final cleanup. That is a safe
method that does all the refcounting for you.

...

> diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
> new file mode 100644
> index 0000000..a7a012b
> --- /dev/null
> +++ b/drivers/media/video/stk1160/stk1160-v4l.c

...

> +static int stk1160_open(struct file *filp)
> +{
> +	struct stk1160 *dev = video_drvdata(filp);
> +
> +	dev->users++;

Why the users field? You shouldn't need it.

> +
> +	stk1160_info("opened: users=%d\n", dev->users);
> +
> +	return v4l2_fh_open(filp);
> +}
> +
> +static int stk1160_close(struct file *file)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	dev->users--;
> +
> +	stk1160_info("closed: users=%d\n", dev->users);
> +
> +	/*
> +	 * If this is the last fh remaining open, then we
> +	 * stop streaming and free/dequeue all buffers.
> +	 * This prevents device from streaming without
> +	 * any opened filehandles.
> +	 */
> +	if (v4l2_fh_is_singular_file(file))
> +		vb2_queue_release(&dev->vb_vidq);

No. You should keep track of which filehandle started streaming (actually
the filehandle that called REQBUFS is the owner of the queue) and release
the queue when that particular filehandle is closed (or it calls REQBUFS
with a count of 0).

> +
> +	return v4l2_fh_release(file);
> +}
> +
> +static int stk1160_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	stk1160_dbg("vma=0x%08lx\n", (unsigned long)vma);
> +
> +	rc = vb2_mmap(&dev->vb_vidq, vma);
> +
> +	stk1160_dbg("vma start=0x%08lx, size=%ld (%d)\n",
> +		(unsigned long)vma->vm_start,
> +		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
> +		rc);
> +	return rc;
> +}
> +
> +static struct v4l2_file_operations stk1160_fops = {
> +	.owner = THIS_MODULE,
> +	.open = stk1160_open,
> +	.release = stk1160_close,
> +	.read = stk1160_read,
> +	.poll = stk1160_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap = stk1160_mmap,
> +};
> +
> +/*
> + * IOCTL vidioc handling
> + */
> +static int vidioc_reqbufs(struct file *file, void *priv,
> +			  struct v4l2_requestbuffers *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_reqbufs(&dev->vb_vidq, p);
> +}
> +
> +static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_querybuf(&dev->vb_vidq, p);
> +}
> +
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_qbuf(&dev->vb_vidq, p);
> +}
> +
> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
> +}
> +
> +static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_streamon(&dev->vb_vidq, i);
> +}
> +
> +static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	return vb2_streamoff(&dev->vb_vidq, i);
> +}
> +
> +static int vidioc_querycap(struct file *file,
> +		void *priv, struct v4l2_capability *dev)
> +{
> +	strcpy(dev->driver, "stk1160");
> +	strcpy(dev->card, "stk1160");
> +	dev->version = STK1160_VERSION_NUM;
> +	dev->capabilities =
> +		V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_STREAMING |
> +		V4L2_CAP_READWRITE;
> +	return 0;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> +		struct v4l2_fmtdesc *f)
> +{
> +	if (f->index != 0)
> +		return -EINVAL;
> +
> +	strlcpy(f->description, format[f->index].name, sizeof(f->description));
> +	f->pixelformat = format[f->index].fourcc;
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	f->fmt.pix.width = dev->width;
> +	f->fmt.pix.height = dev->height;
> +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> +	f->fmt.pix.pixelformat = dev->fmt->fourcc;
> +	f->fmt.pix.bytesperline = dev->width << 1;
> +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +			struct v4l2_format *f)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	if (f->fmt.pix.pixelformat != format[0].fourcc) {
> +		stk1160_err("fourcc format 0x%08x invalid\n",
> +			f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * User can't choose size at his own will,
> +	 * so we just return him the current size chosen
> +	 * at standard selection.
> +	 * TODO: Implement frame scaling?
> +	 */
> +
> +	f->fmt.pix.width = dev->width;
> +	f->fmt.pix.height = dev->height;
> +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> +	f->fmt.pix.bytesperline = dev->width << 1;
> +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	struct vb2_queue *q = &dev->vb_vidq;
> +
> +	int ret = vidioc_try_fmt_vid_cap(file, priv, f);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (vb2_is_streaming(q)) {
> +		stk1160_err("device busy\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
> +	return 0;
> +}
> +
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	struct vb2_queue *q = &dev->vb_vidq;
> +
> +	if (vb2_is_streaming(q)) {
> +		stk1160_err("device busy\n");
> +		return -EBUSY;
> +	}
> +
> +	/* Check device presence */
> +	if (!dev->udev)
> +		return -ENODEV;
> +
> +	/* This is taken from saa7115 video decoder */
> +	if (dev->norm & V4L2_STD_525_60) {
> +		dev->width = 720;
> +		dev->height = 480;
> +	} else if (dev->norm & V4L2_STD_625_50) {
> +		dev->width = 720;
> +		dev->height = 576;
> +	} else {
> +		stk1160_err("invalid standard\n");
> +		return -EINVAL;
> +	}
> +
> +	/* We need to set this now, before we call stk1160_set_std() */
> +	dev->norm = *norm;
> +
> +	stk1160_set_std(dev);
> +
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> +
> +	return 0;
> +}
> +
> +/* FIXME: Extend support for other inputs */
> +static int vidioc_enum_input(struct file *file, void *priv,
> +				struct v4l2_input *i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	if (i->index != 0)
> +		return -EINVAL;
> +
> +	strcpy(i->name, "Composite1");
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	i->std = dev->vdev->tvnorms;
> +	return 0;
> +}
> +
> +static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	*i = dev->ctl_input;
> +	return 0;
> +}
> +
> +/* FIXME: Extend support for other inputs */
> +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	if (i != 0)
> +		return -EINVAL;
> +	dev->ctl_input = i;
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
> +			SAA7115_COMPOSITE0, 0, 0);
> +	return 0;
> +}
> +
> +static int vidioc_queryctrl(struct file *file, void *priv,
> +				struct v4l2_queryctrl *qc)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int id = qc->id;
> +
> +	memset(qc, 0, sizeof(*qc));
> +	qc->id = id;
> +
> +	/* enumerate V4L2 device controls */
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, qc);
> +	if (qc->type)
> +		return 0;
> +	else
> +		return -EINVAL;
> +}

Use the control framework. I won't accept any new drivers that do not use it.

In your case it is very simple: create a v4l2_ctrl_handler, initialize it and
let v4l2_dev->ctrl_handler point to it. When the subdev is added it will add its
controls to your handler.

> +
> +static int vidioc_g_ctrl(struct file *file, void *priv,
> +				struct v4l2_control *ctrl)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);
> +	return 0;
> +}
> +
> +static int vidioc_s_ctrl(struct file *file, void *priv,
> +				struct v4l2_control *ctrl)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
> +	return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *fh,
> +				 struct v4l2_frmsizeenum *fsize)
> +{
> +	/* TODO: Is this needed? */
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_frameintervals(struct file *file, void *fh,
> +				  struct v4l2_frmivalenum *fival)
> +{
> +	/* TODO: Is this needed? */
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
> +	.vidioc_querycap      = vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
> +	.vidioc_reqbufs       = vidioc_reqbufs,
> +	.vidioc_querybuf      = vidioc_querybuf,
> +	.vidioc_qbuf          = vidioc_qbuf,
> +	.vidioc_dqbuf         = vidioc_dqbuf,
> +	.vidioc_querystd      = vidioc_querystd,
> +	.vidioc_g_std         = NULL, /* don't worry v4l handles this */
> +	.vidioc_s_std         = vidioc_s_std,
> +	.vidioc_enum_input    = vidioc_enum_input,
> +	.vidioc_g_input       = vidioc_g_input,
> +	.vidioc_s_input       = vidioc_s_input,
> +	.vidioc_queryctrl     = vidioc_queryctrl,
> +	.vidioc_g_ctrl        = vidioc_g_ctrl,
> +	.vidioc_s_ctrl        = vidioc_s_ctrl,
> +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
> +	.vidioc_streamon      = vidioc_streamon,
> +	.vidioc_streamoff     = vidioc_streamoff,
> +};
> +
> +/********************************************************************/
> +
> +/*
> + * Videobuf2 operations
> + */
> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	unsigned long size;
> +
> +	size = dev->width * dev->height * 2;
> +
> +	/*
> +	 * Here we can change the number of buffers being requested.
> +	 * For instance, we could set a minimum and a maximum,
> +	 * like this:
> +	 */
> +	if (*nbuffers < STK1160_MIN_VIDEO_BUFFERS)
> +		*nbuffers = STK1160_MIN_VIDEO_BUFFERS;
> +	else if (*nbuffers > STK1160_MAX_VIDEO_BUFFERS)
> +		*nbuffers = STK1160_MAX_VIDEO_BUFFERS;
> +
> +	/* This means a packed colorformat */
> +	*nplanes = 1;
> +
> +	sizes[0] = size;
> +
> +	/*
> +	 * videobuf2-vmalloc allocator is context-less so no need to set
> +	 * alloc_ctxs array.
> +	 */
> +
> +	if (v4l_fmt) {
> +		stk1160_info("selected format %d (%d)\n",
> +			v4l_fmt->fmt.pix.pixelformat,
> +			dev->fmt->fourcc);
> +	}
> +
> +	stk1160_info("%s: buffer count %d, each %ld bytes\n",
> +			__func__, *nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static int buffer_init(struct vb2_buffer *vb)
> +{
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct stk1160_buffer *buf =
> +			container_of(vb, struct stk1160_buffer, vb);
> +
> +	/* If the device is disconnected, reject the buffer */
> +	if (!dev->udev)
> +		return -ENODEV;
> +
> +	buf->mem = vb2_plane_vaddr(vb, 0);
> +	buf->length = vb2_plane_size(vb, 0);
> +	buf->bytesused = 0;
> +	buf->pos = 0;
> +
> +	return 0;
> +}
> +
> +static int buffer_finish(struct vb2_buffer *vb)
> +{
> +	return 0;
> +}
> +
> +static void buffer_cleanup(struct vb2_buffer *vb)
> +{
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	unsigned long flags = 0;
> +	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct stk1160_buffer *buf =
> +		container_of(vb, struct stk1160_buffer, vb);
> +
> +	spin_lock_irqsave(&dev->buf_lock, flags);
> +	if (!dev->udev) {
> +		/*
> +		 * If the device is disconnected return the buffer to userspace
> +		 * directly. The next QBUF call will fail with -ENODEV.
> +		 */
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	} else {
> +		list_add_tail(&buf->list, &dev->avail_bufs);
> +	}
> +	spin_unlock_irqrestore(&dev->buf_lock, flags);
> +}
> +
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	return stk1160_start_streaming(dev);
> +}
> +
> +/* abort streaming and wait for last buffer */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	return stk1160_stop_streaming(dev);
> +}
> +
> +static void stk1160_lock(struct vb2_queue *vq)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	mutex_lock(&dev->mutex);
> +}
> +
> +static void stk1160_unlock(struct vb2_queue *vq)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	mutex_unlock(&dev->mutex);
> +}
> +
> +static void stk1160_release(struct video_device *vd)
> +{
> +	struct stk1160 *dev = video_get_drvdata(vd);
> +
> +	stk1160_info("releasing all resources\n");
> +
> +	video_set_drvdata(vd, NULL);
> +	video_device_release(vd);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +	kfree(dev->alt_max_pkt_size);
> +	kfree(dev);
> +}
> +
> +static struct vb2_ops stk1160_video_qops = {
> +	.queue_setup		= queue_setup,
> +	.buf_init		= buffer_init,
> +	.buf_prepare		= buffer_prepare,
> +	.buf_finish		= buffer_finish,
> +	.buf_cleanup		= buffer_cleanup,
> +	.buf_queue		= buffer_queue,
> +	.start_streaming	= start_streaming,
> +	.stop_streaming		= stop_streaming,
> +	.wait_prepare		= stk1160_unlock,
> +	.wait_finish		= stk1160_lock,
> +};
> +
> +static struct video_device v4l_template = {
> +	.name = "stk1160",
> +	.tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50,
> +	.current_norm = V4L2_STD_NTSC,
> +	.fops = &stk1160_fops,
> +	.ioctl_ops = &stk1160_ioctl_ops,
> +	.release = stk1160_release,
> +};
> +
> +/********************************************************************/
> +
> +int stk1160_vb2_setup(struct stk1160 *dev)
> +{
> +	int rc;
> +	struct vb2_queue *q;
> +
> +	q = &dev->vb_vidq;
> +	memset(q, 0, sizeof(dev->vb_vidq));
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct stk1160_buffer);
> +	q->ops = &stk1160_video_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +
> +	rc = vb2_queue_init(q);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* initialize video dma queue */
> +	INIT_LIST_HEAD(&dev->avail_bufs);
> +
> +	return 0;
> +}
> +
> +int stk1160_video_register(struct stk1160 *dev)
> +{
> +	int rc = -ENOMEM;
> +
> +	/* There is no need to set the name if we give a device struct */
> +	rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
> +	if (rc) {
> +		stk1160_err("v4l2_device_register failed (%d)\n", rc);
> +		return -ENOMEM;
> +	}
> +
> +	dev->vdev = video_device_alloc();

I recommend that vdev is not a pointer but the struct video_device itself
embedded in the struct stk1160. The release callback can be video_device_release_empty
in that case. stk1160_release should be set as the release callback of v4l2_dev.

> +	if (!dev->vdev) {
> +		stk1160_err("video_device_alloc failed (%d)\n", rc);
> +		goto unreg;
> +	}
> +
> +	/* Initialize video_device with a template structure */
> +	*dev->vdev = v4l_template;
> +	dev->vdev->debug = vidioc_debug;
> +
> +	/*
> +	 * Provide a mutex to v4l2 core.
> +	 * It will be used to protect all fops and v4l2 ioctls.
> +	 */
> +	dev->vdev->lock = &dev->mutex;

Please note: we made a change for 3.5 where this lock is only used for
ioctls, not for other file operations. You will have to review your code
whether or not to take the lock explicitly for those other file operations.

> +
> +	/* This will be used to set video_device parent */
> +	dev->vdev->v4l2_dev = &dev->v4l2_dev;
> +
> +	/* It is safer to set this before registering with v4l2 */
> +	video_set_drvdata(dev->vdev, dev);
> +
> +	rc = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);

Do this as the last thing in this function.

> +	if (rc < 0) {
> +		stk1160_err("video_register_device failed (%d)\n", rc);
> +		goto release;
> +	}
> +
> +	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
> +		  video_device_node_name(dev->vdev));
> +
> +	/* I say PAL_Nc is default, could be anyother */
> +	dev->width = 720;
> +	dev->height = 480;
> +
> +	/* set default norm and input */
> +	dev->norm = V4L2_STD_NTSC;
> +	dev->ctl_input = 0;
> +
> +	/* set default format */
> +	dev->fmt = &format[0];
> +	stk1160_set_std(dev);
> +
> +	return 0;
> +
> +release:
> +	video_device_release(dev->vdev);
> +unreg:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +	return rc;
> +}
> +
> +void stk1160_video_unregister(struct stk1160 *dev)
> +{
> +	v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
> +		video_device_node_name(dev->vdev));
> +
> +	/*
> +	 * This will put video_device, thus calling stk1160_release
> +	 * if it's the last reference. Otherwise,
> +	 * release is posponed until there are no users left.
> +	 */
> +	video_unregister_device(dev->vdev);
> +}

Regards,

	Hans
