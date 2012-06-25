Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49529 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2FYVJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 17:09:36 -0400
Received: by bkcji2 with SMTP id ji2so3643373bkc.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 14:09:35 -0700 (PDT)
Message-ID: <4FE8D38B.2090700@gmail.com>
Date: Mon, 25 Jun 2012 23:09:31 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v3] media: Add stk1160 new driver
References: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

a few minor comments below...

On 06/23/2012 08:36 PM, Ezequiel Garcia wrote:
> This driver adds support for stk1160 usb bridge as used in some
> video/audio usb capture devices.
> It is a complete rewrite of staging/media/easycap driver and
> it's expected as a future replacement.
> 
> Signed-off-by: Ezequiel Garcia<elezegarcia@gmail.com>
> ---
[...]
> +/*
> + * Read/Write stk registers
> + */
> +int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
> +{
> +	int ret;
> +
> +	*value = 0;
> +	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> +			0x00,
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0x00,
> +			reg,
> +			value,
> +			sizeof(u8),
> +			HZ);

A bit strange indentation, but it's up to you to keep it or not.

> +	if (ret<  0) {
> +		stk1160_err("read failed on reg 0x%x (%d)\n",
> +			reg, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
> +{
> +	int ret;
> +
> +	ret =  usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> +			0x01,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			value,
> +			reg,
> +			NULL,
> +			0,
> +			HZ);
> +	if (ret<  0) {
> +		stk1160_err("write failed on reg 0x%x (%d)\n",
> +			reg, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* TODO: We should break this into pieces */
> +static void stk1160_reg_reset(struct stk1160 *dev)
> +{
> +	int i;
> +
> +	static struct regval ctl[] = {

static const struct regval... ?

> +		{STK1160_GCTRL+2, 0x0078},
> +
> +		{STK1160_RMCTL+1, 0x0000},
> +		{STK1160_RMCTL+3, 0x0002},
> +
> +		{STK1160_PLLSO,   0x0010},
> +		{STK1160_PLLSO+1, 0x0000},
> +		{STK1160_PLLSO+2, 0x0014},
> +		{STK1160_PLLSO+3, 0x000E},
> +
> +		{STK1160_PLLFD,   0x0046},
> +
> +		/* Timing generator setup */
> +		{STK1160_TIGEN,   0x0012},
> +		{STK1160_TICTL,   0x002D},
> +		{STK1160_TICTL+1, 0x0001},
> +		{STK1160_TICTL+2, 0x0000},
> +		{STK1160_TICTL+3, 0x0000},
> +		{STK1160_TIGEN,   0x0080},
> +
> +		{0xffff, 0xffff}
> +	};
> +
> +	for (i = 0; ctl[i].reg != 0xffff; i++)
> +		stk1160_write_reg(dev, ctl[i].reg, ctl[i].val);
> +
> +	/* Set selected input from module parameter */
> +	switch (dev->ctl_input) {
> +	case 0:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x98);
> +		break;
> +	case 1:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x90);
> +		break;
> +	case 2:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x88);
> +		break;
> +	case 3:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x80);
> +		break;

How about doing something like:

	static const u8 gctrl[] = {
		0x98, 0x90, 0x88, 0x80
	};

	if (dev->ctl_input < ARRAY_SIZE(gctrl))
		stk1160_write_reg(dev, STK1160_GCTRL, gctrl[dev->ctl_input]);
?
> +	}
> +}
> +
...
> +static int stk1160_i2c_write_reg(struct stk1160 *dev, u8 addr,
> +		u8 reg, u8 value)
> +{
> +	int rc, timeout;
> +	u8 flag;
> +
> +	/* Set serial device address */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Set i2c device register sub-address */
> +	rc = stk1160_write_reg(dev, STK1160_SBUSW_WA, reg);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Set i2c device register value */
> +	rc = stk1160_write_reg(dev, STK1160_SBUSW_WD, value);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Start write now */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x01);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Wait until Write Finish bit is set */
> +	for (timeout = 100; timeout>  0;
> +	     timeout -= 20) {
> +		stk1160_read_reg(dev, STK1160_SICTL+1,&flag);
> +		/* write done? */
> +		if (flag&  0x04)
> +			break;
> +
> +		msleep(20);
> +	}

