Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2B1RRD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 12:17:03 -0500
Message-ID: <4F4D0C09.10203@redhat.com>
Date: Tue, 28 Feb 2012 14:16:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx23885: Add basic analog radio support
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com>
In-Reply-To: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-01-2012 16:25, Miroslav Slugeň escreveu:
> New version of patch, fixed video modes for DVR3200 tuners and working
> audio mux.
> 
> 
> cx23885-add-basic-fm-radio-support_v3.patch

If you want it to be applied, please add your Signed-off-by on it.

See the patch review below.

Thanks,
Mauro
> 
> 
> Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
> From: Miroslav Slugen <thunder.mmm@gmail.com>
> Date: Sat, 17 Dec 2011 01:23:22 +0100
> Subject: [PATCH] Add support for radio tuners to cx23885 driver, and add example of radio support
>  for Leadtek DVR3200 H tuners.
> 
>  Version 3
> 
> diff -Naurp a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
> --- a/drivers/media/video/cx23885/cx23885-cards.c	2012-01-14 18:43:40.000000000 +0100
> +++ b/drivers/media/video/cx23885/cx23885-cards.c	2012-01-14 19:04:58.412366747 +0100
> @@ -205,35 +205,87 @@ struct cx23885_board cx23885_boards[] =
>  	},
>  	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
>  		.name		= "Leadtek Winfast PxDVR3200 H",
> +		.porta		= CX23885_ANALOG_VIDEO,
> +		.portb		= CX23885_MPEG_ENCODER,
>  		.portc		= CX23885_MPEG_DVB,
> +		.tuner_type	= TUNER_XC2028,
> +		.tuner_addr	= 0x61,
> +		.radio_type	= UNSET,
> +		.radio_addr	= ADDR_UNSET,
> +		.tuner_bus	= 1,
> +		.input		= {{
> +			.type	= CX23885_VMUX_TELEVISION,
> +			.vmux	= CX25840_VIN2_CH1 |
> +				  CX25840_VIN5_CH2,
> +			.amux	= CX25840_AUDIO8,
> +			.gpio0	= 0x704040,
> +		}, {
> +			.type	= CX23885_VMUX_COMPOSITE1,
> +			.vmux	= CX25840_VIN1_CH1,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
> +		}, {
> +			.type	= CX23885_VMUX_SVIDEO,
> +			.vmux	= CX25840_VIN3_CH1 |
> +				  CX25840_SVIDEO_ON,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
> +		}, {
> +			.type	= CX23885_VMUX_COMPONENT,
> +			.vmux	= CX25840_VIN7_CH1 |
> +				  CX25840_VIN6_CH2 |
> +				  CX25840_VIN8_CH3 |
> +				  CX25840_COMPONENT_ON,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
> +		} },
> +		.radio = {
> +			.type	= CX23885_RADIO,
> +			.amux	= CX25840_AUDIO8,
> +			.gpio0	= 0x706060,
> +		},
>  	},
>  	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000] = {
>  		.name		= "Leadtek Winfast PxDVR3200 H XC4000",
>  		.porta		= CX23885_ANALOG_VIDEO,
> +		.portb		= CX23885_MPEG_ENCODER,
>  		.portc		= CX23885_MPEG_DVB,
>  		.tuner_type	= TUNER_XC4000,
>  		.tuner_addr	= 0x61,
>  		.radio_type	= UNSET,
>  		.radio_addr	= ADDR_UNSET,
> +		.tuner_bus	= 1,
>  		.input		= {{
>  			.type	= CX23885_VMUX_TELEVISION,
>  			.vmux	= CX25840_VIN2_CH1 |
> -				  CX25840_VIN5_CH2 |
> -				  CX25840_NONE0_CH3,
> +				  CX25840_VIN5_CH2,
> +			.amux	= CX25840_AUDIO8,
> +			.gpio0	= 0x704040,
>  		}, {
>  			.type	= CX23885_VMUX_COMPOSITE1,
> -			.vmux	= CX25840_COMPOSITE1,
> +			.vmux	= CX25840_VIN1_CH1,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
>  		}, {
>  			.type	= CX23885_VMUX_SVIDEO,
> -			.vmux	= CX25840_SVIDEO_LUMA3 |
> -				  CX25840_SVIDEO_CHROMA4,
> +			.vmux	= CX25840_VIN3_CH1 |
> +				  CX25840_SVIDEO_ON,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
>  		}, {
>  			.type	= CX23885_VMUX_COMPONENT,
>  			.vmux	= CX25840_VIN7_CH1 |
>  				  CX25840_VIN6_CH2 |
>  				  CX25840_VIN8_CH3 |
>  				  CX25840_COMPONENT_ON,
> +			.amux	= CX25840_AUDIO7,
> +			.gpio0	= 0x704040,
>  		} },
> +		.radio = {
> +			.type	= CX23885_RADIO,
> +			.amux	= CX25840_AUDIO8,
> +			.gpio0	= 0x706060,
> +		},
>  	},
>  	[CX23885_BOARD_COMPRO_VIDEOMATE_E650F] = {
>  		.name		= "Compro VideoMate E650F",
> @@ -818,27 +870,95 @@ static void hauppauge_eeprom(struct cx23
>  			dev->name, tv.model);
>  }
>  
> +static int cx23885_xc2028_leadtek_callback(struct cx23885_dev *dev,
> +					   int command, int arg)
> +{
> +	switch (command) {
> +	case XC2028_TUNER_RESET:
> +		/* GPIO 12 (xc2028 tuner reset) */
> +		cx_set(GP0_IO, 0x00040000);
> +		mdelay(75);
> +		cx_clear(GP0_IO, 0x00000004);
> +		mdelay(75);
> +		cx_set(GP0_IO, 0x00040004);
> +		mdelay(75);
> +		return 0;
> +	case XC2028_RESET_CLK:
> +	case XC2028_I2C_FLUSH:
> +		break;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int cx23885_xc4000_leadtek_callback(struct cx23885_dev *dev,
> +					   int command, int arg)
> +{
> +	switch (command) {
> +	case XC4000_TUNER_RESET:
> +		/* GPIO 12 (xc4000 tuner reset) */
> +		cx_set(GP0_IO, 0x00040000);
> +		mdelay(75);
> +		cx_clear(GP0_IO, 0x00000004);
> +		mdelay(75);
> +		cx_set(GP0_IO, 0x00040004);
> +		mdelay(75);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int cx23885_xc2028_tuner_callback(struct cx23885_dev *dev,
> +					 int command, int arg)
> +{
> +	/* Board-specific callbacks */
> +	switch (dev->board) {
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +		return cx23885_xc2028_leadtek_callback(dev, command, arg);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int cx23885_xc4000_tuner_callback(struct cx23885_dev *dev,
> +					 int command, int arg)
> +{
> +	/* Board-specific callbacks */
> +	switch (dev->board) {
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
> +		return cx23885_xc4000_leadtek_callback(dev, command, arg);
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  int cx23885_tuner_callback(void *priv, int component, int command, int arg)
>  {
>  	struct cx23885_tsport *port = priv;
> -	struct cx23885_dev *dev = port->dev;
> +	struct cx23885_dev *dev;
>  	u32 bitmask = 0;
>  
> -	if (command == XC2028_RESET_CLK)
> -		return 0;
> +	if (!port) {
> +		printk(KERN_ERR "cx23885: Error - private data undefined.\n");
> +		return -EINVAL;
> +	}
> +
> +	dev = port->dev;
>  
> -	if (command != 0) {
> -		printk(KERN_ERR "%s(): Unknown command 0x%x.\n",
> -			__func__, command);
> +	if (!dev) {
> +		printk(KERN_ERR "cx23885: Error - device struct undefined.\n");
>  		return -EINVAL;
>  	}
>  
>  	switch (dev->board) {
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +		printk(KERN_INFO "%s: Calling XC2028/3028 callback\n", dev->name);
> +		return cx23885_xc2028_tuner_callback(dev, command, arg);
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
> +		printk(KERN_INFO "%s: Calling XC4000 callback\n", dev->name);
> +		return cx23885_xc4000_tuner_callback(dev, command, arg);
>  	case CX23885_BOARD_HAUPPAUGE_HVR1400:
>  	case CX23885_BOARD_HAUPPAUGE_HVR1500:
>  	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
> -	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> -	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
>  	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>  	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>  	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:

The changes don't seem to be cool on my eyes: if you're splitting the tuner callback
into a separate xc4000 and a separate xc2028 call, you need to move the board-specific
stuff into there; if not, then just put the code for Leadtek directly into this
routine. I would just move the code into the sub-routine, as the only thing you're
doing inside the cx23885_xc4000_tuner_callback()/cx23885_xc2028_tuner_callback(() is to
call another sub-routine.

> @@ -861,6 +981,9 @@ int cx23885_tuner_callback(void *priv, i
>  	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
>  		altera_ci_tuner_reset(dev, port->nr);
>  		break;
> +	default:
> +		printk(KERN_ERR "cx23885: Error: Calling callback for card %d\n", dev->board);
> +		break;
>  	}
>  
>  	if (bitmask) {
> @@ -872,6 +995,7 @@ int cx23885_tuner_callback(void *priv, i
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(cx23885_tuner_callback);

Please use, instead, EXPORT_SYMBOL_GPL().
>  
>  void cx23885_gpio_setup(struct cx23885_dev *dev)
>  {
> @@ -999,7 +1123,11 @@ void cx23885_gpio_setup(struct cx23885_d
>  		cx_set(GP0_IO, 0x000f000f);
>  		break;
>  	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +		cx23885_xc2028_leadtek_callback(dev, XC2028_TUNER_RESET, 0);
> +		break;
>  	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
> +		cx23885_xc4000_leadtek_callback(dev, XC4000_TUNER_RESET, 0);
> +		break;
>  	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>  	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>  	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
> @@ -1312,6 +1440,30 @@ void cx23885_ir_pci_int_enable(struct cx
>  	}
>  }
>  
> +void cx23885_setup_xc3028(struct cx23885_dev *dev, struct xc2028_ctrl *ctl)
> +{
> +	memset(ctl, 0, sizeof(*ctl));
> +
> +	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
> +	ctl->max_len = 64;
> +
> +	switch (dev->board) {
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
> +		break;
> +	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
> +	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
> +	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
> +		ctl->demod = XC3028_FE_ZARLINK456;
> +		break;
> +	default:
> +		ctl->demod = XC3028_FE_OREN538;
> +		ctl->mts = 1;
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(cx23885_setup_xc3028);
> +
>  void cx23885_card_setup(struct cx23885_dev *dev)
>  {
>  	struct cx23885_tsport *ts1 = &dev->ts1;
> diff -Naurp a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> --- a/drivers/media/video/cx23885/cx23885.h	2012-01-05 00:55:44.000000000 +0100
> +++ b/drivers/media/video/cx23885/cx23885.h	2012-01-14 18:48:44.172366746 +0100
> @@ -35,6 +35,7 @@
>  #include "btcx-risc.h"
>  #include "cx23885-reg.h"
>  #include "media/cx2341x.h"
> +#include "tuner-xc2028.h"
>  
>  #include <linux/mutex.h>
>  
> @@ -225,6 +226,7 @@ struct cx23885_board {
>  	 */
>  	u32			clk_freq;
>  	struct cx23885_input    input[MAX_CX23885_INPUT];
> +	struct cx23885_input    radio;
>  	int			ci_type; /* for NetUP */
>  };
>  
> @@ -416,6 +418,9 @@ struct cx23885_dev {
>  
>  	/* V4l */
>  	u32                        freq;
> +	int                        users;
> +	int                        mpeg_users;
> +
>  	struct video_device        *video_dev;
>  	struct video_device        *vbi_dev;
>  	struct video_device        *radio_dev;
> @@ -554,6 +559,8 @@ extern void cx23885_gpio_setup(struct cx
>  extern void cx23885_card_setup(struct cx23885_dev *dev);
>  extern void cx23885_card_setup_pre_i2c(struct cx23885_dev *dev);
>  
> +extern void cx23885_setup_xc3028(struct cx23885_dev *dev, struct xc2028_ctrl *ctl);
> +
>  extern int cx23885_dvb_register(struct cx23885_tsport *port);
>  extern int cx23885_dvb_unregister(struct cx23885_tsport *port);
>  
> diff -Naurp a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> --- a/drivers/media/video/cx23885/cx23885-video.c	2012-01-05 00:55:44.000000000 +0100
> +++ b/drivers/media/video/cx23885/cx23885-video.c	2012-01-14 19:11:43.148366748 +0100
> @@ -36,6 +36,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include "cx23885-ioctl.h"
>  #include "tuner-xc2028.h"
> +#include "xc4000.h"
>  
>  #include <media/cx25840.h>
>  
> @@ -502,18 +503,6 @@ static int cx23885_video_mux(struct cx23
>  	v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
>  			INPUT(input)->vmux, 0, 0);
>  
> -	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
> -		(dev->board == CX23885_BOARD_MPX885)) {
> -		/* Configure audio routing */
> -		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
> -			INPUT(input)->amux, 0, 0);
> -
> -		if (INPUT(input)->amux == CX25840_AUDIO7)
> -			cx23885_flatiron_mux(dev, 1);
> -		else if (INPUT(input)->amux == CX25840_AUDIO6)
> -			cx23885_flatiron_mux(dev, 2);
> -	}
> -

Hmm... why are you removing these? Won't it break support for this board?

>  	return 0;
>  }
>  
> @@ -521,6 +510,10 @@ static int cx23885_audio_mux(struct cx23
>  {
>  	dprintk(1, "%s(input=%d)\n", __func__, input);
>  
> +	/* Configure audio routing */
> +	v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
> +		INPUT(input)->amux, 0, 0);
> +
>  	/* The baseband video core of the cx23885 has two audio inputs.
>  	 * LR1 and LR2. In almost every single case so far only HVR1xxx
>  	 * cards we've only ever supported LR1. Time to support LR2,
> @@ -871,20 +864,29 @@ static int video_open(struct file *file)
>  	fh->height   = 240;
>  	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_YUYV);
>  
> +	mutex_lock(&dev->lock);
> +
>  	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
>  			    &dev->pci->dev, &dev->slock,
>  			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
>  			    V4L2_FIELD_INTERLACED,
>  			    sizeof(struct cx23885_buffer),
>  			    fh, NULL);
> -
>  	videobuf_queue_sg_init(&fh->vbiq, &cx23885_vbi_qops,
> -		&dev->pci->dev, &dev->slock,
> -		V4L2_BUF_TYPE_VBI_CAPTURE,
> -		V4L2_FIELD_SEQ_TB,
> -		sizeof(struct cx23885_buffer),
> -		fh, NULL);
> +			    &dev->pci->dev, &dev->slock,
> +			    V4L2_BUF_TYPE_VBI_CAPTURE,
> +			    V4L2_FIELD_SEQ_TB,
> +			    sizeof(struct cx23885_buffer),
> +			    fh, NULL);
>  
> +	if (fh->radio) {
> +		dprintk(1,"video_open: setting radio device\n");
> +		cx_write(GPIO_0, cx23885_boards[dev->board].radio.gpio0);
> +		call_all(dev, tuner, s_radio);
> +	}
> +
> +	dev->users++;
> +	mutex_unlock(&dev->lock);
>  
>  	dprintk(1, "post videobuf_queue_init()\n");
>  
> @@ -981,13 +983,24 @@ static int video_release(struct file *fi
>  	}
>  
>  	videobuf_mmap_free(&fh->vidq);
> +	videobuf_mmap_free(&fh->vbiq);
> +
> +	mutex_lock(&dev->lock);
>  	file->private_data = NULL;
>  	kfree(fh);
>  
> +	dev->users--;
> +
>  	/* We are not putting the tuner to sleep here on exit, because
>  	 * we want to use the mpeg encoder in another session to capture
>  	 * tuner video. Closing this will result in no video to the encoder.
>  	 */
> +#if 0
> +	if (!dev->users)
> +		call_all(dev, core, s_power, 0);
> +#endif
> +
> +	mutex_unlock(&dev->lock);
>  
>  	return 0;
>  }
> @@ -1255,17 +1268,13 @@ static int cx23885_enum_input(struct cx2
>  		[CX23885_VMUX_DVB]        = "DVB",
>  		[CX23885_VMUX_DEBUG]      = "for debug only",
>  	};
> -	unsigned int n;
> +	unsigned int n = i->index;
>  	dprintk(1, "%s()\n", __func__);
>  
> -	n = i->index;
>  	if (n >= MAX_CX23885_INPUT)
>  		return -EINVAL;
> -
>  	if (0 == INPUT(n)->type)
>  		return -EINVAL;
> -
> -	i->index = n;
>  	i->type  = V4L2_INPUT_TYPE_CAMERA;
>  	strcpy(i->name, iname[INPUT(n)->type]);
>  	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
> @@ -1505,6 +1514,108 @@ static int vidioc_s_frequency(struct fil
>  }
>  
>  /* ----------------------------------------------------------- */
> +/* RADIO ESPECIFIC IOCTLS                                      */
> +/* ----------------------------------------------------------- */
> +
> +static int radio_querycap (struct file *file, void  *priv,
> +					struct v4l2_capability *cap)
> +{
> +	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> +	strcpy(cap->driver, "cx23885");
> +	strlcpy(cap->card, cx23885_boards[dev->board].name, sizeof(cap->card));
> +	sprintf(cap->bus_info,"PCIe:%s", pci_name(dev->pci));
> +	cap->capabilities = V4L2_CAP_TUNER;
> +	return 0;
> +}
> +
> +static int radio_g_tuner (struct file *file, void *priv,
> +				struct v4l2_tuner *t)
> +{
> +	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> +	if (unlikely(t->index > 0))
> +		return -EINVAL;
> +
> +	strcpy(t->name, "Radio");
> +	t->type = V4L2_TUNER_RADIO;
> +
> +	call_all(dev, tuner, g_tuner, t);
> +	return 0;
> +}
> +
> +static int radio_enum_input (struct file *file, void *priv,
> +				struct v4l2_input *i)
> +{
> +	if (i->index != 0)
> +		return -EINVAL;
> +	strcpy(i->name,"Radio");
> +	i->type = V4L2_INPUT_TYPE_TUNER;
> +
> +	return 0;
> +}
> +
> +static int radio_g_audio (struct file *file, void *priv, struct v4l2_audio *a)
> +{
> +	if (unlikely(a->index))
> +		return -EINVAL;
> +
> +	strcpy(a->name,"Radio");
> +	return 0;
> +}
> +
> +/* FIXME: Should add a standard for radio */
> +
> +static int radio_s_tuner (struct file *file, void *priv,
> +				struct v4l2_tuner *t)
> +{
> +	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> +	if (0 != t->index)
> +		return -EINVAL;
> +
> +	call_all(dev, tuner, s_tuner, t);
> +
> +	return 0;
> +}
> +
> +static int radio_s_audio (struct file *file, void *fh,
> +			  struct v4l2_audio *a)
> +{
> +	return 0;
> +}
> +
> +static int radio_s_input (struct file *file, void *fh, unsigned int i)
> +{
> +	return 0;
> +}
> +
> +static int radio_queryctrl (struct file *file, void *priv,
> +			    struct v4l2_queryctrl *c)
> +{
> +	int i;
> +
> +	if (c->id < V4L2_CID_BASE ||
> +		c->id >= V4L2_CID_LASTP1)
> +		return -EINVAL;
> +	if (c->id == V4L2_CID_AUDIO_MUTE ||
> +		c->id == V4L2_CID_AUDIO_VOLUME ||
> +		c->id == V4L2_CID_AUDIO_BALANCE) {
> +		for (i = 0; i < CX23885_CTLS; i++) {
> +			if (cx23885_ctls[i].v.id == c->id)
> +				break;
> +		}
> +		if (i == CX23885_CTLS) {
> +			*c = no_ctl;
> +			return 0;
> +		}
> +		*c = cx23885_ctls[i].v;
> +	} else
> +		*c = no_ctl;
> +	return 0;
> +}
> +
> +/* ----------------------------------------------------------- */
>  
>  static void cx23885_vid_timeout(unsigned long data)
>  {
> @@ -1652,12 +1763,43 @@ static const struct v4l2_file_operations
>  	.ioctl         = video_ioctl2,
>  };
>  
> +static const struct v4l2_ioctl_ops radio_ioctl_ops = {
> +	.vidioc_querycap      = radio_querycap,
> +	.vidioc_g_tuner       = radio_g_tuner,
> +	.vidioc_enum_input    = radio_enum_input,
> +	.vidioc_g_audio       = radio_g_audio,
> +	.vidioc_s_tuner       = radio_s_tuner,
> +	.vidioc_s_audio       = radio_s_audio,
> +	.vidioc_s_input       = radio_s_input,
> +	.vidioc_queryctrl     = radio_queryctrl,
> +	.vidioc_g_ctrl        = vidioc_g_ctrl,
> +	.vidioc_s_ctrl        = vidioc_s_ctrl,
> +	.vidioc_g_frequency   = vidioc_g_frequency,
> +	.vidioc_s_frequency   = vidioc_s_frequency,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.vidioc_g_register    = cx23885_g_register,
> +	.vidioc_s_register    = cx23885_s_register,
> +#endif
> +};
> +
> +static struct video_device cx23885_radio_template = {
> +	.name                 = "cx23885-radio",
> +	.fops                 = &radio_fops,
> +	.ioctl_ops            = &radio_ioctl_ops,
> +};
>  
>  void cx23885_video_unregister(struct cx23885_dev *dev)
>  {
>  	dprintk(1, "%s()\n", __func__);
>  	cx23885_irq_remove(dev, 0x01);
>  
> +	if (dev->radio_dev) {
> +		if (video_is_registered(dev->radio_dev))
> +			video_unregister_device(dev->radio_dev);
> +		else
> +			video_device_release(dev->radio_dev);
> +		dev->radio_dev = NULL;
> +	}
>  	if (dev->vbi_dev) {
>  		if (video_is_registered(dev->vbi_dev))
>  			video_unregister_device(dev->vbi_dev);
> @@ -1730,22 +1872,28 @@ int cx23885_video_register(struct cx2388
>  			struct tuner_setup tun_setup;
>  
>  			memset(&tun_setup, 0, sizeof(tun_setup));
> -			tun_setup.mode_mask = T_ANALOG_TV;
> +
> +			tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
>  			tun_setup.type = dev->tuner_type;
>  			tun_setup.addr = v4l2_i2c_subdev_addr(sd);
> +
>  			tun_setup.tuner_callback = cx23885_tuner_callback;
>  
>  			v4l2_subdev_call(sd, tuner, s_type_addr, &tun_setup);
>  
> -			if (dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXTV1200) {
> -				struct xc2028_ctrl ctrl = {
> -					.fname = XC2028_DEFAULT_FIRMWARE,
> -					.max_len = 64
> -				};
> -				struct v4l2_priv_tun_config cfg = {
> -					.tuner = dev->tuner_type,
> -					.priv = &ctrl
> -				};
> +			if (dev->tuner_type == TUNER_XC2028) {
> +				struct v4l2_priv_tun_config  cfg;
> +				struct xc2028_ctrl           ctl;
> +
> +				/* Fills device-dependent initialization parameters */
> +				cx23885_setup_xc3028(dev, &ctl);
> +
> +				memset(&cfg, 0, sizeof(cfg));
> +				cfg.tuner = TUNER_XC2028;
> +				cfg.priv  = &ctl;
> +
> +				printk(KERN_INFO "%s: Asking xc2028/3028 to load firmware %s\n",
> +				       dev->name, ctl.fname);
>  				v4l2_subdev_call(sd, tuner, s_config, &cfg);
>  			}
>  		}
> @@ -1777,6 +1925,21 @@ int cx23885_video_register(struct cx2388
>  	printk(KERN_INFO "%s: registered device %s\n",
>  	       dev->name, video_device_node_name(dev->vbi_dev));
>  
> +	if (cx23885_boards[dev->board].radio.type == CX23885_RADIO) {
> +		dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
> +						&cx23885_radio_template, "radio");
> +		video_set_drvdata(dev->radio_dev, dev);
> +		err = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
> +					    radio_nr[dev->nr]);
> +		if (err < 0) {
> +			printk(KERN_ERR "%s: can't register radio device\n",
> +			       dev->name);
> +			goto fail_unreg;
> +		}
> +		printk(KERN_INFO "%s: registered device %s\n",
> +		       dev->name, video_device_node_name(dev->radio_dev));
> +	}
> +
>  	/* Register ALSA audio device */
>  	dev->audio_dev = cx23885_audio_register(dev);
>  
> 

