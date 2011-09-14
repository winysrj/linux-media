Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62724 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1INKhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 06:37:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRI00KCODI1LE20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Sep 2011 11:37:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRI00GIODI0FR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Sep 2011 11:37:13 +0100 (BST)
Date: Wed, 14 Sep 2011 12:37:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4] V4L: dynamically allocate video_device nodes in
 subdevices
In-reply-to: <alpine.DEB.2.00.1109132245570.11360@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4E7083D8.9050804@samsung.com>
References: <Pine.LNX.4.64.1109091701060.915@axis700.grange>
 <201109092332.59943.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1109121253270.9638@axis700.grange>
 <201109131116.35408.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1109131318450.17902@axis700.grange>
 <4E6F9832.1070404@samsung.com>
 <alpine.DEB.2.00.1109132245570.11360@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 09/13/2011 11:18 PM, Guennadi Liakhovetski wrote:
> On Tue, 13 Sep 2011, Sylwester Nawrocki wrote:
>> On 09/13/2011 04:48 PM, Guennadi Liakhovetski wrote:
>>> Currently only very few drivers actually use video_device nodes, embedded
>>> in struct v4l2_subdev. Allocate these nodes dynamically for those drivers
>>> to save memory for the rest.
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>
>> I have tested this patch with Samsung FIMC driver and with MC enabled
>> sensor driver.
>> After some hundreds of module load/unload I didn't observe anything unusual.
>> The patch seem to be safe for device node enabled subdevs. You can stick my:
>>
>> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
>> if you feel so.
> 
> Thanks very much for testing! However, depending on your test scenario, 
> you might still not notice a problem by just loading and unloading of 
> modules. It would, however, be useful to execute just one test:
> 
> 1. add one line v4l2-device.c:
> 
> diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> index a3b89f4..33226857 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -195,6 +195,7 @@ EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>  static void v4l2_device_release_subdev_node(struct video_device *vdev)
>  {
>  	struct v4l2_subdev *sd = video_get_drvdata(vdev);
> +	dev_info(&vdev->dev, "%s()\n", __func__);
>  	sd->devnode = NULL;
>  	kfree(vdev);
>  }
> 
> 2. with this patch start and stop capture
> 
> 3. check dmesg - v4l2_device_release_subdev_node() output should not be 
> there yet
> 
> 4. rmmod modules, then the output should be there
> 
> If you could test that - that would be great!

OK, I double checked if v4l2_device_release_subdev_node() is called at the right
time, i.e. I've also checked if the streaming works in between the module unload/load.

I'd added the printk and everything behaved as expected, other than I've tracked
down a few minor bugs in the drivers in the meantime;)

I'll keep your patch applied in my development tree.

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
