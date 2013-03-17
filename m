Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:38809 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756500Ab3CQUN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 16:13:29 -0400
Date: Sun, 17 Mar 2013 21:16:48 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 1/8] smi2021: Add the header file
Message-ID: <20130317201648.GD17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <1363270024-12127-2-git-send-email-jonarne@jonarne.no>
 <20130315121309.GB2989@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130315121309.GB2989@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 15, 2013 at 09:13:10AM -0300, Ezequiel Garcia wrote:
> On Thu, Mar 14, 2013 at 03:06:57PM +0100, Jon Arne Jørgensen wrote:
> > This is the header file for the smi2021 module.
> > 
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > ---
> >  drivers/media/usb/smi2021/smi2021.h | 228 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 228 insertions(+)
> >  create mode 100644 drivers/media/usb/smi2021/smi2021.h
> > 
> > diff --git a/drivers/media/usb/smi2021/smi2021.h b/drivers/media/usb/smi2021/smi2021.h
> > new file mode 100644
> > index 0000000..eba0fef
> > --- /dev/null
> > +++ b/drivers/media/usb/smi2021/smi2021.h
> > @@ -0,0 +1,228 @@
> > +/*******************************************************************************
> > + * smi2021.h                                                                   *
> > + *                                                                             *
> > + * USB Driver for SMI2021 - EasyCap                                            *
> > + * USB ID 1c88:003c                                                            *
> > + *                                                                             *
> > + * *****************************************************************************
> > + *
> > + * Copyright 2011-2013 Jon Arne Jørgensen
> > + * <jonjon.arnearne--a.t--gmail.com>
> > + *
> > + * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
> > + *
> > + * This file is part of SMI2021
> > + * http://code.google.com/p/easycap-somagic-linux/
> > + *
> 
> I'm not sure how helpful it is to add external references.
> Keep in mind that once mainlined, this driver will quickly evolve
> and the external link can get outdated/removed/deprecated, etc.
> 

Yes, I forgot to remove this part before sending the patch.

> > + * This program is free software: you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> 
> Please note Linux kernel preferes GPL v2 *only*, and not any later
> (although I'm not a lawyer).
> 

Ok, I will look into this, shouldn't be a problem to change it :)

> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + *
> > + * This driver is heavily influensed by the STK1160 driver.
> > + * Copyright (C) 2012 Ezequiel Garcia
> > + * <elezegarcia--a.t--gmail.com>
> 
> Cool ;-)
> 

You are welcome, thanks for the review btw :)

> > + *
> > + */
> > +
> > +#ifndef SMI2021_H
> > +#define SMI2021_H
> > +
> > +#include <linux/module.h>
> > +#include <linux/usb.h>
> > +#include <linux/types.h>
> > +#include <linux/spinlock_types.h>
> > +#include <linux/slab.h>
> > +#include <linux/i2c.h>
> > +
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-chip-ident.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-vmalloc.h>
> > +#include <media/saa7115.h>
> > +
> > +#include <sound/core.h>
> > +#include <sound/pcm.h>
> > +#include <sound/pcm_params.h>
> > +#include <sound/initval.h>
> > +
> > +#define SMI2021_DRIVER_VERSION "0.1"
> > +
> > +/* For ISOC */
> > +#define SMI2021_MAX_PKT_SIZE	3072
> > +#define SMI2021_ISOC_PACKETS	10	/* 64 */
> > +#define SMI2021_ISOC_BUFS	4	/* 16 */
> > +#define SMI2021_ISOC_EP		0x82
> > +
> > +/* The structure of the array we use to send i2c settings to the device */
> > +#define SMI2021_CTRL_HEAD 0x00
> > +#define	SMI2021_CTRL_ADDR 0x01
> > +#define SMI2021_CTRL_BM_DATA_TYPE 0x02
> > +#define	SMI2021_CTRL_BM_DATA_OFFSET 0x03
> > +#define	SMI2021_CTRL_DATA_SIZE 0x04
> > +
> > +#define SMI2021_CTRL_REG_HI 0x05
> > +#define SMI2021_CTRL_REG_LO 0x06
> > +#define SMI2021_CTRL_REG_VAL 0x07
> > +
> > +#define SMI2021_CTRL_I2C_REG 0x05
> > +#define SMI2021_CTRL_I2C_VAL 0x06
> > +#define SMI2021_CTRL_I2C_RCV_VAL 0x05
> > +
> > +/* General video constants */
> > +#define SMI2021_BYTES_PER_LINE	1440
> > +#define SMI2021_PAL_LINES	576
> > +#define SMI2021_NTSC_LINES	486
> > +
> > +/* Timing Referance Codes, see saa7113 datasheet */
> > +#define SMI2021_TRC_EAV		0x10
> > +#define SMI2021_TRC_VBI		0x20
> > +#define SMI2021_TRC_FIELD_2	0x40
> > +#define SMI2021_TRC		0x80
> > +
> > +#define DEBUG
> > +#ifdef DEBUG
> > +#define smi2021_dbg(fmt, args...)		\
> > +	pr_debug("smi2021::%s: " fmt, __func__, \
> > +			##args)
> > +#else
> > +#define smi2021_dbg(fmt, args...)
> > +#endif
> > +
> > +#define smi2021_info(fmt, args...)		\
> > +	pr_info("smi2021::%s: " fmt,		\
> > +		__func__, ##args)
> > +
> > +#define smi2021_warn(fmt, args...)		\
> > +	pr_warn("smi2021::%s: " fmt,		\
> > +		__func__, ##args)
> > +
> > +#define smi2021_err(fmt, args...)		\
> > +	pr_err("smi2021::%s: " fmt,		\
> > +		__func__, ##args)
> > +
> > +enum smi2021_sync {
> > +	HSYNC,
> > +	SYNCZ1,
> > +	SYNCZ2,
> > +	TRC
> > +};
> > +
> > +/* Buffer for one video frame */
> > +struct smi2021_buffer {
> > +	/* Common vb2 stuff, must be first */
> > +	struct vb2_buffer		vb;
> > +	struct list_head		list;
> > +
> > +	void				*mem;
> > +	unsigned int			length;
> > +
> > +	bool				second_field;
> > +	bool				in_blank;
> > +	unsigned int			pos;
> > +
> > +	/* ActiveVideo - Line counter */
> > +	u16				trc_av;
> > +};
> > +
> > +struct smi2021_isoc_ctl {
> > +	int max_pkt_size;
> > +	int num_bufs;
> > +	struct urb **urb;
> > +	char **transfer_buffer;
> > +	struct smi2021_buffer *buf;
> > +};
> > +
> > +
> > +struct smi2021_fmt {
> > +	char				*name;
> > +	u32				fourcc;
> > +	int				depth;
> > +};
> > +
> > +struct smi2021_input {
> > +	char				*name;
> > +	int				type;
> > +};
> > +
> > +struct smi2021_dev {
> > +	struct v4l2_device		v4l2_dev;
> > +	struct video_device		vdev;
> > +	struct v4l2_ctrl_handler	ctrl_handler;
> > +
> > +	struct v4l2_subdev		*sd_saa7113;
> > +
> > +	struct usb_device		*udev;
> > +	struct device			*dev;
> > +
> > +	/* Capture buffer queue */
> > +	struct vb2_queue		vb_vidq;
> > +
> > +	/* ISOC control struct */
> > +	struct list_head		avail_bufs;
> > +	struct smi2021_isoc_ctl		isoc_ctl;
> > +
> > +	int				width;		/* frame width */
> > +	int				height;		/* frame height */
> > +	unsigned int			ctl_input;	/* selected input */
> > +	v4l2_std_id			norm;		/* current norm */
> > +	struct smi2021_fmt		*fmt;		/* selected format */
> > +	unsigned int			buf_count;	/* for video buffers */
> > +
> > +	/* i2c i/o */
> > +	struct i2c_adapter		i2c_adap;
> > +	struct i2c_client		i2c_client;
> > +
> > +	struct mutex			v4l2_lock;
> > +	struct mutex			vb_queue_lock;
> > +	spinlock_t			buf_lock;
> > +
> > +	enum smi2021_sync		sync_state;
> > +
> > +	/* audio */
> > +	struct snd_card			*snd_card;
> > +	struct snd_pcm_substream	*pcm_substream;
> > +
> > +	unsigned int			pcm_write_ptr;
> > +	unsigned int			pcm_complete_samples;
> > +
> > +	u8				pcm_read_offset;
> > +	struct work_struct		adev_capture_trigger;
> > +	atomic_t			adev_capturing;
> > +};
> > +
> > +/* Provided by smi2021_main.c */
> > +int smi2021_write_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 val);
> > +int smi2021_read_reg(struct smi2021_dev *dev, u8 addr, u16 reg, u8 *val);
> > +
> > +/* Provided by smi2021_v4l2.c */
> > +int smi2021_vb2_setup(struct smi2021_dev *dev);
> > +int smi2021_video_register(struct smi2021_dev *dev);
> > +void smi2021_clear_queue(struct smi2021_dev *dev);
> > +
> > +/* Provided by smi2021_video.c */
> > +int smi2021_alloc_isoc(struct smi2021_dev *dev);
> > +void smi2021_free_isoc(struct smi2021_dev *dev);
> > +void smi2021_cancel_isoc(struct smi2021_dev *dev);
> > +void smi2021_uninit_isoc(struct smi2021_dev *dev);
> > +
> > +/* Provided by smi2021_i2c.c */
> > +int smi2021_i2c_register(struct smi2021_dev *dev);
> > +int smi2021_i2c_unregister(struct smi2021_dev *dev);
> > +
> > +/* Provided by smi2021_audio.c */
> > +int smi2021_snd_register(struct smi2021_dev *dev);
> > +void smi2021_snd_unregister(struct smi2021_dev *dev);
> > +void smi2021_audio(struct smi2021_dev *dev, u8 *data, int len);
> > +#endif /* SMI2021_H */
> > -- 
> > 1.8.1.1
> > 
> 
> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
