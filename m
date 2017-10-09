Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55322 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751598AbdJIK7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:59:16 -0400
Subject: Re: [PATCH 05/24] media: v4l2-dev: convert VFL_TYPE_* into an enum
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <ddbc94767e3aebb52d4f8bf96611136dda2e2c12.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mike Isely <isely@pobox.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0a8f32fe-d8f0-3864-795c-79b9b3b83cfd@xs4all.nl>
Date: Mon, 9 Oct 2017 12:59:11 +0200
MIME-Version: 1.0
In-Reply-To: <ddbc94767e3aebb52d4f8bf96611136dda2e2c12.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> Using enums makes easier to document, as it can use kernel-doc
> markups. It also allows cross-referencing, with increases the
> kAPI readability.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/media/kapi/v4l2-dev.rst     | 17 ++++++---
>  drivers/media/pci/cx88/cx88-blackbird.c   |  3 +-
>  drivers/media/pci/cx88/cx88-video.c       | 10 +++---
>  drivers/media/pci/cx88/cx88.h             |  4 +--
>  drivers/media/pci/saa7134/saa7134-video.c |  2 ++
>  drivers/media/usb/cx231xx/cx231xx-video.c |  2 ++
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c  |  2 ++
>  drivers/media/usb/tm6000/tm6000-video.c   |  2 ++
>  drivers/media/v4l2-core/v4l2-dev.c        | 10 +++---
>  include/media/v4l2-dev.h                  | 59 +++++++++++++++++--------------
>  include/media/v4l2-mediabus.h             | 30 ++++++++++++++++
>  11 files changed, 98 insertions(+), 43 deletions(-)
> 
> diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
> index b29aa616c267..7bb0505b60f1 100644
> --- a/Documentation/media/kapi/v4l2-dev.rst
> +++ b/Documentation/media/kapi/v4l2-dev.rst
> @@ -196,11 +196,18 @@ device.
>  Which device is registered depends on the type argument. The following
>  types exist:
>  
> -- ``VFL_TYPE_GRABBER``: ``/dev/videoX`` for video input/output devices
> -- ``VFL_TYPE_VBI``: ``/dev/vbiX`` for vertical blank data (i.e. closed captions, teletext)
> -- ``VFL_TYPE_RADIO``: ``/dev/radioX`` for radio tuners
> -- ``VFL_TYPE_SDR``: ``/dev/swradioX`` for Software Defined Radio tuners
> -- ``VFL_TYPE_TOUCH``: ``/dev/v4l-touchX`` for touch sensors
> +========================== ====================	 ==============================
> +:c:type:`vfl_devnode_type` Device name		 Usage
> +========================== ====================	 ==============================
> +``VFL_TYPE_GRABBER``       ``/dev/videoX``       for video input/output devices
> +``VFL_TYPE_VBI``           ``/dev/vbiX``         for vertical blank data (i.e.
> +						 closed captions, teletext)
> +``VFL_TYPE_RADIO``         ``/dev/radioX``       for radio tuners
> +``VFL_TYPE_SUBDEV``        ``/dev/v4l-subdevX``  for V4L2 subdevices
> +``VFL_TYPE_SDR``           ``/dev/swradioX``     for Software Defined Radio
> +						 (SDR) tuners
> +``VFL_TYPE_TOUCH``         ``/dev/v4l-touchX``   for touch sensors
> +========================== ====================	 ==============================
>  
>  The last argument gives you a certain amount of control over the device
>  device node number used (i.e. the X in ``videoX``). Normally you will pass -1
> diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
> index e3101f04941c..0e0952e60795 100644
> --- a/drivers/media/pci/cx88/cx88-blackbird.c
> +++ b/drivers/media/pci/cx88/cx88-blackbird.c
> @@ -805,8 +805,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  
>  	strcpy(cap->driver, "cx88_blackbird");
>  	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
> -	cx88_querycap(file, core, cap);
> -	return 0;
> +	return cx88_querycap(file, core, cap);
>  }
>  
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> index 7d25ecd4404b..9be682cdb644 100644
> --- a/drivers/media/pci/cx88/cx88-video.c
> +++ b/drivers/media/pci/cx88/cx88-video.c
> @@ -806,8 +806,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -void cx88_querycap(struct file *file, struct cx88_core *core,
> -		   struct v4l2_capability *cap)
> +int cx88_querycap(struct file *file, struct cx88_core *core,
> +		  struct v4l2_capability *cap)
>  {
>  	struct video_device *vdev = video_devdata(file);
>  
> @@ -825,11 +825,14 @@ void cx88_querycap(struct file *file, struct cx88_core *core,
>  	case VFL_TYPE_VBI:
>  		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  	cap->capabilities = cap->device_caps | V4L2_CAP_VIDEO_CAPTURE |
>  		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_DEVICE_CAPS;
>  	if (core->board.radio.type == CX88_RADIO)
>  		cap->capabilities |= V4L2_CAP_RADIO;
> +	return 0;
>  }
>  EXPORT_SYMBOL(cx88_querycap);
>  
> @@ -841,8 +844,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  
>  	strcpy(cap->driver, "cx8800");
>  	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
> -	cx88_querycap(file, core, cap);
> -	return 0;
> +	return cx88_querycap(file, core, cap);
>  }
>  
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
> index 6777926f20f2..07a33f02fef4 100644
> --- a/drivers/media/pci/cx88/cx88.h
> +++ b/drivers/media/pci/cx88/cx88.h
> @@ -734,7 +734,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
>  int cx88_enum_input(struct cx88_core *core, struct v4l2_input *i);
>  int cx88_set_freq(struct cx88_core  *core, const struct v4l2_frequency *f);
>  int cx88_video_mux(struct cx88_core *core, unsigned int input);
> -void cx88_querycap(struct file *file, struct cx88_core *core,
> -		   struct v4l2_capability *cap);
> +int cx88_querycap(struct file *file, struct cx88_core *core,
> +		  struct v4l2_capability *cap);
>  
>  #endif
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 51d42bbf969e..e5e02eab3e23 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1531,6 +1531,8 @@ int saa7134_querycap(struct file *file, void *priv,
>  	case VFL_TYPE_VBI:
>  		cap->device_caps |= vbi_caps;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  	cap->capabilities = radio_caps | video_caps | vbi_caps |
>  		cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 179b8481a870..946306aa4a4e 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -1756,6 +1756,8 @@ static int cx231xx_v4l2_open(struct file *filp)
>  	case VFL_TYPE_RADIO:
>  		radio = 1;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	cx231xx_videodbg("open dev=%s type=%s users=%d\n",
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index 4320bda9352d..864830d4c741 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -153,6 +153,8 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
>  	case VFL_TYPE_RADIO:
>  		cap->device_caps = V4L2_CAP_RADIO;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  	cap->device_caps |= V4L2_CAP_TUNER | V4L2_CAP_READWRITE;
>  	return 0;
> diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
> index ec8c4d2534dc..6b8a2e265762 100644
> --- a/drivers/media/usb/tm6000/tm6000-video.c
> +++ b/drivers/media/usb/tm6000/tm6000-video.c
> @@ -1330,6 +1330,8 @@ static int __tm6000_open(struct file *file)
>  	case VFL_TYPE_RADIO:
>  		radio = 1;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	/* If more than one user, mutex should be added */
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index c647ba648805..d5e0e536ef04 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -102,7 +102,7 @@ static DECLARE_BITMAP(devnode_nums[VFL_TYPE_MAX], VIDEO_NUM_DEVICES);
>  
>  #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
>  /* Return the bitmap corresponding to vfl_type. */
> -static inline unsigned long *devnode_bits(int vfl_type)
> +static inline unsigned long *devnode_bits(enum vfl_devnode_type vfl_type)
>  {
>  	/* Any types not assigned to fixed minor ranges must be mapped to
>  	   one single bitmap for the purposes of finding a free node number
> @@ -113,7 +113,7 @@ static inline unsigned long *devnode_bits(int vfl_type)
>  }
>  #else
>  /* Return the bitmap corresponding to vfl_type. */
> -static inline unsigned long *devnode_bits(int vfl_type)
> +static inline unsigned long *devnode_bits(enum vfl_devnode_type vfl_type)
>  {
>  	return devnode_nums[vfl_type];
>  }
> @@ -821,8 +821,10 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  	return 0;
>  }
>  
> -int __video_register_device(struct video_device *vdev, int type, int nr,
> -		int warn_if_nr_in_use, struct module *owner)
> +int __video_register_device(struct video_device *vdev,
> +			    enum vfl_devnode_type type,
> +			    int nr, int warn_if_nr_in_use,
> +			    struct module *owner)
>  {
>  	int i = 0;
>  	int ret;
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index de1a1453cfd9..f182b47dfd71 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -20,13 +20,25 @@
>  
>  #define VIDEO_MAJOR	81
>  
> -#define VFL_TYPE_GRABBER	0
> -#define VFL_TYPE_VBI		1
> -#define VFL_TYPE_RADIO		2
> -#define VFL_TYPE_SUBDEV		3
> -#define VFL_TYPE_SDR		4
> -#define VFL_TYPE_TOUCH		5
> -#define VFL_TYPE_MAX		6
> +/**
> + * enum vfl_devnode_type - type of V4L2 device node
> + *
> + * @VFL_TYPE_GRABBER:	for video input/output devices
> + * @VFL_TYPE_VBI:	for vertical blank data (i.e. closed captions, teletext)
> + * @VFL_TYPE_RADIO:	for radio tuners
> + * @VFL_TYPE_SUBDEV:	for V4L2 subdevices
> + * @VFL_TYPE_SDR:	for Software Defined Radio tuners
> + * @VFL_TYPE_TOUCH:	for touch sensors
> + */
> +enum vfl_devnode_type {
> +	VFL_TYPE_GRABBER	= 0,
> +	VFL_TYPE_VBI		= 1,
> +	VFL_TYPE_RADIO		= 2,
> +	VFL_TYPE_SUBDEV		= 3,
> +	VFL_TYPE_SDR		= 4,
> +	VFL_TYPE_TOUCH		= 5,
> +};
> +#define VFL_TYPE_MAX VFL_TYPE_TOUCH
>  
>  /* Is this a receiver, transmitter or mem-to-mem? */
>  /* Ignored for VFL_TYPE_SUBDEV. */
> @@ -188,7 +200,7 @@ struct v4l2_file_operations {
>   * @prio: pointer to &struct v4l2_prio_state with device's Priority state.
>   *	 If NULL, then v4l2_dev->prio will be used.
>   * @name: video device name
> - * @vfl_type: V4L device type
> + * @vfl_type: V4L device type, as defined by &enum vfl_devnode_type
>   * @vfl_dir: V4L receiver, transmitter or m2m
>   * @minor: device node 'minor'. It is set to -1 if the registration failed
>   * @num: number of the video device node
> @@ -236,7 +248,7 @@ struct video_device
>  
>  	/* device info */
>  	char name[32];
> -	int vfl_type;
> +	enum vfl_devnode_type vfl_type;
>  	int vfl_dir;
>  	int minor;
>  	u16 num;
> @@ -281,7 +293,7 @@ struct video_device
>   * __video_register_device - register video4linux devices
>   *
>   * @vdev: struct video_device to register
> - * @type: type of device to register
> + * @type: type of device to register, as defined by &enum vfl_devnode_type
>   * @nr:   which device node number is desired:
>   * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
>   * @warn_if_nr_in_use: warn if the desired device node number
> @@ -300,29 +312,22 @@ struct video_device
>   *
>   * Returns 0 on success.
>   *
> - * Valid values for @type are:
> - *
> - *	- %VFL_TYPE_GRABBER - A frame grabber
> - *	- %VFL_TYPE_VBI - Vertical blank data (undecoded)
> - *	- %VFL_TYPE_RADIO - A radio card
> - *	- %VFL_TYPE_SUBDEV - A subdevice
> - *	- %VFL_TYPE_SDR - Software Defined Radio
> - *	- %VFL_TYPE_TOUCH - A touch sensor
> - *
>   * .. note::
>   *
>   *	This function is meant to be used only inside the V4L2 core.
>   *	Drivers should use video_register_device() or
>   *	video_register_device_no_warn().
>   */
> -int __must_check __video_register_device(struct video_device *vdev, int type,
> -		int nr, int warn_if_nr_in_use, struct module *owner);
> +int __must_check __video_register_device(struct video_device *vdev,
> +					 enum vfl_devnode_type type,
> +					 int nr, int warn_if_nr_in_use,
> +					 struct module *owner);
>  
>  /**
>   *  video_register_device - register video4linux devices
>   *
>   * @vdev: struct video_device to register
> - * @type: type of device to register
> + * @type: type of device to register, as defined by &enum vfl_devnode_type
>   * @nr:   which device node number is desired:
>   * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
>   *
> @@ -336,7 +341,8 @@ int __must_check __video_register_device(struct video_device *vdev, int type,
>   *	you video_device_release() should be called on failure.
>   */
>  static inline int __must_check video_register_device(struct video_device *vdev,
> -		int type, int nr)
> +						     enum vfl_devnode_type type,
> +						     int nr)
>  {
>  	return __video_register_device(vdev, type, nr, 1, vdev->fops->owner);
>  }
> @@ -345,7 +351,7 @@ static inline int __must_check video_register_device(struct video_device *vdev,
>   *  video_register_device_no_warn - register video4linux devices
>   *
>   * @vdev: struct video_device to register
> - * @type: type of device to register
> + * @type: type of device to register, as defined by &enum vfl_devnode_type
>   * @nr:   which device node number is desired:
>   * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
>   *
> @@ -361,8 +367,9 @@ static inline int __must_check video_register_device(struct video_device *vdev,
>   *	is responsible for freeing any data. Usually that means that
>   *	you video_device_release() should be called on failure.
>   */
> -static inline int __must_check video_register_device_no_warn(
> -		struct video_device *vdev, int type, int nr)
> +static inline int __must_check
> +video_register_device_no_warn(struct video_device *vdev,
> +			      enum vfl_devnode_type type, int nr)
>  {
>  	return __video_register_device(vdev, type, nr, 0, vdev->fops->owner);
>  }
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 47adb1608d98..3bfe6bcc8365 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -143,6 +143,13 @@ struct v4l2_mbus_config {
>  	};
>  };
>  
> +/**
> + * v4l2_fill_pix_format - Ancillary routine that fills a &struct
> + *	v4l2_pix_format fields from a &struct v4l2_mbus_framefmt.
> + *
> + * @pix_fmt:	pointer to &struct v4l2_pix_format to be filled
> + * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be used as model
> + */
>  static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
>  				const struct v4l2_mbus_framefmt *mbus_fmt)
>  {
> @@ -155,6 +162,15 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
>  	pix_fmt->xfer_func = mbus_fmt->xfer_func;
>  }
>  
> +/**
> + * v4l2_fill_pix_format - Ancillary routine that fills a &struct
> + * 	v4l2_mbus_framefmt from a &struct v4l2_pix_format and a
> + *	data format code.
> + *
> + * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be filled
> + * @pix_fmt:	pointer to &struct v4l2_pix_format to be used as model
> + * @code:	data format code (from &enum v4l2_mbus_pixelcode)
> + */
>  static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>  			   const struct v4l2_pix_format *pix_fmt,
>  			   u32 code)
> @@ -169,6 +185,13 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>  	mbus_fmt->code = code;
>  }
>  
> +/**
> + * v4l2_fill_pix_format - Ancillary routine that fills a &struct
> + *	v4l2_pix_format_mplane fields from a media bus structure.
> + *
> + * @pix_mp_fmt:	pointer to &struct v4l2_pix_format_mplane to be filled
> + * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be used as model
> + */
>  static inline void v4l2_fill_pix_format_mplane(
>  				struct v4l2_pix_format_mplane *pix_mp_fmt,
>  				const struct v4l2_mbus_framefmt *mbus_fmt)
> @@ -182,6 +205,13 @@ static inline void v4l2_fill_pix_format_mplane(
>  	pix_mp_fmt->xfer_func = mbus_fmt->xfer_func;
>  }
>  
> +/**
> + * v4l2_fill_pix_format - Ancillary routine that fills a &struct
> + * 	v4l2_mbus_framefmt from a &struct v4l2_pix_format_mplane.
> + *
> + * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be filled
> + * @pix_mp_fmt:	pointer to &struct v4l2_pix_format_mplane to be used as model
> + */
>  static inline void v4l2_fill_mbus_format_mplane(
>  				struct v4l2_mbus_framefmt *mbus_fmt,
>  				const struct v4l2_pix_format_mplane *pix_mp_fmt)
> 
