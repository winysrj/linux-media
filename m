Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1394 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2BENLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 08:11:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 2/2] radio-maxiradio: use the tea575x framework.
Date: Sun, 5 Feb 2012 14:11:31 +0100
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <a9d0e4a1a621edf0a0395bc58544cbd3d1d9ec8f.1328447188.git.hans.verkuil@cisco.com> <23314feec7f88b4e899712552bb4812c67a25531.1328447188.git.hans.verkuil@cisco.com>
In-Reply-To: <23314feec7f88b4e899712552bb4812c67a25531.1328447188.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202051411.31704.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore this, I'll repost the proper version soon.

I pressed 'n' when I should have pressed 'q' :-)

On Sunday, February 05, 2012 14:06:32 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This card is based on the tea575x receiver. Use the tea575x-tuner framework
> instead of reinventing the wheel.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/Kconfig           |    2 +-
>  drivers/media/radio/radio-maxiradio.c |  379 ++++++---------------------------
>  2 files changed, 65 insertions(+), 316 deletions(-)
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 48747df..6591f8b 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -43,7 +43,7 @@ config USB_DSBR
>  
>  config RADIO_MAXIRADIO
>  	tristate "Guillemot MAXI Radio FM 2000 radio"
> -	depends on VIDEO_V4L2 && PCI
> +	depends on VIDEO_V4L2 && PCI && SND
>  	---help---
>  	  Choose Y here if you have this radio card.  This card may also be
>  	  found as Gemtek PCI FM.
> diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
> index f872a54..740a3d5 100644
> --- a/drivers/media/radio/radio-maxiradio.c
> +++ b/drivers/media/radio/radio-maxiradio.c
> @@ -42,67 +42,37 @@
>  #include <linux/videodev2.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <sound/tea575x-tuner.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> -
> -#define DRIVER_VERSION	"0.7.8"
> -
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
>  
>  MODULE_AUTHOR("Dimitromanolakis Apostolos, apdim@grecian.net");
> -MODULE_DESCRIPTION("Radio driver for the Guillemot Maxi Radio FM2000 radio.");
> +MODULE_DESCRIPTION("Radio driver for the Guillemot Maxi Radio FM2000.");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRIVER_VERSION);
> +MODULE_VERSION("1.0.0");
>  
>  static int radio_nr = -1;
> -module_param(radio_nr, int, 0);
> -
> -static int debug;
> -
> -module_param(debug, int, 0644);
> -MODULE_PARM_DESC(debug, "activates debug info");
> -
> -#define dprintk(dev, num, fmt, arg...) \
> -	v4l2_dbg(num, debug, &dev->v4l2_dev, fmt, ## arg)
> -
> -#ifndef PCI_VENDOR_ID_GUILLEMOT
> -#define PCI_VENDOR_ID_GUILLEMOT 0x5046
> -#endif
> -
> -#ifndef PCI_DEVICE_ID_GUILLEMOT
> -#define PCI_DEVICE_ID_GUILLEMOT_MAXIRADIO 0x1001
> -#endif
> -
> +module_param(radio_nr, int, 0644);
> +MODULE_PARM_DESC(radio_nr, "Radio device number");
>  
>  /* TEA5757 pin mappings */
>  static const int clk = 1, data = 2, wren = 4, mo_st = 8, power = 16;
>  
> -#define FREQ_LO		(87 * 16000)
> -#define FREQ_HI		(108 * 16000)
> -
> -#define FREQ_IF         171200 /* 10.7*16000   */
> -#define FREQ_STEP       200    /* 12.5*16      */
> -
> -/* (x==fmhz*16*1000) -> bits */
> -#define FREQ2BITS(x) \
> -  ((((unsigned int)(x) + FREQ_IF + (FREQ_STEP << 1)) / (FREQ_STEP << 2)) << 2)
> -
> -#define BITS2FREQ(x)	((x) * FREQ_STEP - FREQ_IF)
> +static atomic_t maxiradio_instance = ATOMIC_INIT(0);
>  
> +#define PCI_VENDOR_ID_GUILLEMOT 0x5046
> +#define PCI_DEVICE_ID_GUILLEMOT_MAXIRADIO 0x1001
>  
>  struct maxiradio
>  {
> +	struct snd_tea575x tea;
>  	struct v4l2_device v4l2_dev;
> -	struct video_device vdev;
>  	struct pci_dev *pdev;
>  
>  	u16	io;	/* base of radio io */
> -	u16	muted;	/* VIDEO_AUDIO_MUTE */
> -	u16	stereo;	/* VIDEO_TUNER_STEREO_ON */
> -	u16	tuned;	/* signal strength (0 or 0xffff) */
> -
> -	unsigned long freq;
> -
> -	struct mutex lock;
>  };
>  
>  static inline struct maxiradio *to_maxiradio(struct v4l2_device *v4l2_dev)
> @@ -110,259 +80,41 @@ static inline struct maxiradio *to_maxiradio(struct v4l2_device *v4l2_dev)
>  	return container_of(v4l2_dev, struct maxiradio, v4l2_dev);
>  }
>  
> -static void outbit(unsigned long bit, u16 io)
> -{
> -	int val = power | wren | (bit ? data : 0);
> -
> -	outb(val, io);
> -	udelay(4);
> -	outb(val | clk, io);
> -	udelay(4);
> -	outb(val, io);
> -	udelay(4);
> -}
> -
> -static void turn_power(struct maxiradio *dev, int p)
> -{
> -	if (p != 0) {
> -		dprintk(dev, 1, "Radio powered on\n");
> -		outb(power, dev->io);
> -	} else {
> -		dprintk(dev, 1, "Radio powered off\n");
> -		outb(0, dev->io);
> -	}
> -}
> -
> -static void set_freq(struct maxiradio *dev, u32 freq)
> -{
> -	unsigned long int si;
> -	int bl;
> -	int io = dev->io;
> -	int val = FREQ2BITS(freq);
> -
> -	/* TEA5757 shift register bits (see pdf) */
> -
> -	outbit(0, io); /* 24  search */
> -	outbit(1, io); /* 23  search up/down */
> -
> -	outbit(0, io); /* 22  stereo/mono */
> -
> -	outbit(0, io); /* 21  band */
> -	outbit(0, io); /* 20  band (only 00=FM works I think) */
> -
> -	outbit(0, io); /* 19  port ? */
> -	outbit(0, io); /* 18  port ? */
> -
> -	outbit(0, io); /* 17  search level */
> -	outbit(0, io); /* 16  search level */
> -
> -	si = 0x8000;
> -	for (bl = 1; bl <= 16; bl++) {
> -		outbit(val & si, io);
> -		si >>= 1;
> -	}
> -
> -	dprintk(dev, 1, "Radio freq set to %d.%02d MHz\n",
> -				freq / 16000,
> -				freq % 16000 * 100 / 16000);
> -
> -	turn_power(dev, 1);
> -}
> -
> -static int get_stereo(u16 io)
> +static void maxiradio_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
>  {
> -	outb(power,io);
> -	udelay(4);
> +	struct maxiradio *dev = tea->private_data;
> +	u8 bits = 0;
>  
> -	return !(inb(io) & mo_st);
> -}
> +	bits |= (pins & TEA575X_DATA) ? data : 0;
> +	bits |= (pins & TEA575X_CLK)  ? clk  : 0;
> +	bits |= (pins & TEA575X_WREN) ? wren : 0;
> +	bits |= power;
>  
> -static int get_tune(u16 io)
> -{
> -	outb(power+clk,io);
> -	udelay(4);
> -
> -	return !(inb(io) & mo_st);
> -}
> -
> -
> -static int vidioc_querycap(struct file *file, void  *priv,
> -			    struct v4l2_capability *v)
> -{
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	strlcpy(v->driver, "radio-maxiradio", sizeof(v->driver));
> -	strlcpy(v->card, "Maxi Radio FM2000 radio", sizeof(v->card));
> -	snprintf(v->bus_info, sizeof(v->bus_info), "PCI:%s", pci_name(dev->pdev));
> -	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> -	return 0;
> +	outb(bits, dev->io);
>  }
>  
> -static int vidioc_g_tuner(struct file *file, void *priv,
> -			   struct v4l2_tuner *v)
> +/* Note: this card cannot read out the data of the shift registers,
> +   only the mono/stereo pin works. */
> +static u8 maxiradio_tea575x_get_pins(struct snd_tea575x *tea)
>  {
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	if (v->index > 0)
> -		return -EINVAL;
> -
> -	mutex_lock(&dev->lock);
> -	strlcpy(v->name, "FM", sizeof(v->name));
> -	v->type = V4L2_TUNER_RADIO;
> -	v->rangelow = FREQ_LO;
> -	v->rangehigh = FREQ_HI;
> -	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
> -	v->capability = V4L2_TUNER_CAP_LOW;
> -	if (get_stereo(dev->io))
> -		v->audmode = V4L2_TUNER_MODE_STEREO;
> -	else
> -		v->audmode = V4L2_TUNER_MODE_MONO;
> -	v->signal = 0xffff * get_tune(dev->io);
> -	mutex_unlock(&dev->lock);
> +	struct maxiradio *dev = tea->private_data;
> +	u8 bits = inb(dev->io);
>  
> -	return 0;
> +	return  ((bits & data) ? TEA575X_DATA : 0) |
> +		((bits & mo_st) ? TEA575X_MOST : 0);
>  }
>  
> -static int vidioc_s_tuner(struct file *file, void *priv,
> -			   struct v4l2_tuner *v)
> +static void maxiradio_tea575x_set_direction(struct snd_tea575x *tea, bool output)
>  {
> -	return v->index ? -EINVAL : 0;
>  }
>  
> -static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
> -{
> -	*i = 0;
> -	return 0;
> -}
> -
> -static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
> -{
> -	return i ? -EINVAL : 0;
> -}
> -
> -static int vidioc_g_audio(struct file *file, void *priv,
> -			   struct v4l2_audio *a)
> -{
> -	a->index = 0;
> -	strlcpy(a->name, "Radio", sizeof(a->name));
> -	a->capability = V4L2_AUDCAP_STEREO;
> -	return 0;
> -}
> -
> -
> -static int vidioc_s_audio(struct file *file, void *priv,
> -			   struct v4l2_audio *a)
> -{
> -	return a->index ? -EINVAL : 0;
> -}
> -
> -static int vidioc_s_frequency(struct file *file, void *priv,
> -			       struct v4l2_frequency *f)
> -{
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> -		return -EINVAL;
> -	if (f->frequency < FREQ_LO || f->frequency > FREQ_HI) {
> -		dprintk(dev, 1, "radio freq (%d.%02d MHz) out of range (%d-%d)\n",
> -					f->frequency / 16000,
> -					f->frequency % 16000 * 100 / 16000,
> -					FREQ_LO / 16000, FREQ_HI / 16000);
> -
> -		return -EINVAL;
> -	}
> -
> -	mutex_lock(&dev->lock);
> -	dev->freq = f->frequency;
> -	set_freq(dev, dev->freq);
> -	msleep(125);
> -	mutex_unlock(&dev->lock);
> -
> -	return 0;
> -}
> -
> -static int vidioc_g_frequency(struct file *file, void *priv,
> -			       struct v4l2_frequency *f)
> -{
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	if (f->tuner != 0)
> -		return -EINVAL;
> -	f->type = V4L2_TUNER_RADIO;
> -	f->frequency = dev->freq;
> -
> -	dprintk(dev, 4, "radio freq is %d.%02d MHz",
> -				f->frequency / 16000,
> -				f->frequency % 16000 * 100 / 16000);
> -
> -	return 0;
> -}
> -
> -static int vidioc_queryctrl(struct file *file, void *priv,
> -			     struct v4l2_queryctrl *qc)
> -{
> -	switch (qc->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -	}
> -	return -EINVAL;
> -}
> -
> -static int vidioc_g_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *ctrl)
> -{
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		ctrl->value = dev->muted;
> -		return 0;
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int vidioc_s_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *ctrl)
> -{
> -	struct maxiradio *dev = video_drvdata(file);
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		mutex_lock(&dev->lock);
> -		dev->muted = ctrl->value;
> -		if (dev->muted)
> -			turn_power(dev, 0);
> -		else
> -			set_freq(dev, dev->freq);
> -		mutex_unlock(&dev->lock);
> -		return 0;
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static const struct v4l2_file_operations maxiradio_fops = {
> -	.owner		= THIS_MODULE,
> -	.unlocked_ioctl = video_ioctl2,
> +static struct snd_tea575x_ops maxiradio_tea_ops = {
> +	.set_pins = maxiradio_tea575x_set_pins,
> +	.get_pins = maxiradio_tea575x_get_pins,
> +	.set_direction = maxiradio_tea575x_set_direction,
>  };
>  
> -static const struct v4l2_ioctl_ops maxiradio_ioctl_ops = {
> -	.vidioc_querycap    = vidioc_querycap,
> -	.vidioc_g_tuner     = vidioc_g_tuner,
> -	.vidioc_s_tuner     = vidioc_s_tuner,
> -	.vidioc_g_audio     = vidioc_g_audio,
> -	.vidioc_s_audio     = vidioc_s_audio,
> -	.vidioc_g_input     = vidioc_g_input,
> -	.vidioc_s_input     = vidioc_s_input,
> -	.vidioc_g_frequency = vidioc_g_frequency,
> -	.vidioc_s_frequency = vidioc_s_frequency,
> -	.vidioc_queryctrl   = vidioc_queryctrl,
> -	.vidioc_g_ctrl      = vidioc_g_ctrl,
> -	.vidioc_s_ctrl      = vidioc_s_ctrl,
> -};
> -
> -static int __devinit maxiradio_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> +static int __devinit maxiradio_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	struct maxiradio *dev;
>  	struct v4l2_device *v4l2_dev;
> @@ -375,63 +127,60 @@ static int __devinit maxiradio_init_one(struct pci_dev *pdev, const struct pci_d
>  	}
>  
>  	v4l2_dev = &dev->v4l2_dev;
> -	mutex_init(&dev->lock);
> -	dev->pdev = pdev;
> -	dev->muted = 1;
> -	dev->freq = FREQ_LO;
> -
> -	strlcpy(v4l2_dev->name, "maxiradio", sizeof(v4l2_dev->name));
> +	v4l2_device_set_name(v4l2_dev, "maxiradio", &maxiradio_instance);
>  
>  	retval = v4l2_device_register(&pdev->dev, v4l2_dev);
>  	if (retval < 0) {
>  		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
>  		goto errfr;
>  	}
> +	dev->tea.private_data = dev;
> +	dev->tea.ops = &maxiradio_tea_ops;
> +	/* The data pin cannot be read. This may be a hardware limitation, or
> +	   we just don't know how to read it. */
> +	dev->tea.cannot_read_data = true;
> +	dev->tea.v4l2_dev = v4l2_dev;
> +	dev->tea.radio_nr = radio_nr;
> +	strlcpy(dev->tea.card, "Maxi Radio FM2000", sizeof(dev->tea.card));
> +	snprintf(dev->tea.bus_info, sizeof(dev->tea.bus_info),
> +			"PCI:%s", pci_name(pdev));
> +
> +	retval = -ENODEV;
>  
>  	if (!request_region(pci_resource_start(pdev, 0),
> -			   pci_resource_len(pdev, 0), "Maxi Radio FM 2000")) {
> -		v4l2_err(v4l2_dev, "can't reserve I/O ports\n");
> -		goto err_out;
> +			   pci_resource_len(pdev, 0), v4l2_dev->name)) {
> +		dev_err(&pdev->dev, "can't reserve I/O ports\n");
> +		goto err_hdl;
>  	}
>  
>  	if (pci_enable_device(pdev))
>  		goto err_out_free_region;
>  
>  	dev->io = pci_resource_start(pdev, 0);
> -	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
> -	dev->vdev.v4l2_dev = v4l2_dev;
> -	dev->vdev.fops = &maxiradio_fops;
> -	dev->vdev.ioctl_ops = &maxiradio_ioctl_ops;
> -	dev->vdev.release = video_device_release_empty;
> -	video_set_drvdata(&dev->vdev, dev);
> -
> -	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
> -		v4l2_err(v4l2_dev, "can't register device!");
> +	if (snd_tea575x_init(&dev->tea)) {
> +		printk(KERN_ERR "radio-maxiradio: Unable to detect TEA575x tuner\n");
>  		goto err_out_free_region;
>  	}
> -
> -	v4l2_info(v4l2_dev, "version " DRIVER_VERSION "\n");
> -
> -	v4l2_info(v4l2_dev, "found Guillemot MAXI Radio device (io = 0x%x)\n",
> -	       dev->io);
>  	return 0;
>  
>  err_out_free_region:
>  	release_region(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
> -err_out:
> +err_hdl:
>  	v4l2_device_unregister(v4l2_dev);
>  errfr:
>  	kfree(dev);
> -	return -ENODEV;
> +	return retval;
>  }
>  
> -static void __devexit maxiradio_remove_one(struct pci_dev *pdev)
> +static void __devexit maxiradio_remove(struct pci_dev *pdev)
>  {
>  	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
>  	struct maxiradio *dev = to_maxiradio(v4l2_dev);
>  
> -	video_unregister_device(&dev->vdev);
> -	v4l2_device_unregister(&dev->v4l2_dev);
> +	snd_tea575x_exit(&dev->tea);
> +	/* Turn off power */
> +	outb(0, dev->io);
> +	v4l2_device_unregister(v4l2_dev);
>  	release_region(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
>  }
>  
> @@ -446,19 +195,19 @@ MODULE_DEVICE_TABLE(pci, maxiradio_pci_tbl);
>  static struct pci_driver maxiradio_driver = {
>  	.name		= "radio-maxiradio",
>  	.id_table	= maxiradio_pci_tbl,
> -	.probe		= maxiradio_init_one,
> -	.remove		= __devexit_p(maxiradio_remove_one),
> +	.probe		= maxiradio_probe,
> +	.remove		= __devexit_p(maxiradio_remove),
>  };
>  
> -static int __init maxiradio_radio_init(void)
> +static int __init maxiradio_init(void)
>  {
>  	return pci_register_driver(&maxiradio_driver);
>  }
>  
> -static void __exit maxiradio_radio_exit(void)
> +static void __exit maxiradio_exit(void)
>  {
>  	pci_unregister_driver(&maxiradio_driver);
>  }
>  
> -module_init(maxiradio_radio_init);
> -module_exit(maxiradio_radio_exit);
> +module_init(maxiradio_init);
> +module_exit(maxiradio_exit);
> 
