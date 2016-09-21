Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58833 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750862AbcIUHEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 03:04:25 -0400
Subject: Re: [RFC PATCH 6/7] atmel-isi: remove dependency of the soc-camera
 framework
To: "Wu, Songjun" <Songjun.Wu@microchip.com>,
        linux-media@vger.kernel.org
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-7-git-send-email-hverkuil@xs4all.nl>
 <3b1f31fd-c6c9-2d8d-008a-4491e2132160@microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7026180d-6180-af21-b8bd-23f673e015a7@xs4all.nl>
Date: Wed, 21 Sep 2016 09:04:19 +0200
MIME-Version: 1.0
In-Reply-To: <3b1f31fd-c6c9-2d8d-008a-4491e2132160@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2016 07:53 AM, Wu, Songjun wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On 8/17/2016 14:29, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch converts the atmel-isi driver from a soc-camera driver to a driver
>> that is stand-alone.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/soc_camera/Kconfig     |    3 +-
>>  drivers/media/platform/soc_camera/atmel-isi.c | 1216 +++++++++++++++----------
>>  2 files changed, 721 insertions(+), 498 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
>> index 39f6641..f74e358 100644
>> --- a/drivers/media/platform/soc_camera/Kconfig
>> +++ b/drivers/media/platform/soc_camera/Kconfig
>> @@ -54,9 +54,8 @@ config VIDEO_SH_MOBILE_CEU
>>
>>  config VIDEO_ATMEL_ISI
>>  	tristate "ATMEL Image Sensor Interface (ISI) support"
>> -	depends on VIDEO_DEV && SOC_CAMERA
>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
>>  	depends on ARCH_AT91 || COMPILE_TEST
>> -	depends on HAS_DMA
>>  	select VIDEOBUF2_DMA_CONTIG
>>  	---help---
>>  	  This module makes the ATMEL Image Sensor Interface available
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>> index 30211f6..9947acb 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c


>> +
>>  static int atmel_isi_probe(struct platform_device *pdev)
>>  {
>>  	int irq;
>>  	struct atmel_isi *isi;
>> +	struct vb2_queue *q;
>>  	struct resource *regs;
>>  	int ret, i;
>> -	struct soc_camera_host *soc_host;
>>
>>  	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
>>  	if (!isi) {
>> @@ -1044,20 +1216,65 @@ static int atmel_isi_probe(struct platform_device *pdev)
>>  		return ret;
>>
>>  	isi->active = NULL;
>> -	spin_lock_init(&isi->lock);
>> +	isi->dev = &pdev->dev;
>> +	mutex_init(&isi->lock);
>> +	spin_lock_init(&isi->irqlock);
>>  	INIT_LIST_HEAD(&isi->video_buffer_list);
>>  	INIT_LIST_HEAD(&isi->dma_desc_head);
>>
>> +	q = &isi->queue;
>> +
>> +	/* Initialize the top-level structure */
>> +	ret = v4l2_device_register(&pdev->dev, &isi->v4l2_dev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	isi->vdev = video_device_alloc();
>> +	if (isi->vdev == NULL) {
>> +		ret = -ENOMEM;
>> +		goto err_vdev_alloc;
>> +	}
> If video device is unregistered, the ISI driver must be reloaded when 
> registering a new video device.
> So '*vdev' can be replaced by 'vdev', or move the code above to 
> isi_graph_notify_complete.

I'm afraid I don't understand what you mean. Can you clarify?

Regards,

	Hans

> 
>> +
>> +	/* video node */
>> +	isi->vdev->fops = &isi_fops;
>> +	isi->vdev->v4l2_dev = &isi->v4l2_dev;
>> +	isi->vdev->queue = &isi->queue;
>> +	strlcpy(isi->vdev->name, KBUILD_MODNAME, sizeof(isi->vdev->name));
>> +	isi->vdev->release = video_device_release;
>> +	isi->vdev->ioctl_ops = &isi_ioctl_ops;
>> +	isi->vdev->lock = &isi->lock;
>> +	isi->vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +		V4L2_CAP_READWRITE;
>> +	video_set_drvdata(isi->vdev, isi);
>> +
>> +	/* buffer queue */
>> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
>> +	q->lock = &isi->lock;
>> +	q->drv_priv = isi;
>> +	q->buf_struct_size = sizeof(struct frame_buffer);
>> +	q->ops = &isi_video_qops;
>> +	q->mem_ops = &vb2_dma_contig_memops;
>> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	q->min_buffers_needed = 2;
>> +	q->dev = &pdev->dev;
>> +
>> +	ret = vb2_queue_init(q);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "failed to initialize VB2 queue\n");
>> +		goto err_vb2_queue;
>> +	}
> 
> Regards,
> 	Songjun Wu
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
