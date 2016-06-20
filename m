Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54671 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbcFTQVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:21:44 -0400
Subject: Re: [PATCH v4 9/9] Input: synaptics-rmi4 - add support for F54
 diagnostics
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-10-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <576817C3.1090806@xs4all.nl>
Date: Mon, 20 Jun 2016 18:20:19 +0200
MIME-Version: 1.0
In-Reply-To: <1466172988-3698-10-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 04:16 PM, Nick Dyer wrote:
> Function 54 implements access to various RMI4 diagnostic features.
> 
> This patch adds support for retrieving this data. It registers a V4L2
> device to output the data to user space.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/rmi4/Kconfig      |  11 +
>  drivers/input/rmi4/Makefile     |   1 +
>  drivers/input/rmi4/rmi_bus.c    |   3 +
>  drivers/input/rmi4/rmi_driver.h |   1 +
>  drivers/input/rmi4/rmi_f54.c    | 743 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 759 insertions(+)
>  create mode 100644 drivers/input/rmi4/rmi_f54.c
> 
> diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
> index f73df24..f3418b6 100644
> --- a/drivers/input/rmi4/Kconfig
> +++ b/drivers/input/rmi4/Kconfig
> @@ -61,3 +61,14 @@ config RMI4_F30
>  
>  	  Function 30 provides GPIO and LED support for RMI4 devices. This
>  	  includes support for buttons on TouchPads and ClickPads.
> +
> +config RMI4_F54
> +	bool "RMI4 Function 54 (Analog diagnostics)"
> +	depends on RMI4_CORE
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF2_VMALLOC
> +	help
> +	  Say Y here if you want to add support for RMI4 function 54
> +
> +	  Function 54 provides access to various diagnostic features in certain
> +	  RMI4 touch sensors.
> diff --git a/drivers/input/rmi4/Makefile b/drivers/input/rmi4/Makefile
> index 95c00a7..0bafc85 100644
> --- a/drivers/input/rmi4/Makefile
> +++ b/drivers/input/rmi4/Makefile
> @@ -7,6 +7,7 @@ rmi_core-$(CONFIG_RMI4_2D_SENSOR) += rmi_2d_sensor.o
>  rmi_core-$(CONFIG_RMI4_F11) += rmi_f11.o
>  rmi_core-$(CONFIG_RMI4_F12) += rmi_f12.o
>  rmi_core-$(CONFIG_RMI4_F30) += rmi_f30.o
> +rmi_core-$(CONFIG_RMI4_F54) += rmi_f54.o
>  
>  # Transports
>  obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
> diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
> index b368b05..3aedc65 100644
> --- a/drivers/input/rmi4/rmi_bus.c
> +++ b/drivers/input/rmi4/rmi_bus.c
> @@ -315,6 +315,9 @@ static struct rmi_function_handler *fn_handlers[] = {
>  #ifdef CONFIG_RMI4_F30
>  	&rmi_f30_handler,
>  #endif
> +#ifdef CONFIG_RMI4_F54
> +	&rmi_f54_handler,
> +#endif
>  };
>  
>  static void __rmi_unregister_function_handlers(int start_idx)
> diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
> index 6e140fa..8dfbebe 100644
> --- a/drivers/input/rmi4/rmi_driver.h
> +++ b/drivers/input/rmi4/rmi_driver.h
> @@ -102,4 +102,5 @@ extern struct rmi_function_handler rmi_f01_handler;
>  extern struct rmi_function_handler rmi_f11_handler;
>  extern struct rmi_function_handler rmi_f12_handler;
>  extern struct rmi_function_handler rmi_f30_handler;
> +extern struct rmi_function_handler rmi_f54_handler;
>  #endif
> diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
> new file mode 100644
> index 0000000..bd06788
> --- /dev/null
> +++ b/drivers/input/rmi4/rmi_f54.c
> @@ -0,0 +1,743 @@
> +/*
> + * Copyright (c) 2012-2015 Synaptics Incorporated
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/rmi.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-vmalloc.h>
> +#include "rmi_driver.h"
> +
> +#define F54_NAME		"rmi4_f54"
> +
> +/* F54 data offsets */
> +#define F54_REPORT_DATA_OFFSET  3
> +#define F54_FIFO_OFFSET         1
> +#define F54_NUM_TX_OFFSET       1
> +#define F54_NUM_RX_OFFSET       0
> +
> +/* F54 commands */
> +#define F54_GET_REPORT          1
> +#define F54_FORCE_CAL           2
> +
> +/* Fixed sizes of reports */
> +#define F54_QUERY_LEN			27
> +#define F54_FULL_RAW_CAP_MIN_MAX_SIZE   4
> +#define F54_HIGH_RESISTANCE_SIZE(rx, tx) \
> +					(2 * ((rx) * (tx) + (rx) + (tx) + 3))
> +#define F54_MAX_REPORT_SIZE(rx, tx)	F54_HIGH_RESISTANCE_SIZE((rx), (tx))
> +
> +/* F54 capabilities */
> +#define F54_CAP_BASELINE	(1 << 2)
> +#define F54_CAP_IMAGE8		(1 << 3)
> +#define F54_CAP_IMAGE16		(1 << 6)
> +
> +enum f54_report_type {
> +	F54_REPORT_NONE = 0,
> +	F54_8BIT_IMAGE = 1,
> +	F54_16BIT_IMAGE = 2,
> +	F54_RAW_16BIT_IMAGE = 3,
> +	F54_HIGH_RESISTANCE = 4,
> +	F54_TX_TO_TX_SHORT = 5,
> +	F54_RX_TO_RX1 = 7,
> +	F54_TRUE_BASELINE = 9,
> +	F54_FULL_RAW_CAP_MIN_MAX = 13,
> +	F54_RX_OPENS1 = 14,
> +	F54_TX_OPEN = 15,
> +	F54_TX_TO_GROUND = 16,
> +	F54_RX_TO_RX2 = 17,
> +	F54_RX_OPENS2 = 18,
> +	F54_FULL_RAW_CAP = 19,
> +	F54_FULL_RAW_CAP_RX_COUPLING_COMP = 20,
> +	F54_MAX_REPORT_TYPE,
> +};
> +
> +struct f54_data {
> +	struct rmi_function *fn;
> +
> +	u8 qry[F54_QUERY_LEN];
> +	u8 num_rx_electrodes;
> +	u8 num_tx_electrodes;
> +	u8 capabilities;
> +	u16 clock_rate;
> +	u8 family;
> +
> +	enum f54_report_type report_type;
> +	u8 *report_data;
> +	int report_size;
> +
> +	bool is_busy;
> +	struct mutex status_mutex;
> +	struct mutex data_mutex;
> +
> +	struct workqueue_struct *workqueue;
> +	struct delayed_work work;
> +	unsigned long timeout;
> +
> +	struct completion cmd_done;
> +
> +	/* V4L2 support */
> +	struct v4l2_device v4l2;
> +	struct v4l2_pix_format format;
> +	struct video_device vdev;
> +	struct vb2_queue queue;
> +	struct mutex lock;
> +	int input;
> +	enum f54_report_type inputs[F54_MAX_REPORT_TYPE];
> +};
> +
> +/*
> + * Basic checks on report_type to ensure we write a valid type
> + * to the sensor.
> + */
> +static bool is_f54_report_type_valid(struct f54_data *f54,
> +				     enum f54_report_type reptype)
> +{
> +	switch (reptype) {
> +	case F54_8BIT_IMAGE:
> +		return f54->capabilities & F54_CAP_IMAGE8;
> +	case F54_16BIT_IMAGE:
> +	case F54_RAW_16BIT_IMAGE:
> +		return f54->capabilities & F54_CAP_IMAGE16;
> +	case F54_TRUE_BASELINE:
> +		return f54->capabilities & F54_CAP_IMAGE16;
> +	case F54_HIGH_RESISTANCE:
> +	case F54_TX_TO_TX_SHORT:
> +	case F54_RX_TO_RX1:
> +	case F54_FULL_RAW_CAP_MIN_MAX:
> +	case F54_RX_OPENS1:
> +	case F54_TX_OPEN:
> +	case F54_TX_TO_GROUND:
> +	case F54_RX_TO_RX2:
> +	case F54_RX_OPENS2:
> +	case F54_FULL_RAW_CAP:
> +	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static enum f54_report_type rmi_f54_get_reptype(struct f54_data *f54,
> +						unsigned int i)
> +{
> +	if (i > F54_MAX_REPORT_TYPE)

This should be >=

> +		return F54_REPORT_NONE;
> +
> +	return f54->inputs[i];
> +}
> +
> +static void rmi_f54_create_input_map(struct f54_data *f54)
> +{
> +	int i = 0;
> +	enum f54_report_type reptype;
> +
> +	for (reptype = 1; reptype < F54_MAX_REPORT_TYPE; reptype++) {
> +		if (!is_f54_report_type_valid(f54, reptype))
> +			continue;
> +
> +		f54->inputs[i++] = reptype;
> +	}
> +
> +	/* Remaining values are zero via kzalloc */
> +}
> +
> +static int rmi_f54_request_report(struct rmi_function *fn, u8 report_type)
> +{
> +	struct f54_data *f54 = dev_get_drvdata(&fn->dev);
> +	struct rmi_device *rmi_dev = fn->rmi_dev;
> +	int error;
> +
> +	/* Write Report Type into F54_AD_Data0 */
> +	if (f54->report_type != report_type) {
> +		error = rmi_write(rmi_dev, f54->fn->fd.data_base_addr,
> +				  report_type);
> +		if (error)
> +			return error;
> +		f54->report_type = report_type;
> +	}
> +
> +	/*
> +	 * Small delay after disabling interrupts to avoid race condition
> +	 * in firmare. This value is a bit higher than absolutely necessary.
> +	 * Should be removed once issue is resolved in firmware.
> +	 */
> +	usleep_range(2000, 3000);
> +
> +	mutex_lock(&f54->data_mutex);
> +
> +	error = rmi_write(rmi_dev, fn->fd.command_base_addr, F54_GET_REPORT);
> +	if (error < 0)
> +		return error;
> +
> +	init_completion(&f54->cmd_done);
> +
> +	f54->is_busy = 1;
> +	f54->timeout = jiffies + msecs_to_jiffies(100);
> +
> +	queue_delayed_work(f54->workqueue, &f54->work, 0);
> +
> +	mutex_unlock(&f54->data_mutex);
> +
> +	return 0;
> +}
> +
> +static int rmi_f54_get_report_size(struct f54_data *f54)
> +{
> +	u8 rx = f54->num_rx_electrodes ? : f54->num_rx_electrodes;
> +	u8 tx = f54->num_tx_electrodes ? : f54->num_tx_electrodes;
> +	int size;
> +
> +	switch (rmi_f54_get_reptype(f54, f54->input)) {
> +	case F54_8BIT_IMAGE:
> +		size = rx * tx;
> +		break;
> +	case F54_16BIT_IMAGE:
> +	case F54_RAW_16BIT_IMAGE:
> +	case F54_TRUE_BASELINE:
> +	case F54_FULL_RAW_CAP:
> +	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
> +		size = 2 * rx * tx;
> +		break;
> +	case F54_HIGH_RESISTANCE:
> +		size = F54_HIGH_RESISTANCE_SIZE(rx, tx);
> +		break;
> +	case F54_FULL_RAW_CAP_MIN_MAX:
> +		size = F54_FULL_RAW_CAP_MIN_MAX_SIZE;
> +		break;
> +	case F54_TX_TO_TX_SHORT:
> +	case F54_TX_OPEN:
> +	case F54_TX_TO_GROUND:
> +		size =  (tx + 7) / 8;
> +		break;
> +	case F54_RX_TO_RX1:
> +	case F54_RX_OPENS1:
> +		if (rx < tx)
> +			size = 2 * rx * rx;
> +		else
> +			size = 2 * rx * tx;
> +		break;
> +	case F54_RX_TO_RX2:
> +	case F54_RX_OPENS2:
> +		if (rx <= tx)
> +			size = 0;
> +		else
> +			size = 2 * rx * (rx - tx);
> +		break;
> +	default:
> +		size = 0;
> +	}
> +
> +	return size;
> +}
> +
> +static const struct v4l2_file_operations rmi_f54_video_fops = {
> +	.owner = THIS_MODULE,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.unlocked_ioctl = video_ioctl2,
> +	.read = vb2_fop_read,
> +	.mmap = vb2_fop_mmap,
> +	.poll = vb2_fop_poll,
> +};
> +
> +static int rmi_f54_queue_setup(struct vb2_queue *q,
> +			       unsigned int *nbuffers, unsigned int *nplanes,
> +			       unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct f54_data *f54 = q->drv_priv;
> +
> +	if (*nplanes)
> +		return sizes[0] < rmi_f54_get_report_size(f54) ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = rmi_f54_get_report_size(f54);
> +
> +	return 0;
> +}
> +
> +static void rmi_f54_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct f54_data *f54 = vb2_get_drv_priv(vb->vb2_queue);
> +	u16 *ptr;
> +	enum vb2_buffer_state state;
> +	enum f54_report_type reptype;
> +	int ret;
> +
> +	mutex_lock(&f54->status_mutex);
> +
> +	reptype = rmi_f54_get_reptype(f54, f54->input);
> +	if (reptype == F54_REPORT_NONE) {
> +		state = VB2_BUF_STATE_ERROR;
> +		goto done;
> +	}
> +
> +	if (f54->is_busy) {
> +		state = VB2_BUF_STATE_ERROR;
> +		goto done;
> +	}
> +
> +	ret = rmi_f54_request_report(f54->fn, reptype);
> +	if (ret) {
> +		dev_err(&f54->fn->dev, "Error requesting F54 report\n");
> +		state = VB2_BUF_STATE_ERROR;
> +		goto done;
> +	}
> +
> +	/* get frame data */
> +	mutex_lock(&f54->data_mutex);
> +
> +	while (f54->is_busy) {
> +		mutex_unlock(&f54->data_mutex);
> +		if (!wait_for_completion_timeout(&f54->cmd_done,
> +						 msecs_to_jiffies(1000))) {
> +			dev_err(&f54->fn->dev, "Timed out\n");
> +			state = VB2_BUF_STATE_ERROR;
> +			goto done;
> +		}
> +		mutex_lock(&f54->data_mutex);
> +	}
> +
> +	ptr = vb2_plane_vaddr(vb, 0);
> +	if (!ptr) {
> +		dev_err(&f54->fn->dev, "Error acquiring frame ptr\n");
> +		state = VB2_BUF_STATE_ERROR;
> +		goto data_done;
> +	}
> +
> +	memcpy(ptr, f54->report_data, f54->report_size);
> +	vb2_set_plane_payload(vb, 0, rmi_f54_get_report_size(f54));
> +	state = VB2_BUF_STATE_DONE;
> +
> +data_done:
> +	mutex_unlock(&f54->data_mutex);
> +done:
> +	vb2_buffer_done(vb, state);
> +	mutex_unlock(&f54->status_mutex);
> +}
> +
> +/* V4L2 structures */
> +static const struct vb2_ops rmi_f54_queue_ops = {
> +	.queue_setup            = rmi_f54_queue_setup,
> +	.buf_queue              = rmi_f54_buffer_queue,
> +	.wait_prepare           = vb2_ops_wait_prepare,
> +	.wait_finish            = vb2_ops_wait_finish,
> +};
> +
> +static const struct vb2_queue rmi_f54_queue = {
> +	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +	.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ,
> +	.buf_struct_size = sizeof(struct vb2_buffer),
> +	.ops = &rmi_f54_queue_ops,
> +	.mem_ops = &vb2_vmalloc_memops,
> +	.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
> +	.min_buffers_needed = 1,
> +};
> +
> +static int rmi_f54_vidioc_querycap(struct file *file, void *priv,
> +				   struct v4l2_capability *cap)
> +{
> +	struct f54_data *f54 = video_drvdata(file);
> +
> +	strlcpy(cap->driver, F54_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, SYNAPTICS_INPUT_DEVICE_NAME, sizeof(cap->card));
> +	strlcpy(cap->bus_info, dev_name(&f54->fn->dev), sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +static const char *rmi_f54_reptype_str(enum f54_report_type reptype)
> +{
> +	switch (reptype) {
> +	default:
> +	case F54_REPORT_NONE: return "No report";
> +	case F54_8BIT_IMAGE: return "8 bit image";
> +	case F54_16BIT_IMAGE: return "16 bit image";
> +	case F54_RAW_16BIT_IMAGE: return "Raw 16 bit image";
> +	case F54_HIGH_RESISTANCE: return "High resistance";
> +	case F54_TX_TO_TX_SHORT: return "TX to TX short";
> +	case F54_RX_TO_RX1: return "RX to RX1";
> +	case F54_TRUE_BASELINE: return "True baseline";
> +	case F54_FULL_RAW_CAP_MIN_MAX: return "Full raw cap min max";
> +	case F54_RX_OPENS1: return "RX open S1";
> +	case F54_TX_OPEN: return "TX open";
> +	case F54_TX_TO_GROUND: return "TX to ground";
> +	case F54_RX_TO_RX2: return "RX to RX2";
> +	case F54_RX_OPENS2: return "RX Open S2";
> +	case F54_FULL_RAW_CAP: return "Full raw cap";
> +	case F54_FULL_RAW_CAP_RX_COUPLING_COMP:
> +		return "Full raw cap RX coupling comp";
> +	case F54_MAX_REPORT_TYPE: return "Max report type";
> +	}
> +}
> +
> +static int rmi_f54_vidioc_enum_input(struct file *file, void *priv,
> +				     struct v4l2_input *i)
> +{
> +	struct f54_data *f54 = video_drvdata(file);
> +	enum f54_report_type reptype;
> +
> +	reptype = rmi_f54_get_reptype(f54, i->index);
> +	if (reptype == F54_REPORT_NONE)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_TOUCH_SENSOR;
> +	strlcpy(i->name, rmi_f54_reptype_str(reptype), sizeof(i->name));

Hmm, this doesn't feel right, but I don't have enough knowledge to decide if
using inputs for this is the right approach.

One thing that strikes me as odd is that both F54_8BIT_IMAGE and F54_16BIT_IMAGE
both seem to return signed 16 bit samples. I would expect this to result in
different pixel formats.

I have no idea what all these inputs mean. Are they all actually needed?
Would this perhaps be better implemented through a menu control?

I generally go by the philosophy that if I can't understand it, then it is
likely that others won't either :-)

Regards,

	Hans
