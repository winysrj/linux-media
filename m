Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp01.microchip.com ([198.175.253.37]:49322 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985AbcHHKDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 06:03:00 -0400
Subject: Re: [PATCH v8 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Hans Verkuil <hverkuil@xs4all.nl>, <nicolas.ferre@atmel.com>,
	<robh@kernel.org>
References: <1470211686-2198-1-git-send-email-songjun.wu@microchip.com>
 <1470211686-2198-2-git-send-email-songjun.wu@microchip.com>
 <07cf3e49-da67-74d7-528c-618fe94a15ff@xs4all.nl>
CC: <laurent.pinchart@ideasonboard.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, <linux-kernel@vger.kernel.org>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <78d8056d-6203-e3dc-c4a0-b2ee05d254d4@microchip.com>
Date: Mon, 8 Aug 2016 18:02:10 +0800
MIME-Version: 1.0
In-Reply-To: <07cf3e49-da67-74d7-528c-618fe94a15ff@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 8/8/2016 17:37, Hans Verkuil wrote:
> On 08/03/2016 10:08 AM, Songjun Wu wrote:
>> Add driver for the Image Sensor Controller. It manages
>> incoming data from a parallel based CMOS/CCD sensor.
>> It has an internal image processor, also integrates a
>> triple channel direct memory access controller master
>> interface.
>>
>> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
>> ---
>>
>> Changes in v8:
>> - Power on the sensor on the first open in function
>>   'isc_open'.
>> - Power off the sensor on the last release in function
>>   'isc_release'.
>> - Remove the switch of the pipeline.
>>
>> Changes in v7:
>> - Add enum_framesizes and enum_frameintervals.
>> - Call s_stream(0) when stream start fail.
>> - Fill the device_caps field of struct video_device
>>   with V4L2_CAP_STREAMING and V4L2_CAP_VIDEO_CAPTURE.
>> - Initialize the dev of struct vb2_queue.
>> - Set field to FIELD_NONE if the pix field is not supported.
>> - Return the result directly when call g/s_parm of subdev.
>>
>> Changes in v6: None
>> Changes in v5:
>> - Modify the macro definition and the related code.
>>
>> Changes in v4:
>> - Modify the isc clock code since the dt is changed.
>>
>> Changes in v3:
>> - Add pm runtime feature.
>> - Modify the isc clock code since the dt is changed.
>>
>> Changes in v2:
>> - Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
>>   in Kconfig file.
>> - Correct typos and coding style according to Laurent's remarks
>> - Delete the loop while in 'isc_clk_enable' function.
>> - Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
>>   with 'pfe_cfg0' in struct isc_subdev_entity.
>> - Add the code to support VIDIOC_CREATE_BUFS in
>>   'isc_queue_setup' function.
>> - Invoke isc_config to configure register in
>>   'isc_start_streaming' function.
>> - Add the struct completion 'comp' to synchronize with
>>   the frame end interrupt in 'isc_stop_streaming' function.
>> - Check the return value of the clk_prepare_enable
>>   in 'isc_open' function.
>> - Set the default format in 'isc_open' function.
>> - Add an exit condition in the loop while in 'isc_config'.
>> - Delete the hardware setup operation in 'isc_set_format'.
>> - Refuse format modification during streaming
>>   in 'isc_s_fmt_vid_cap' function.
>> - Invoke v4l2_subdev_alloc_pad_config to allocate and
>>   initialize the pad config in 'isc_async_complete' function.
>> - Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
>> - Replace the module_platform_driver_probe() with
>>   module_platform_driver().
>>
>>  drivers/media/platform/Kconfig                |    1 +
>>  drivers/media/platform/Makefile               |    2 +
>>  drivers/media/platform/atmel/Kconfig          |    9 +
>>  drivers/media/platform/atmel/Makefile         |    1 +
>>  drivers/media/platform/atmel/atmel-isc-regs.h |  165 +++
>>  drivers/media/platform/atmel/atmel-isc.c      | 1503 +++++++++++++++++++++++++
>>  6 files changed, 1681 insertions(+)
>>  create mode 100644 drivers/media/platform/atmel/Kconfig
>>  create mode 100644 drivers/media/platform/atmel/Makefile
>>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c
>>
>
> <snip>
>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> new file mode 100644
>> index 0000000..d99d4a5
>> --- /dev/null
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>
> <snip>
>
>> +static int isc_set_default_fmt(struct isc_device *isc)
>> +{
>> +	u32 index = isc->num_user_formats - 1;
>
> Why pick the last format? Strictly speaking it doesn't matter, but in practice
> the most common formats tend to be at the beginning of the format list.
>
Accept, thank you.
The raw format is listed on the beginning, in order to select non-raw 
format, the last format is picked. But it's not very important, it's 
better to use the beginning of the format list.

>> +	struct v4l2_format f = {
>> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> +		.fmt.pix = {
>> +			.width		= VGA_WIDTH,
>> +			.height		= VGA_HEIGHT,
>> +			.field		= V4L2_FIELD_NONE,
>> +			.pixelformat	= isc->user_formats[index]->fourcc,
>> +		},
>> +	};
>> +
>> +	return isc_set_fmt(isc, &f);
>> +}
>> +
>> +static int isc_open(struct file *file)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
>> +	int ret;
>> +
>> +	if (mutex_lock_interruptible(&isc->lock))
>> +		return -ERESTARTSYS;
>> +
>> +	ret = v4l2_fh_open(file);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +	if (!v4l2_fh_is_singular_file(file))
>> +		goto unlock;
>> +
>> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
>> +	if (ret < 0 && ret != -ENOIOCTLCMD)
>> +		goto unlock;
>> +
>> +	ret = isc_set_default_fmt(isc);
>
> This doesn't belong here, this needs to be done in isc_async_complete().
>
> Having the code here means that every time you open the device, the format
> changes back to the default. That's not what you want.
>
Only on the first open, the default format will be set. If it's done in 
isc_async_complete(), there is a problem, the sensor is powered off, the 
default format maybe not be set successfully, because in some sensor 
drivers, calling set_fmt will set the register directly.

>> +	if (ret)
>> +		goto unlock;
>> +
>> +unlock:
>> +	mutex_unlock(&isc->lock);
>> +	return ret;
>> +}
>> +
>
> <snip>
>
>> +static int isc_async_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
>> +					      struct isc_device, v4l2_dev);
>> +	struct isc_subdev_entity *sd_entity;
>> +	struct video_device *vdev = &isc->video_dev;
>> +	struct vb2_queue *q = &isc->vb2_vidq;
>> +	int ret;
>> +
>> +	isc->current_subdev = container_of(notifier,
>> +					   struct isc_subdev_entity, notifier);
>> +	sd_entity = isc->current_subdev;
>> +
>> +	mutex_init(&isc->lock);
>> +	init_completion(&isc->comp);
>> +
>> +	/* Initialize videobuf2 queue */
>> +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes		= VB2_MMAP | VB2_DMABUF | VB2_READ;
>> +	q->drv_priv		= isc;
>> +	q->buf_struct_size	= sizeof(struct isc_buffer);
>> +	q->ops			= &isc_vb2_ops;
>> +	q->mem_ops		= &vb2_dma_contig_memops;
>> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	q->lock			= &isc->lock;
>> +	q->min_buffers_needed	= 1;
>> +	q->dev			= isc->dev;
>> +
>> +	ret = vb2_queue_init(q);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "vb2_queue_init() failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Init video dma queues */
>> +	INIT_LIST_HEAD(&isc->dma_queue);
>> +	spin_lock_init(&isc->dma_queue_lock);
>> +
>> +	/* Register video device */
>> +	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
>> +	vdev->release		= video_device_release_empty;
>> +	vdev->fops		= &isc_fops;
>> +	vdev->ioctl_ops		= &isc_ioctl_ops;
>> +	vdev->v4l2_dev		= &isc->v4l2_dev;
>> +	vdev->vfl_dir		= VFL_DIR_RX;
>> +	vdev->queue		= q;
>> +	vdev->lock		= &isc->lock;
>> +	vdev->ctrl_handler	= isc->current_subdev->sd->ctrl_handler;
>> +	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
>> +	video_set_drvdata(vdev, isc);
>> +
>> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "video_register_device failed: %d\n", ret);
>> +		return ret;
>> +	}
>
> This should be done last. Once the device is registered apps can use it, so
> everything should be configured.
>
Accept, thank you.

>> +
>> +	sd_entity->config = v4l2_subdev_alloc_pad_config(sd_entity->sd);
>> +	if (sd_entity->config == NULL)
>> +		return -ENOMEM;
>> +
>> +	ret = isc_formats_init(isc);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "Init format failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>
> Regards,
>
> 	Hans
>