A bit strange loop, perhaps it's worth to rework it as following:

	unsigned long end = jiffies + msecs_to_jiffies(timeout);

	while (time_is_after_jiffies(end)) {
		...
		usleep_range(...);
	}

to better control the actual time spent on busy waiting.
You may also want to create a separate function i.e.

stk1160_i2c_busy_wait(struct stk1160 *dev, u8 wait_bit_mask, unsigned int timeout)
and use to avoid repeating similar pattern.

> +
> +	if (timeout == 0)
> +		/* return EBUSY, or EFAULT, or what ? */

-ETIMEDOUT ?

> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
> +		u8 reg, u8 *value)
> +{
> +	int rc, timeout;
> +	u8 flag;
> +
> +	/* Set serial device address */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Set i2c device register sub-address */
> +	rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, reg);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Start read now */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Wait until Read Finish bit is set */
> +	for (timeout = 100; timeout>  0;
> +	     timeout -= 20) {
> +		stk1160_read_reg(dev, STK1160_SICTL+1,&flag);
> +		/* read done? */
> +		if (flag&  0x01)
> +			break;
> +
> +		msleep(20);
> +	}
> +
> +	if (timeout == 0)
> +		/* return EBUSY, or EFAULT, or what ? */
> +		return -EIO;
> +
> +	stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> +	if (rc<  0)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +/*
> + * stk1160_i2c_check_for_device()
> + * check if there is a i2c_device at the supplied address
> + */
> +static int stk1160_i2c_check_for_device(struct stk1160 *dev,
> +		unsigned char addr)
> +{
> +	int rc, write_timeout;
> +	u8 flag;
> +
> +	/* Set serial device address */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Set device sub-address, we'll chip version reg */
> +	rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, 0x00);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Start read now */
> +	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
> +	if (rc<  0)
> +		return rc;
> +
> +	/* Wait until Read Finish bit is set */
> +	for (write_timeout = 40; write_timeout>  0;
> +	     write_timeout -= 20) {
> +		stk1160_read_reg(dev, STK1160_SICTL+1,&flag);
> +		if (flag&  0x01)
> +			return 0;
> +
> +		msleep(20);
> +	}
> +
> +	return -ENODEV;
> +}
> +
...
> +
> +/* GPIO Control */
> +#define STK1160_GCTRL			0x000
> +
> +/* Remote Wakup Control */
> +#define STK1160_RMCTL			0x00C

Care to use lower case for all hex numbers ?

> +
> +/*
> + * Decoder Control Register:
> + * This byte controls capture start/stop
> + * with bit #7 (0x?? OR 0x80 to activate).
> + */
> +#define STK1160_DCTRL			0x100
> +
> +/* Capture Frame Start Position */
> +#define STK116_CFSPO			0x110
> +#define STK116_CFSPO_STX_L		0x110
> +#define STK116_CFSPO_STX_H		0x111
> +#define STK116_CFSPO_STY_L		0x112
> +#define STK116_CFSPO_STY_H		0x113
> +
> +/* Capture Frame End Position */
> +#define STK116_CFEPO			0x114
> +#define STK116_CFEPO_ENX_L		0x114
> +#define STK116_CFEPO_ENX_H		0x115
> +#define STK116_CFEPO_ENY_L		0x116
> +#define STK116_CFEPO_ENY_H		0x117
> +
> +/* Serial Interface Control  */
> +#define STK1160_SICTL			0x200
> +#define STK1160_SICTL_CD		0x202
> +#define STK1160_SICTL_SDA		0x203
> +
> +/* Serial Bus Write */
> +#define STK1160_SBUSW			0x204
> +#define STK1160_SBUSW_WA		0x204
> +#define STK1160_SBUSW_WD		0x205
> +
> +/* Serial Bus Read */
> +#define STK1160_SBUSR			0x208
> +#define STK1160_SBUSR_RA		0x208
> +#define STK1160_SBUSR_RD		0x209
> +
> +/* Alternate Serial Inteface Control */
> +#define STK1160_ASIC			0x2FC
> +
> +/* PLL Select Options */
> +#define STK1160_PLLSO			0x018
> +
> +/* PLL Frequency Divider */
> +#define STK1160_PLLFD			0x01C
> +
> +/* Timing Generator */
> +#define STK1160_TIGEN			0x300
> +
> +/* Timing Control Parameter */
> +#define STK1160_TICTL			0x350
> +
> +/* AC97 Audio Control */
> +#define STK1160_AC97CTL_0		0x500
> +#define STK1160_AC97CTL_1		0x504
> +
> +/* Use [0:6] bits of register 0x504 to set codec command address */
> +#define STK1160_AC97_ADDR		0x504
> +/* Use [16:31] bits of register 0x500 to set codec command data */
> +#define STK1160_AC97_CMD		0x502
> +
> +/* Audio I2S Interface */
> +#define STK1160_I2SCTL			0x50c
> +
> +/* EEPROM Interface */
> +#define STK1160_EEPROM_SZ		0x5f0
...
> +static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	if (!stk1160_is_owner(dev, file))
> +		return -EBUSY;
> +
> +	rc = vb2_querybuf(&dev->vb_vidq, p);
> +
> +	return rc;

