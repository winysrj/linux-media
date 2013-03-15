Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3COOAB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 10:00:01 -0400
Date: Fri, 15 Mar 2013 10:58:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only
 s_std ioctl.
Message-ID: <20130315105835.0954d389@redhat.com>
In-Reply-To: <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
	<968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 Mar 2013 11:27:23 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument by value instead of by
> reference. I could have chosen to add const instead, but this is 1) easier
> to handle in drivers and 2) consistent with the s_std subdev operation.

Hmm... this could potentially break userspace. I remember I saw in the past
some code that used the returned standard. I can't remember where. It could
be inside the V4L1 compat layer, but I think it was on some userspace app(s).

Had you verify how the several different userspace apps handle S_STD?

Regards,
Mauro

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/common/saa7146/saa7146_video.c    |    4 ++--
>  drivers/media/parport/pms.c                     |    4 ++--
>  drivers/media/pci/bt8xx/bttv-driver.c           |    6 +++---
>  drivers/media/pci/cx18/cx18-driver.c            |    2 +-
>  drivers/media/pci/cx18/cx18-ioctl.c             |   10 +++++-----
>  drivers/media/pci/cx18/cx18-ioctl.h             |    2 +-
>  drivers/media/pci/cx23885/cx23885-417.c         |    6 +++---
>  drivers/media/pci/cx23885/cx23885-video.c       |    4 ++--
>  drivers/media/pci/cx25821/cx25821-video.c       |    6 +++---
>  drivers/media/pci/cx25821/cx25821-video.h       |    2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c         |    4 ++--
>  drivers/media/pci/cx88/cx88-video.c             |    4 ++--
>  drivers/media/pci/ivtv/ivtv-driver.c            |    4 ++--
>  drivers/media/pci/ivtv/ivtv-firmware.c          |    4 ++--
>  drivers/media/pci/ivtv/ivtv-ioctl.c             |   18 +++++++++---------
>  drivers/media/pci/ivtv/ivtv-ioctl.h             |    4 ++--
>  drivers/media/pci/saa7134/saa7134-empress.c     |    2 +-
>  drivers/media/pci/saa7134/saa7134-video.c       |   14 +++++++-------
>  drivers/media/pci/saa7134/saa7134.h             |    2 +-
>  drivers/media/pci/saa7164/saa7164-encoder.c     |    8 ++++----
>  drivers/media/pci/saa7164/saa7164-vbi.c         |    8 ++++----
>  drivers/media/pci/sta2x11/sta2x11_vip.c         |   18 +++++++++---------
>  drivers/media/pci/zoran/zoran_driver.c          |    4 ++--
>  drivers/media/platform/blackfin/bfin_capture.c  |    6 +++---
>  drivers/media/platform/davinci/vpbe.c           |    8 ++++----
>  drivers/media/platform/davinci/vpbe_display.c   |    2 +-
>  drivers/media/platform/davinci/vpfe_capture.c   |   12 ++++++------
>  drivers/media/platform/davinci/vpif_capture.c   |    6 +++---
>  drivers/media/platform/davinci/vpif_display.c   |   10 +++++-----
>  drivers/media/platform/fsl-viu.c                |    6 +++---
>  drivers/media/platform/marvell-ccic/mcam-core.c |    2 +-
>  drivers/media/platform/s5p-tv/mixer_video.c     |    4 ++--
>  drivers/media/platform/sh_vou.c                 |   12 ++++++------
>  drivers/media/platform/soc_camera/soc_camera.c  |    4 ++--
>  drivers/media/platform/timblogiw.c              |    6 +++---
>  drivers/media/platform/via-camera.c             |    2 +-
>  drivers/media/platform/vino.c                   |   10 +++++-----
>  drivers/media/usb/au0828/au0828-video.c         |    4 ++--
>  drivers/media/usb/cx231xx/cx231xx-417.c         |    4 ++--
>  drivers/media/usb/cx231xx/cx231xx-video.c       |    6 +++---
>  drivers/media/usb/em28xx/em28xx-video.c         |    8 ++++----
>  drivers/media/usb/hdpvr/hdpvr-video.c           |    4 ++--
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c        |    4 ++--
>  drivers/media/usb/s2255/s2255drv.c              |    8 ++++----
>  drivers/media/usb/stk1160/stk1160-v4l.c         |    4 ++--
>  drivers/media/usb/tlg2300/pd-video.c            |    8 ++++----
>  drivers/media/usb/tm6000/tm6000-video.c         |    6 +++---
>  drivers/media/usb/usbvision/usbvision-video.c   |    4 ++--
>  drivers/media/v4l2-core/v4l2-ioctl.c            |    6 +++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    6 +++---
>  drivers/staging/media/dt3155v4l/dt3155v4l.c     |    4 ++--
>  drivers/staging/media/go7007/go7007-v4l2.c      |   16 ++++++++--------
>  drivers/staging/media/solo6x10/v4l2-enc.c       |    2 +-
>  drivers/staging/media/solo6x10/v4l2.c           |    2 +-
>  include/media/davinci/vpbe.h                    |    2 +-
>  include/media/v4l2-ioctl.h                      |    2 +-
>  56 files changed, 165 insertions(+), 165 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
> index 4143d61..fe907f2 100644
> --- a/drivers/media/common/saa7146/saa7146_video.c
> +++ b/drivers/media/common/saa7146/saa7146_video.c
> @@ -832,7 +832,7 @@ static int vidioc_g_std(struct file *file, void *fh, v4l2_std_id *norm)
>  	}
>  	*/
>  
> -static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id id)
>  {
>  	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
>  	struct saa7146_vv *vv = dev->vv_data;
> @@ -856,7 +856,7 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *id)
>  	}
>  
>  	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
> -		if (*id & dev->ext_vv_data->stds[i].id)
> +		if (id & dev->ext_vv_data->stds[i].id)
>  			break;
>  	if (i != dev->ext_vv_data->num_stds) {
>  		vv->standard = &dev->ext_vv_data->stds[i];
> diff --git a/drivers/media/parport/pms.c b/drivers/media/parport/pms.c
> index 77f9c92..66c957a 100644
> --- a/drivers/media/parport/pms.c
> +++ b/drivers/media/parport/pms.c
> @@ -735,12 +735,12 @@ static int pms_g_std(struct file *file, void *fh, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -static int pms_s_std(struct file *file, void *fh, v4l2_std_id *std)
> +static int pms_s_std(struct file *file, void *fh, v4l2_std_id std)
>  {
>  	struct pms *dev = video_drvdata(file);
>  	int ret = 0;
>  
> -	dev->std = *std;
> +	dev->std = std;
>  	if (dev->std & V4L2_STD_NTSC) {
>  		pms_framerate(dev, 30);
>  		pms_secamcross(dev, 0);
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 20db7aa..79dc12c 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -1711,7 +1711,7 @@ static void radio_enable(struct bttv *btv)
>  	}
>  }
>  
> -static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int bttv_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct bttv_fh *fh  = priv;
>  	struct bttv *btv = fh->btv;
> @@ -1719,14 +1719,14 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
>  	int err = 0;
>  
>  	for (i = 0; i < BTTV_TVNORMS; i++)
> -		if (*id & bttv_tvnorms[i].v4l2_id)
> +		if (id & bttv_tvnorms[i].v4l2_id)
>  			break;
>  	if (i == BTTV_TVNORMS) {
>  		err = -EINVAL;
>  		goto err;
>  	}
>  
> -	btv->std = *id;
> +	btv->std = id;
>  	set_tvnorm(btv, i);
>  
>  err:
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 613e5ae..67b61cf 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -1243,7 +1243,7 @@ int cx18_init_on_first_open(struct cx18 *cx)
>  	   in one place. */
>  	cx->std++;		/* Force full standard initialization */
>  	std = (cx->tuner_std == V4L2_STD_ALL) ? V4L2_STD_NTSC_M : cx->tuner_std;
> -	cx18_s_std(NULL, &fh, &std);
> +	cx18_s_std(NULL, &fh, std);
>  	cx18_s_frequency(NULL, &fh, &vf);
>  	return 0;
>  }
> diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
> index 173ccd2..254c50f 100644
> --- a/drivers/media/pci/cx18/cx18-ioctl.c
> +++ b/drivers/media/pci/cx18/cx18-ioctl.c
> @@ -637,15 +637,15 @@ static int cx18_g_std(struct file *file, void *fh, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std)
> +int cx18_s_std(struct file *file, void *fh, v4l2_std_id std)
>  {
>  	struct cx18_open_id *id = fh2id(fh);
>  	struct cx18 *cx = id->cx;
>  
> -	if ((*std & V4L2_STD_ALL) == 0)
> +	if ((std & V4L2_STD_ALL) == 0)
>  		return -EINVAL;
>  
> -	if (*std == cx->std)
> +	if (std == cx->std)
>  		return 0;
>  
>  	if (test_bit(CX18_F_I_RADIO_USER, &cx->i_flags) ||
> @@ -656,8 +656,8 @@ int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std)
>  		return -EBUSY;
>  	}
>  
> -	cx->std = *std;
> -	cx->is_60hz = (*std & V4L2_STD_525_60) ? 1 : 0;
> +	cx->std = std;
> +	cx->is_60hz = (std & V4L2_STD_525_60) ? 1 : 0;
>  	cx->is_50hz = !cx->is_60hz;
>  	cx2341x_handler_set_50hz(&cx->cxhdl, cx->is_50hz);
>  	cx->cxhdl.width = 720;
> diff --git a/drivers/media/pci/cx18/cx18-ioctl.h b/drivers/media/pci/cx18/cx18-ioctl.h
> index aa9b44a..4343396 100644
> --- a/drivers/media/pci/cx18/cx18-ioctl.h
> +++ b/drivers/media/pci/cx18/cx18-ioctl.h
> @@ -26,6 +26,6 @@ u16 cx18_service2vbi(int type);
>  void cx18_expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
>  u16 cx18_get_service_set(struct v4l2_sliced_vbi_format *fmt);
>  void cx18_set_funcs(struct video_device *vdev);
> -int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std);
> +int cx18_s_std(struct file *file, void *fh, v4l2_std_id std);
>  int cx18_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf);
>  int cx18_s_input(struct file *file, void *fh, unsigned int inp);
> diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
> index 812ec5f..6dea11a 100644
> --- a/drivers/media/pci/cx23885/cx23885-417.c
> +++ b/drivers/media/pci/cx23885/cx23885-417.c
> @@ -1222,14 +1222,14 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct cx23885_fh  *fh  = file->private_data;
>  	struct cx23885_dev *dev = fh->dev;
>  	unsigned int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(cx23885_tvnorms); i++)
> -		if (*id & cx23885_tvnorms[i].id)
> +		if (id & cx23885_tvnorms[i].id)
>  			break;
>  	if (i == ARRAY_SIZE(cx23885_tvnorms))
>  		return -EINVAL;
> @@ -1237,7 +1237,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
>  
>  	/* Have the drier core notify the subdevices */
>  	mutex_lock(&dev->lock);
> -	cx23885_set_tvnorm(dev, *id);
> +	cx23885_set_tvnorm(dev, id);
>  	mutex_unlock(&dev->lock);
>  
>  	return 0;
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index 2bbda43..ed08c89 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -1259,13 +1259,13 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
>  {
>  	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
>  	dprintk(1, "%s()\n", __func__);
>  
>  	mutex_lock(&dev->lock);
> -	cx23885_set_tvnorm(dev, *tvnorms);
> +	cx23885_set_tvnorm(dev, tvnorms);
>  	mutex_unlock(&dev->lock);
>  
>  	return 0;
> diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
> index 75281c1..93c7d57 100644
> --- a/drivers/media/pci/cx25821/cx25821-video.c
> +++ b/drivers/media/pci/cx25821/cx25821-video.c
> @@ -1203,7 +1203,7 @@ int cx25821_vidioc_s_priority(struct file *file, void *f,
>  }
>  
>  #ifdef TUNER_FLAG
> -int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms)
> +int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
>  {
>  	struct cx25821_fh *fh = priv;
>  	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
> @@ -1218,11 +1218,11 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms)
>  			return err;
>  	}
>  
> -	if (dev->tvnorm == *tvnorms)
> +	if (dev->tvnorm == tvnorms)
>  		return 0;
>  
>  	mutex_lock(&dev->lock);
> -	cx25821_set_tvnorm(dev, *tvnorms);
> +	cx25821_set_tvnorm(dev, tvnorms);
>  	mutex_unlock(&dev->lock);
>  
>  	medusa_set_videostandard(dev);
> diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
> index f0e70ff..239f63c 100644
> --- a/drivers/media/pci/cx25821/cx25821-video.h
> +++ b/drivers/media/pci/cx25821/cx25821-video.h
> @@ -135,7 +135,7 @@ extern int cx25821_vidioc_querybuf(struct file *file, void *priv,
>  extern int cx25821_vidioc_qbuf(struct file *file, void *priv,
>  			       struct v4l2_buffer *p);
>  extern int cx25821_vidioc_s_std(struct file *file, void *priv,
> -				v4l2_std_id *tvnorms);
> +				v4l2_std_id tvnorms);
>  extern int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i);
>  extern int cx25821_vidioc_enum_input(struct file *file, void *priv,
>  				     struct v4l2_input *i);
> diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
> index 486ca8d..150bb76 100644
> --- a/drivers/media/pci/cx88/cx88-blackbird.c
> +++ b/drivers/media/pci/cx88/cx88-blackbird.c
> @@ -939,12 +939,12 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
>  	return 0;
>  }
>  
> -static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
>  
>  	mutex_lock(&core->lock);
> -	cx88_set_tvnorm(core,*id);
> +	cx88_set_tvnorm(core, id);
>  	mutex_unlock(&core->lock);
>  	return 0;
>  }
> diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> index ede6f13..ead5be5 100644
> --- a/drivers/media/pci/cx88/cx88-video.c
> +++ b/drivers/media/pci/cx88/cx88-video.c
> @@ -1193,12 +1193,12 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
>  	return 0;
>  }
>  
> -static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *tvnorms)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
>  {
>  	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
>  
>  	mutex_lock(&core->lock);
> -	cx88_set_tvnorm(core,*tvnorms);
> +	cx88_set_tvnorm(core, tvnorms);
>  	mutex_unlock(&core->lock);
>  
>  	return 0;
> diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
> index 2928e72..07b8460 100644
> --- a/drivers/media/pci/ivtv/ivtv-driver.c
> +++ b/drivers/media/pci/ivtv/ivtv-driver.c
> @@ -1387,7 +1387,7 @@ int ivtv_init_on_first_open(struct ivtv *itv)
>  	if (!itv->has_cx23415)
>  		write_reg_sync(0x03, IVTV_REG_DMACONTROL);
>  
> -	ivtv_s_std_enc(itv, &itv->tuner_std);
> +	ivtv_s_std_enc(itv, itv->tuner_std);
>  
>  	/* Default interrupts enabled. For the PVR350 this includes the
>  	   decoder VSYNC interrupt, which is always on. It is not only used
> @@ -1397,7 +1397,7 @@ int ivtv_init_on_first_open(struct ivtv *itv)
>  	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>  		ivtv_clear_irq_mask(itv, IVTV_IRQ_MASK_INIT | IVTV_IRQ_DEC_VSYNC);
>  		ivtv_set_osd_alpha(itv);
> -		ivtv_s_std_dec(itv, &itv->tuner_std);
> +		ivtv_s_std_dec(itv, itv->tuner_std);
>  	} else {
>  		ivtv_clear_irq_mask(itv, IVTV_IRQ_MASK_INIT);
>  	}
> diff --git a/drivers/media/pci/ivtv/ivtv-firmware.c b/drivers/media/pci/ivtv/ivtv-firmware.c
> index 68387d4..ed73edd 100644
> --- a/drivers/media/pci/ivtv/ivtv-firmware.c
> +++ b/drivers/media/pci/ivtv/ivtv-firmware.c
> @@ -302,7 +302,7 @@ static int ivtv_firmware_restart(struct ivtv *itv)
>  	/* Restore encoder video standard */
>  	std = itv->std;
>  	itv->std = 0;
> -	ivtv_s_std_enc(itv, &std);
> +	ivtv_s_std_enc(itv, std);
>  
>  	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>  		ivtv_init_mpeg_decoder(itv);
> @@ -310,7 +310,7 @@ static int ivtv_firmware_restart(struct ivtv *itv)
>  		/* Restore decoder video standard */
>  		std = itv->std_out;
>  		itv->std_out = 0;
> -		ivtv_s_std_dec(itv, &std);
> +		ivtv_s_std_dec(itv, std);
>  
>  		/* Restore framebuffer if active */
>  		if (itv->ivtvfb_restore)
> diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
> index 852f11e..080f179 100644
> --- a/drivers/media/pci/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
> @@ -1103,10 +1103,10 @@ static int ivtv_g_std(struct file *file, void *fh, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id *std)
> +void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id std)
>  {
> -	itv->std = *std;
> -	itv->is_60hz = (*std & V4L2_STD_525_60) ? 1 : 0;
> +	itv->std = std;
> +	itv->is_60hz = (std & V4L2_STD_525_60) ? 1 : 0;
>  	itv->is_50hz = !itv->is_60hz;
>  	cx2341x_handler_set_50hz(&itv->cxhdl, itv->is_50hz);
>  	itv->cxhdl.width = 720;
> @@ -1122,15 +1122,15 @@ void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id *std)
>  	ivtv_call_all(itv, core, s_std, itv->std);
>  }
>  
> -void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std)
> +void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id std)
>  {
>  	struct yuv_playback_info *yi = &itv->yuv_info;
>  	DEFINE_WAIT(wait);
>  	int f;
>  
>  	/* set display standard */
> -	itv->std_out = *std;
> -	itv->is_out_60hz = (*std & V4L2_STD_525_60) ? 1 : 0;
> +	itv->std_out = std;
> +	itv->is_out_60hz = (std & V4L2_STD_525_60) ? 1 : 0;
>  	itv->is_out_50hz = !itv->is_out_60hz;
>  	ivtv_call_all(itv, video, s_std_output, itv->std_out);
>  
> @@ -1168,14 +1168,14 @@ void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std)
>  	}
>  }
>  
> -static int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
> +static int ivtv_s_std(struct file *file, void *fh, v4l2_std_id std)
>  {
>  	struct ivtv *itv = fh2id(fh)->itv;
>  
> -	if ((*std & V4L2_STD_ALL) == 0)
> +	if ((std & V4L2_STD_ALL) == 0)
>  		return -EINVAL;
>  
> -	if (*std == itv->std)
> +	if (std == itv->std)
>  		return 0;
>  
>  	if (test_bit(IVTV_F_I_RADIO_USER, &itv->i_flags) ||
> diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.h b/drivers/media/pci/ivtv/ivtv-ioctl.h
> index 34c6bc1..75c3977 100644
> --- a/drivers/media/pci/ivtv/ivtv-ioctl.h
> +++ b/drivers/media/pci/ivtv/ivtv-ioctl.h
> @@ -27,8 +27,8 @@ u16 ivtv_get_service_set(struct v4l2_sliced_vbi_format *fmt);
>  void ivtv_set_osd_alpha(struct ivtv *itv);
>  int ivtv_set_speed(struct ivtv *itv, int speed);
>  void ivtv_set_funcs(struct video_device *vdev);
> -void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id *std);
> -void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std);
> +void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id std);
> +void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id std);
>  int ivtv_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf);
>  int ivtv_s_input(struct file *file, void *fh, unsigned int inp);
>  
> diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
> index 4df79c6..66a7081 100644
> --- a/drivers/media/pci/saa7134/saa7134-empress.c
> +++ b/drivers/media/pci/saa7134/saa7134-empress.c
> @@ -428,7 +428,7 @@ static int empress_g_chip_ident(struct file *file, void *fh,
>  	return -EINVAL;
>  }
>  
> -static int empress_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int empress_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct saa7134_dev *dev = file->private_data;
>  
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 1e23547..a6c69a4 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1828,7 +1828,7 @@ static int saa7134_querycap(struct file *file, void  *priv,
>  	return 0;
>  }
>  
> -int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_std_id *id)
> +int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_std_id id)
>  {
>  	unsigned long flags;
>  	unsigned int i;
> @@ -1849,17 +1849,17 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
>  	}
>  
>  	for (i = 0; i < TVNORMS; i++)
> -		if (*id == tvnorms[i].id)
> +		if (id == tvnorms[i].id)
>  			break;
>  
>  	if (i == TVNORMS)
>  		for (i = 0; i < TVNORMS; i++)
> -			if (*id & tvnorms[i].id)
> +			if (id & tvnorms[i].id)
>  				break;
>  	if (i == TVNORMS)
>  		return -EINVAL;
>  
> -	if ((*id & V4L2_STD_SECAM) && (secam[0] != '-')) {
> +	if ((id & V4L2_STD_SECAM) && (secam[0] != '-')) {
>  		if (secam[0] == 'L' || secam[0] == 'l') {
>  			if (secam[1] == 'C' || secam[1] == 'c')
>  				fixup = V4L2_STD_SECAM_LC;
> @@ -1879,7 +1879,7 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
>  			return -EINVAL;
>  	}
>  
> -	*id = tvnorms[i].id;
> +	id = tvnorms[i].id;
>  
>  	mutex_lock(&dev->lock);
>  	if (fh && res_check(fh, RESOURCE_OVERLAY)) {
> @@ -1901,7 +1901,7 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
>  }
>  EXPORT_SYMBOL_GPL(saa7134_s_std_internal);
>  
> -static int saa7134_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct saa7134_fh *fh = priv;
>  
> @@ -2396,7 +2396,7 @@ static int radio_s_input(struct file *filp, void *priv, unsigned int i)
>  	return 0;
>  }
>  
> -static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> +static int radio_s_std(struct file *file, void *fh, v4l2_std_id norm)
>  {
>  	return 0;
>  }
> diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
> index 71eefef..62169dd 100644
> --- a/drivers/media/pci/saa7134/saa7134.h
> +++ b/drivers/media/pci/saa7134/saa7134.h
> @@ -766,7 +766,7 @@ extern struct video_device saa7134_radio_template;
>  int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
>  int saa7134_g_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
>  int saa7134_queryctrl(struct file *file, void *priv, struct v4l2_queryctrl *c);
> -int saa7134_s_std_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, v4l2_std_id *id);
> +int saa7134_s_std_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, v4l2_std_id id);
>  
>  int saa7134_videoport_init(struct saa7134_dev *dev);
>  void saa7134_set_tvnorm_hw(struct saa7134_dev *dev);
> diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
> index e7fbd03..538de52 100644
> --- a/drivers/media/pci/saa7164/saa7164-encoder.c
> +++ b/drivers/media/pci/saa7164/saa7164-encoder.c
> @@ -211,17 +211,17 @@ static int saa7164_encoder_initialize(struct saa7164_port *port)
>  }
>  
>  /* -- V4L2 --------------------------------------------------------- */
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct saa7164_encoder_fh *fh = file->private_data;
>  	struct saa7164_port *port = fh->port;
>  	struct saa7164_dev *dev = port->dev;
>  	unsigned int i;
>  
> -	dprintk(DBGLVL_ENC, "%s(id=0x%x)\n", __func__, (u32)*id);
> +	dprintk(DBGLVL_ENC, "%s(id=0x%x)\n", __func__, (u32)id);
>  
>  	for (i = 0; i < ARRAY_SIZE(saa7164_tvnorms); i++) {
> -		if (*id & saa7164_tvnorms[i].id)
> +		if (id & saa7164_tvnorms[i].id)
>  			break;
>  	}
>  	if (i == ARRAY_SIZE(saa7164_tvnorms))
> @@ -234,7 +234,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
>  	 */
>  	saa7164_api_set_audio_std(port);
>  
> -	dprintk(DBGLVL_ENC, "%s(id=0x%x) OK\n", __func__, (u32)*id);
> +	dprintk(DBGLVL_ENC, "%s(id=0x%x) OK\n", __func__, (u32)id);
>  
>  	return 0;
>  }
> diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
> index bfc8cec..da224eb 100644
> --- a/drivers/media/pci/saa7164/saa7164-vbi.c
> +++ b/drivers/media/pci/saa7164/saa7164-vbi.c
> @@ -183,17 +183,17 @@ static int saa7164_vbi_initialize(struct saa7164_port *port)
>  }
>  
>  /* -- V4L2 --------------------------------------------------------- */
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct saa7164_vbi_fh *fh = file->private_data;
>  	struct saa7164_port *port = fh->port;
>  	struct saa7164_dev *dev = port->dev;
>  	unsigned int i;
>  
> -	dprintk(DBGLVL_VBI, "%s(id=0x%x)\n", __func__, (u32)*id);
> +	dprintk(DBGLVL_VBI, "%s(id=0x%x)\n", __func__, (u32)id);
>  
>  	for (i = 0; i < ARRAY_SIZE(saa7164_tvnorms); i++) {
> -		if (*id & saa7164_tvnorms[i].id)
> +		if (id & saa7164_tvnorms[i].id)
>  			break;
>  	}
>  	if (i == ARRAY_SIZE(saa7164_tvnorms))
> @@ -206,7 +206,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
>  	 */
>  	saa7164_api_set_audio_std(port);
>  
> -	dprintk(DBGLVL_VBI, "%s(id=0x%x) OK\n", __func__, (u32)*id);
> +	dprintk(DBGLVL_VBI, "%s(id=0x%x) OK\n", __func__, (u32)id);
>  
>  	return 0;
>  }
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index 4b703fe..7005695 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -439,22 +439,22 @@ static int vidioc_querycap(struct file *file, void *priv,
>   *
>   * other, returned from video DAC.
>   */
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
>  {
>  	struct sta2x11_vip *vip = video_drvdata(file);
>  	v4l2_std_id oldstd = vip->std, newstd;
>  	int status;
>  
> -	if (V4L2_STD_ALL == *std) {
> -		v4l2_subdev_call(vip->decoder, core, s_std, *std);
> +	if (V4L2_STD_ALL == std) {
> +		v4l2_subdev_call(vip->decoder, core, s_std, std);
>  		ssleep(2);
>  		v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
>  		v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
>  		if (status & V4L2_IN_ST_NO_SIGNAL)
>  			return -EIO;
> -		*std = vip->std = newstd;
> -		if (oldstd != *std) {
> -			if (V4L2_STD_525_60 & (*std))
> +		std = vip->std = newstd;
> +		if (oldstd != std) {
> +			if (V4L2_STD_525_60 & std)
>  				vip->format = formats_60[0];
>  			else
>  				vip->format = formats_50[0];
> @@ -462,14 +462,14 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
>  		return 0;
>  	}
>  
> -	if (oldstd != *std) {
> -		if (V4L2_STD_525_60 & (*std))
> +	if (oldstd != std) {
> +		if (V4L2_STD_525_60 & std)
>  			vip->format = formats_60[0];
>  		else
>  			vip->format = formats_50[0];
>  	}
>  
> -	return v4l2_subdev_call(vip->decoder, core, s_std, *std);
> +	return v4l2_subdev_call(vip->decoder, core, s_std, std);
>  }
>  
>  /**
> diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
> index 2e8f518..1168a84 100644
> --- a/drivers/media/pci/zoran/zoran_driver.c
> +++ b/drivers/media/pci/zoran/zoran_driver.c
> @@ -2435,14 +2435,14 @@ static int zoran_g_std(struct file *file, void *__fh, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -static int zoran_s_std(struct file *file, void *__fh, v4l2_std_id *std)
> +static int zoran_s_std(struct file *file, void *__fh, v4l2_std_id std)
>  {
>  	struct zoran_fh *fh = __fh;
>  	struct zoran *zr = fh->zr;
>  	int res = 0;
>  
>  	mutex_lock(&zr->resource_lock);
> -	res = zoran_set_norm(zr, *std);
> +	res = zoran_set_norm(zr, std);
>  	if (res)
>  		goto sstd_unlock_and_return;
>  
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 8ffe42a..fcf39b2 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -633,7 +633,7 @@ static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -static int bcap_s_std(struct file *file, void *priv, v4l2_std_id *std)
> +static int bcap_s_std(struct file *file, void *priv, v4l2_std_id std)
>  {
>  	struct bcap_device *bcap_dev = video_drvdata(file);
>  	int ret;
> @@ -641,11 +641,11 @@ static int bcap_s_std(struct file *file, void *priv, v4l2_std_id *std)
>  	if (vb2_is_busy(&bcap_dev->buffer_queue))
>  		return -EBUSY;
>  
> -	ret = v4l2_subdev_call(bcap_dev->sd, core, s_std, *std);
> +	ret = v4l2_subdev_call(bcap_dev->sd, core, s_std, std);
>  	if (ret < 0)
>  		return ret;
>  
> -	bcap_dev->std = *std;
> +	bcap_dev->std = std;
>  	return 0;
>  }
>  
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 4ca0f9a..554f3a9 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -431,7 +431,7 @@ static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
>   * Sets the standard if supported by the current encoder. Return the status.
>   * 0 - success & -EINVAL on error
>   */
> -static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
> +static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id std_id)
>  {
>  	struct vpbe_config *cfg = vpbe_dev->cfg;
>  	int out_index = vpbe_dev->current_out_index;
> @@ -442,14 +442,14 @@ static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
>  		V4L2_OUT_CAP_STD))
>  		return -EINVAL;
>  
> -	ret = vpbe_get_std_info(vpbe_dev, *std_id);
> +	ret = vpbe_get_std_info(vpbe_dev, std_id);
>  	if (ret)
>  		return ret;
>  
>  	mutex_lock(&vpbe_dev->lock);
>  
>  	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
> -			       s_std_output, *std_id);
> +			       s_std_output, std_id);
>  	/* set the lcd controller output for the given mode */
>  	if (!ret) {
>  		struct osd_state *osd_device = vpbe_dev->osd_device;
> @@ -513,7 +513,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
>  			 */
>  			if (preset_mode->timings_type & VPBE_ENC_STD)
>  				return vpbe_s_std(vpbe_dev,
> -						 &preset_mode->std_id);
> +						 preset_mode->std_id);
>  			if (preset_mode->timings_type &
>  						VPBE_ENC_CUSTOM_TIMINGS) {
>  				dv_timings =
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 9f9f2c1..1311cdf 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -983,7 +983,7 @@ static int vpbe_display_try_fmt(struct file *file, void *priv,
>   * 0 - success & -EINVAL on error
>   */
>  static int vpbe_display_s_std(struct file *file, void *priv,
> -				v4l2_std_id *std_id)
> +				v4l2_std_id std_id)
>  {
>  	struct vpbe_fh *fh = priv;
>  	struct vpbe_layer *layer = fh->layer;
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 28d019d..d0bfb6a 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -376,7 +376,7 @@ static int vpfe_config_ccdc_image_format(struct vpfe_device *vpfe_dev)
>   * values in ccdc
>   */
>  static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
> -				    const v4l2_std_id *std_id)
> +				    v4l2_std_id std_id)
>  {
>  	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
>  	struct v4l2_mbus_framefmt mbus_fmt;
> @@ -384,7 +384,7 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
>  	int i, ret = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
> -		if (vpfe_standards[i].std_id & *std_id) {
> +		if (vpfe_standards[i].std_id & std_id) {
>  			vpfe_dev->std_info.active_pixels =
>  					vpfe_standards[i].width;
>  			vpfe_dev->std_info.active_lines =
> @@ -461,7 +461,7 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
>  
>  	/* Configure the default format information */
>  	ret = vpfe_config_image_format(vpfe_dev,
> -				&vpfe_standards[vpfe_dev->std_index].std_id);
> +				vpfe_standards[vpfe_dev->std_index].std_id);
>  	if (ret)
>  		return ret;
>  
> @@ -1164,7 +1164,7 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
>  
>  	/* set the default image parameters in the device */
>  	ret = vpfe_config_image_format(vpfe_dev,
> -				&vpfe_standards[vpfe_dev->std_index].std_id);
> +				vpfe_standards[vpfe_dev->std_index].std_id);
>  unlock_out:
>  	mutex_unlock(&vpfe_dev->lock);
>  	return ret;
> @@ -1189,7 +1189,7 @@ static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
>  	return ret;
>  }
>  
> -static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
>  	struct vpfe_device *vpfe_dev = video_drvdata(file);
>  	struct vpfe_subdev_info *sdinfo;
> @@ -1211,7 +1211,7 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	}
>  
>  	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -					 core, s_std, *std_id);
> +					 core, s_std, std_id);
>  	if (ret < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
>  		goto unlock_out;
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 1943e41..4e78839 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1395,7 +1395,7 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
>   * @priv: file handle
>   * @std_id: ptr to std id
>   */
> -static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
>  	struct vpif_fh *fh = priv;
>  	struct channel_obj *ch = fh->channel;
> @@ -1424,7 +1424,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	fh->initialized = 1;
>  
>  	/* Call encoder subdevice function to set the standard */
> -	ch->video.stdid = *std_id;
> +	ch->video.stdid = std_id;
>  	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
>  
>  	/* Get the information about the standard */
> @@ -1437,7 +1437,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	vpif_config_format(ch);
>  
>  	/* set standard in the sub device */
> -	ret = v4l2_subdev_call(ch->sd, core, s_std, *std_id);
> +	ret = v4l2_subdev_call(ch->sd, core, s_std, std_id);
>  	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
>  		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
>  		return ret;
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 5477c2c..dced173 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1059,14 +1059,14 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
>  	return vb2_qbuf(&common->buffer_queue, buf);
>  }
>  
> -static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
>  	struct vpif_fh *fh = priv;
>  	struct channel_obj *ch = fh->channel;
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>  	int ret = 0;
>  
> -	if (!(*std_id & VPIF_V4L2_STD))
> +	if (!(std_id & VPIF_V4L2_STD))
>  		return -EINVAL;
>  
>  	if (common->started) {
> @@ -1075,7 +1075,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	}
>  
>  	/* Call encoder subdevice function to set the standard */
> -	ch->video.stdid = *std_id;
> +	ch->video.stdid = std_id;
>  	memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
>  	/* Get the information about the standard */
>  	if (vpif_update_resolution(ch))
> @@ -1093,14 +1093,14 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	vpif_config_format(ch);
>  
>  	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
> -						s_std_output, *std_id);
> +						s_std_output, std_id);
>  	if (ret < 0) {
>  		vpif_err("Failed to set output standard\n");
>  		return ret;
>  	}
>  
>  	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, core,
> -							s_std, *std_id);
> +							s_std, std_id);
>  	if (ret < 0)
>  		vpif_err("Failed to set standard for sub devices\n");
>  	return ret;
> diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
> index 5f7db3f..3a6a0dc 100644
> --- a/drivers/media/platform/fsl-viu.c
> +++ b/drivers/media/platform/fsl-viu.c
> @@ -957,12 +957,12 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct viu_fh *fh = priv;
>  
> -	fh->dev->std = *id;
> -	decoder_call(fh->dev, core, s_std, *id);
> +	fh->dev->std = id;
> +	decoder_call(fh->dev, core, s_std, id);
>  	return 0;
>  }
>  
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 92a33f0..76a8623 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -1357,7 +1357,7 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
>  }
>  
>  /* from vivi.c */
> -static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
> +static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id a)
>  {
>  	return 0;
>  }
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> index 82142a2..d777d0b 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -559,7 +559,7 @@ static int mxr_g_dv_preset(struct file *file, void *fh,
>  	return ret ? -EINVAL : 0;
>  }
>  
> -static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> +static int mxr_s_std(struct file *file, void *fh, v4l2_std_id norm)
>  {
>  	struct mxr_layer *layer = video_drvdata(file);
>  	struct mxr_device *mdev = layer->mdev;
> @@ -576,7 +576,7 @@ static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
>  		return -EBUSY;
>  	}
>  
> -	ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output, *norm);
> +	ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output, norm);
>  
>  	mutex_unlock(&mdev->mutex);
>  
> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 66c8da1..ea8a1ee 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -881,29 +881,29 @@ static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
>  	}
>  }
>  
> -static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
>  	struct sh_vou_device *vou_dev = video_drvdata(file);
>  	int ret;
>  
> -	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): 0x%llx\n", __func__, *std_id);
> +	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): 0x%llx\n", __func__, std_id);
>  
> -	if (*std_id & ~vou_dev->vdev->tvnorms)
> +	if (std_id & ~vou_dev->vdev->tvnorms)
>  		return -EINVAL;
>  
>  	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
> -					 s_std_output, *std_id);
> +					 s_std_output, std_id);
>  	/* Shall we continue, if the subdev doesn't support .s_std_output()? */
>  	if (ret < 0 && ret != -ENOIOCTLCMD)
>  		return ret;
>  
> -	if (*std_id & V4L2_STD_525_60)
> +	if (std_id & V4L2_STD_525_60)
>  		sh_vou_reg_ab_set(vou_dev, VOUCR,
>  			sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
>  	else
>  		sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
>  
> -	vou_dev->std = *std_id;
> +	vou_dev->std = std_id;
>  
>  	return 0;
>  }
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 8ec9805..3592968 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -256,12 +256,12 @@ static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
>  	return 0;
>  }
>  
> -static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> +static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id a)
>  {
>  	struct soc_camera_device *icd = file->private_data;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  
> -	return v4l2_subdev_call(sd, core, s_std, *a);
> +	return v4l2_subdev_call(sd, core, s_std, a);
>  }
>  
>  static int soc_camera_g_std(struct file *file, void *priv, v4l2_std_id *a)
> diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
> index 2d91eeb..a2f7bdd 100644
> --- a/drivers/media/platform/timblogiw.c
> +++ b/drivers/media/platform/timblogiw.c
> @@ -336,7 +336,7 @@ static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id *std)
> +static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id std)
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	struct timblogiw *lw = video_get_drvdata(vdev);
> @@ -348,10 +348,10 @@ static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id *std)
>  	mutex_lock(&lw->lock);
>  
>  	if (TIMBLOGIW_HAS_DECODER(lw))
> -		err = v4l2_subdev_call(lw->sd_enc, core, s_std, *std);
> +		err = v4l2_subdev_call(lw->sd_enc, core, s_std, std);
>  
>  	if (!err)
> -		fh->cur_norm = timblogiw_get_norm(*std);
> +		fh->cur_norm = timblogiw_get_norm(std);
>  
>  	mutex_unlock(&lw->lock);
>  
> diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
> index b051c4a..a794cd6 100644
> --- a/drivers/media/platform/via-camera.c
> +++ b/drivers/media/platform/via-camera.c
> @@ -847,7 +847,7 @@ static int viacam_s_input(struct file *filp, void *priv, unsigned int i)
>  	return 0;
>  }
>  
> -static int viacam_s_std(struct file *filp, void *priv, v4l2_std_id *std)
> +static int viacam_s_std(struct file *filp, void *priv, v4l2_std_id std)
>  {
>  	return 0;
>  }
> diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
> index eb5d6f9..c6af974 100644
> --- a/drivers/media/platform/vino.c
> +++ b/drivers/media/platform/vino.c
> @@ -3042,7 +3042,7 @@ static int vino_g_std(struct file *file, void *__fh,
>  }
>  
>  static int vino_s_std(struct file *file, void *__fh,
> -			   v4l2_std_id *std)
> +			   v4l2_std_id std)
>  {
>  	struct vino_channel_settings *vcs = video_drvdata(file);
>  	unsigned long flags;
> @@ -3056,7 +3056,7 @@ static int vino_s_std(struct file *file, void *__fh,
>  	}
>  
>  	/* check if the standard is valid for the current input */
> -	if ((*std) & vino_inputs[vcs->input].std) {
> +	if (std & vino_inputs[vcs->input].std) {
>  		dprintk("standard accepted\n");
>  
>  		/* change the video norm for SAA7191
> @@ -3065,13 +3065,13 @@ static int vino_s_std(struct file *file, void *__fh,
>  		if (vcs->input == VINO_INPUT_D1)
>  			goto out;
>  
> -		if ((*std) & V4L2_STD_PAL) {
> +		if (std & V4L2_STD_PAL) {
>  			ret = vino_set_data_norm(vcs, VINO_DATA_NORM_PAL,
>  						 &flags);
> -		} else if ((*std) & V4L2_STD_NTSC) {
> +		} else if (std & V4L2_STD_NTSC) {
>  			ret = vino_set_data_norm(vcs, VINO_DATA_NORM_NTSC,
>  						 &flags);
> -		} else if ((*std) & V4L2_STD_SECAM) {
> +		} else if (std & V4L2_STD_SECAM) {
>  			ret = vino_set_data_norm(vcs, VINO_DATA_NORM_SECAM,
>  						 &flags);
>  		} else {
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 11316f2..e9dd01c 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1320,7 +1320,7 @@ out:
>  	return rc;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	struct au0828_fh *fh = priv;
>  	struct au0828_dev *dev = fh->dev;
> @@ -1332,7 +1332,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
>  	   have to make the au0828 bridge adjust the size of its capture
>  	   buffer, which is currently hardcoded at 720x480 */
>  
> -	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, *norm);
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, norm);
>  	dev->std_set_in_tuner_core = 1;
>  
>  	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
> diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
> index 49c842a..f548db8 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-417.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-417.c
> @@ -1492,14 +1492,14 @@ static int vidioc_g_std(struct file *file, void *fh0, v4l2_std_id *norm)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct cx231xx_fh  *fh  = file->private_data;
>  	struct cx231xx *dev = fh->dev;
>  	unsigned int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(cx231xx_tvnorms); i++)
> -		if (*id & cx231xx_tvnorms[i].id)
> +		if (id & cx231xx_tvnorms[i].id)
>  			break;
>  	if (i == ARRAY_SIZE(cx231xx_tvnorms))
>  		return -EINVAL;
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 53020a7..4cff2f4 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -987,7 +987,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	struct cx231xx_fh *fh = priv;
>  	struct cx231xx *dev = fh->dev;
> @@ -998,13 +998,13 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
>  	if (rc < 0)
>  		return rc;
>  
> -	if (dev->norm == *norm)
> +	if (dev->norm == norm)
>  		return 0;
>  
>  	if (videobuf_queue_is_busy(&fh->vb_vidq))
>  		return -EBUSY;
>  
> -	dev->norm = *norm;
> +	dev->norm = norm;
>  
>  	/* Adjusts width/height, if needed */
>  	dev->width = 720;
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 1f16904..98cdc4f 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -994,23 +994,23 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	struct em28xx_fh   *fh  = priv;
>  	struct em28xx      *dev = fh->dev;
>  	struct v4l2_format f;
>  
> -	if (*norm == dev->norm)
> +	if (norm == dev->norm)
>  		return 0;
>  
>  	if (dev->streaming_users > 0)
>  		return -EBUSY;
>  
> -	dev->norm = *norm;
> +	dev->norm = norm;
>  
>  	/* Adjusts width/height, if needed */
>  	f.fmt.pix.width = 720;
> -	f.fmt.pix.height = (*norm & V4L2_STD_525_60) ? 480 : 576;
> +	f.fmt.pix.height = (norm & V4L2_STD_525_60) ? 480 : 576;
>  	vidioc_try_fmt_vid_cap(file, priv, &f);
>  
>  	/* set new image size */
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index da6b779..f49bb32 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -581,13 +581,13 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  }
>  
>  static int vidioc_s_std(struct file *file, void *private_data,
> -			v4l2_std_id *std)
> +			v4l2_std_id std)
>  {
>  	struct hdpvr_fh *fh = file->private_data;
>  	struct hdpvr_device *dev = fh->dev;
>  	u8 std_type = 1;
>  
> -	if (*std & (V4L2_STD_NTSC | V4L2_STD_PAL_60))
> +	if (std & (V4L2_STD_NTSC | V4L2_STD_PAL_60))
>  		std_type = 0;
>  
>  	return hdpvr_config_call(dev, CTRL_VIDEO_STD_TYPE, std_type);
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index 0f729c9..a7774e3 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -196,13 +196,13 @@ static int pvr2_g_std(struct file *file, void *priv, v4l2_std_id *std)
>  	return ret;
>  }
>  
> -static int pvr2_s_std(struct file *file, void *priv, v4l2_std_id *std)
> +static int pvr2_s_std(struct file *file, void *priv, v4l2_std_id std)
>  {
>  	struct pvr2_v4l2_fh *fh = file->private_data;
>  	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
>  
>  	return pvr2_ctrl_set_value(
> -		pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_STDCUR), *std);
> +		pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_STDCUR), std);
>  }
>  
>  static int pvr2_querystd(struct file *file, void *priv, v4l2_std_id *std)
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 2bd8613..ab97e7d 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -1294,7 +1294,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
>  {
>  	struct s2255_fh *fh = priv;
>  	struct s2255_mode mode;
> @@ -1314,7 +1314,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
>  		goto out_s_std;
>  	}
>  	mode = fh->channel->mode;
> -	if (*i & V4L2_STD_525_60) {
> +	if (i & V4L2_STD_525_60) {
>  		dprintk(4, "%s 60 Hz\n", __func__);
>  		/* if changing format, reset frame decimation/intervals */
>  		if (mode.format != FORMAT_NTSC) {
> @@ -1324,7 +1324,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
>  			channel->width = LINE_SZ_4CIFS_NTSC;
>  			channel->height = NUM_LINES_4CIFS_NTSC * 2;
>  		}
> -	} else if (*i & V4L2_STD_625_50) {
> +	} else if (i & V4L2_STD_625_50) {
>  		dprintk(4, "%s 50 Hz\n", __func__);
>  		if (mode.format != FORMAT_PAL) {
>  			mode.restart = 1;
> @@ -1337,7 +1337,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
>  		ret = -EINVAL;
>  		goto out_s_std;
>  	}
> -	fh->channel->std = *i;
> +	fh->channel->std = i;
>  	if (mode.restart)
>  		s2255_set_mode(fh->channel, &mode);
>  out_s_std:
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index 5307a63..f6a6cdc 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -375,7 +375,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	struct stk1160 *dev = video_drvdata(file);
>  	struct vb2_queue *q = &dev->vb_vidq;
> @@ -388,7 +388,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
>  		return -ENODEV;
>  
>  	/* We need to set this now, before we call stk1160_set_std */
> -	dev->norm = *norm;
> +	dev->norm = norm;
>  
>  	/* This is taken from saa7115 video decoder */
>  	if (dev->norm & V4L2_STD_525_60) {
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 9595309..8df668d 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -801,7 +801,7 @@ static int vidioc_g_fmt_vbi(struct file *file, void *fh,
>  	return 0;
>  }
>  
> -static int set_std(struct poseidon *pd, v4l2_std_id *norm)
> +static int set_std(struct poseidon *pd, v4l2_std_id norm)
>  {
>  	struct video_data *video = &pd->video_data;
>  	struct vbi_data *vbi	= &pd->vbi_data;
> @@ -811,7 +811,7 @@ static int set_std(struct poseidon *pd, v4l2_std_id *norm)
>  	int height;
>  
>  	for (i = 0; i < POSEIDON_TVNORMS; i++) {
> -		if (*norm & poseidon_tvnorms[i].v4l2_id) {
> +		if (norm & poseidon_tvnorms[i].v4l2_id) {
>  			param = poseidon_tvnorms[i].tlg_tvnorm;
>  			log("name : %s", poseidon_tvnorms[i].name);
>  			goto found;
> @@ -846,7 +846,7 @@ out:
>  	return ret;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> +static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id norm)
>  {
>  	struct front_face *front = fh;
>  
> @@ -1270,7 +1270,7 @@ static int restore_v4l2_context(struct poseidon *pd,
>  
>  	pd_video_checkmode(pd);
>  
> -	set_std(pd, &context->tvnormid);
> +	set_std(pd, context->tvnormid);
>  	vidioc_s_input(NULL, front, context->sig_index);
>  	pd_vidioc_s_tuner(pd, context->audio_idx);
>  	pd_vidioc_s_fmt(pd, &context->pix);
> diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
> index b4618d7..a78de1d 100644
> --- a/drivers/media/usb/tm6000/tm6000-video.c
> +++ b/drivers/media/usb/tm6000/tm6000-video.c
> @@ -1056,13 +1056,13 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	int rc = 0;
>  	struct tm6000_fh *fh = priv;
>  	struct tm6000_core *dev = fh->dev;
>  
> -	dev->norm = *norm;
> +	dev->norm = norm;
>  	rc = tm6000_init_analog_mode(dev);
>  
>  	fh->width  = dev->width;
> @@ -1134,7 +1134,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  
>  	dev->input = i;
>  
> -	rc = vidioc_s_std(file, priv, &dev->vfd->current_norm);
> +	rc = vidioc_s_std(file, priv, dev->vfd->current_norm);
>  
>  	return rc;
>  }
> diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
> index 874cfec..041f19e 100644
> --- a/drivers/media/usb/usbvision/usbvision-video.c
> +++ b/drivers/media/usb/usbvision/usbvision-video.c
> @@ -595,11 +595,11 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  {
>  	struct usb_usbvision *usbvision = video_drvdata(file);
>  
> -	usbvision->tvnorm_id = *id;
> +	usbvision->tvnorm_id = id;
>  
>  	call_all(usbvision, core, s_std, usbvision->tvnorm_id);
>  	/* propagate the change to the decoder */
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 8ec8abe..d80d8af 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1383,15 +1383,15 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
>  	struct video_device *vfd = video_devdata(file);
> -	v4l2_std_id *id = arg, norm;
> +	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
>  	int ret;
>  
> -	norm = (*id) & vfd->tvnorms;
> +	norm = id & vfd->tvnorms;
>  	if (vfd->tvnorms && !norm)	/* Check if std is supported */
>  		return -EINVAL;
>  
>  	/* Calls the specific handler */
> -	ret = ops->vidioc_s_std(file, fh, &norm);
> +	ret = ops->vidioc_s_std(file, fh, norm);
>  
>  	/* Updates standard information */
>  	if (ret >= 0)
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 99ccbeb..948cfe2 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -924,7 +924,7 @@ static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
>   *
>   * Return 0 on success, error code otherwise
>   */
> -static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
>  	struct vpfe_video_device *video = video_drvdata(file);
>  	struct vpfe_device *vpfe_dev = video->vpfe_dev;
> @@ -945,13 +945,13 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  		goto unlock_out;
>  	}
>  	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -					 core, s_std, *std_id);
> +					 core, s_std, std_id);
>  	if (ret < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
>  		video->stdid = V4L2_STD_UNKNOWN;
>  		goto unlock_out;
>  	}
> -	video->stdid = *std_id;
> +	video->stdid = std_id;
>  unlock_out:
>  	mutex_unlock(&video->lock);
>  	return ret;
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index e33b7f5..073b3b3 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -612,9 +612,9 @@ dt3155_ioc_g_std(struct file *filp, void *p, v4l2_std_id *norm)
>  }
>  
>  static int
> -dt3155_ioc_s_std(struct file *filp, void *p, v4l2_std_id *norm)
> +dt3155_ioc_s_std(struct file *filp, void *p, v4l2_std_id norm)
>  {
> -	if (*norm & DT3155_CURRENT_NORM)
> +	if (norm & DT3155_CURRENT_NORM)
>  		return 0;
>  	return -EINVAL;
>  }
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index 4e477f3..29fe94d 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -1117,40 +1117,40 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
>  	return 0;
>  }
>  
> -static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
> +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
>  {
>  	struct go7007 *go = ((struct go7007_file *) priv)->go;
>  
>  	if (go->streaming)
>  		return -EBUSY;
>  
> -	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV) && *std != 0)
> +	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV) && std != 0)
>  		return -EINVAL;
>  
> -	if (*std == 0)
> +	if (std == 0)
>  		return -EINVAL;
>  
>  	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
>  			go->input == go->board_info->num_inputs - 1) {
>  		if (!go->i2c_adapter_online)
>  			return -EIO;
> -		if (call_all(&go->v4l2_dev, core, s_std, *std) < 0)
> +		if (call_all(&go->v4l2_dev, core, s_std, std) < 0)
>  			return -EINVAL;
>  	}
>  
> -	if (*std & V4L2_STD_NTSC) {
> +	if (std & V4L2_STD_NTSC) {
>  		go->standard = GO7007_STD_NTSC;
>  		go->sensor_framerate = 30000;
> -	} else if (*std & V4L2_STD_PAL) {
> +	} else if (std & V4L2_STD_PAL) {
>  		go->standard = GO7007_STD_PAL;
>  		go->sensor_framerate = 25025;
> -	} else if (*std & V4L2_STD_SECAM) {
> +	} else if (std & V4L2_STD_SECAM) {
>  		go->standard = GO7007_STD_PAL;
>  		go->sensor_framerate = 25025;
>  	} else
>  		return -EINVAL;
>  
> -	call_all(&go->v4l2_dev, core, s_std, *std);
> +	call_all(&go->v4l2_dev, core, s_std, std);
>  	set_capture_size(go, NULL, 0);
>  
>  	return 0;
> diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
> index 4977e86..310b126 100644
> --- a/drivers/staging/media/solo6x10/v4l2-enc.c
> +++ b/drivers/staging/media/solo6x10/v4l2-enc.c
> @@ -1326,7 +1326,7 @@ static int solo_enc_streamoff(struct file *file, void *priv,
>  	return videobuf_streamoff(&fh->vidq);
>  }
>  
> -static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
> +static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id i)
>  {
>  	return 0;
>  }
> diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
> index ca774cc..87f3c04 100644
> --- a/drivers/staging/media/solo6x10/v4l2.c
> +++ b/drivers/staging/media/solo6x10/v4l2.c
> @@ -773,7 +773,7 @@ static int solo_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>  	return videobuf_streamoff(&fh->vidq);
>  }
>  
> -static int solo_s_std(struct file *file, void *priv, v4l2_std_id *i)
> +static int solo_s_std(struct file *file, void *priv, v4l2_std_id i)
>  {
>  	return 0;
>  }
> diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
> index a7ca488..57585c7 100644
> --- a/include/media/davinci/vpbe.h
> +++ b/include/media/davinci/vpbe.h
> @@ -132,7 +132,7 @@ struct vpbe_device_ops {
>  			       struct v4l2_enum_dv_timings *timings_info);
>  
>  	/* Set std at the output */
> -	int (*s_std)(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id);
> +	int (*s_std)(struct vpbe_device *vpbe_dev, v4l2_std_id std_id);
>  
>  	/* Get the current std at the output */
>  	int (*g_std)(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id);
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 0da8682..ee7b7c6 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -132,7 +132,7 @@ struct v4l2_ioctl_ops {
>  			ENUMSTD is handled by videodev.c
>  		 */
>  	int (*vidioc_g_std) (struct file *file, void *fh, v4l2_std_id *norm);
> -	int (*vidioc_s_std) (struct file *file, void *fh, v4l2_std_id *norm);
> +	int (*vidioc_s_std) (struct file *file, void *fh, v4l2_std_id norm);
>  	int (*vidioc_querystd) (struct file *file, void *fh, v4l2_std_id *a);
>  
>  		/* Input handling */


-- 

Cheers,
Mauro