What about dropping the local "rc" variable here ?

> +}
> +
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	if (!stk1160_is_owner(dev, file))
> +		return -EBUSY;
> +
> +	rc = vb2_qbuf(&dev->vb_vidq, p);
> +
> +	return rc;

Ditto.

> +}
> +
> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	if (!stk1160_is_owner(dev, file))
> +		return -EBUSY;
> +
> +	rc = vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
> +
> +	return rc;

Ditto.

> +}
> +
> +static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	if (!stk1160_is_owner(dev, file))
> +		return -EBUSY;
> +
> +	rc = vb2_streamon(&dev->vb_vidq, i);
> +
> +	return rc;

Ditto.

> +}
> +
> +static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +	int rc;
> +
> +	if (!stk1160_is_owner(dev, file))
> +		return -EBUSY;
> +
> +	rc =  vb2_streamoff(&dev->vb_vidq, i);
> +
> +	return rc;

Ditto.

> +}
> +
> +/*
> + * vidioc ioctls
> + */
...
> +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct stk1160 *dev = video_drvdata(file);
> +
> +	if (!stk1160_acquire_owner(dev, file))
> +		return -EBUSY;
> +
> +	if (i>  STK1160_MAX_INPUT)
> +		return -EINVAL;
> +
> +	dev->ctl_input = i;
> +
> +	switch (dev->ctl_input) {
> +	case 0:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x98);
> +		break;
> +	case 1:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x90);
> +		break;
> +	case 2:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x88);
> +		break;
> +	case 3:
> +		stk1160_write_reg(dev, STK1160_GCTRL, 0x80);
> +		break;
> +	}

Same block of code as in stk1160_reg_reset(). Probably it's worth
to move it into separate function.

> +
> +	return 0;
> +}
> +
...
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
> +	 * So, we set a minimum and a maximum like this:
> +	 */
> +	*nbuffers = clamp_t(unsigned int, *nbuffers,
> +			STK1160_MIN_VIDEO_BUFFERS, STK1160_MAX_VIDEO_BUFFERS);
> +
> +	/* This means a packed colorformat */
> +	*nplanes = 1;
> +
> +	sizes[0] = size;
> +
> +	stk1160_info("%s: buffer count %d, each %ld bytes\n",
> +			__func__, *nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	unsigned long flags = 0;

No need to initialize here.

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
> +
> +		buf->mem = vb2_plane_vaddr(vb, 0);
> +		buf->length = vb2_plane_size(vb, 0);
> +		buf->bytesused = 0;
> +		buf->pos = 0;
> +
> +		/*
> +		 * If buffer length is different from expected then we return
> +		 * the buffer to userspace directly.
> +		 */
> +		if (buf->length != dev->width * dev->height * 2)

It should be OK when the buffer size is larger than the amount of data
the device will be writing to it. So it's better to change the
condition statement to:

		if (buf->length < dev->width * dev->height * 2)

> +			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +		else
> +			list_add_tail(&buf->list,&dev->avail_bufs);
> +
> +	}
> +	spin_unlock_irqrestore(&dev->buf_lock, flags);
> +}
> +
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	int rc;

Not needed ?

> +
> +	rc = stk1160_start_streaming(dev);
> +
> +	return rc;
> +}
> +
> +/* abort streaming and wait for last buffer */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct stk1160 *dev = vb2_get_drv_priv(vq);
> +	int rc;

?

> +
> +	rc = stk1160_stop_streaming(dev, true);
> +
> +	return rc;
> +}

--
Regards,
Sylwester
