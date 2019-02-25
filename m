Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C402AC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C0E62083D
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfBYL1S (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:27:18 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53040 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfBYL1R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 06:27:17 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yEPigL66U4HFnyEPjgK7ea; Mon, 25 Feb 2019 12:27:16 +0100
Subject: Re: [PATCH 5/7] vim2m: replace devm_kzalloc by kzalloc
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-6-hverkuil-cisco@xs4all.nl>
 <20190222112017.GN3522@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <93851199-e0d2-3429-5e0d-5a019459fee6@xs4all.nl>
Date:   Mon, 25 Feb 2019 12:27:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190222112017.GN3522@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJwx0mAS5zM42nj2vfRbNOFMAzAtV4WTgVZ8TStIVOLJ3k5/Lvca2FtAEvZx6M6ZVX9c49rOikvGQ/++hib4oqA06V4znkZtYAyWJ3JO6urlhcbbUZq6
 HkzsX5nPd3bYMUnNayCI8Pmxd+aIR8arexZKE/2zejZA7lqDqEiZUxpC+hsnCrOA+E2OimLeYCKm+xpstSZ02jZFxmILL2FT0YuG1g/e8fPcd38kfoC+pofa
 0GmhzkkGDoC+0GUm34U2wkawvs8c/KGvr841SRSiBtH6iJYwc36fNXbNFpJEXNlkpbj8/zHx9bO6yrL/SGInacmkuAL3v0U4tQ2j2TYz3YAdw8+brpD3XWFj
 4g9PQfQb
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/22/19 12:20 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thu, Feb 21, 2019 at 03:21:46PM +0100, Hans Verkuil wrote:
>> It is not possible to use devm_kzalloc since that memory is
>> freed immediately when the device instance is unbound.
>>
>> Various objects like the video device may still be in use
>> since someone has the device node open, and when that is closed
>> it expects the memory to be around.
>>
>> So use kzalloc and release it at the appropriate time.
> 
> You're opening a can of worms, we have tons of drivers that use
> devm_kzalloc() :-) I however believe this is the right course of action.
> 
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  drivers/media/platform/vim2m.c | 20 +++++++++++++++-----
>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
>> index a27d3052bb62..bfb3e3eb48d1 100644
>> --- a/drivers/media/platform/vim2m.c
>> +++ b/drivers/media/platform/vim2m.c
>> @@ -1087,6 +1087,16 @@ static int vim2m_release(struct file *file)
>>  	return 0;
>>  }
>>  
>> +static void vim2m_device_release(struct video_device *vdev)
>> +{
>> +	struct vim2m_dev *dev = container_of(vdev, struct vim2m_dev, vfd);
>> +
>> +	dprintk(dev, "Releasing last dev\n");
> 
> Do we really need a debug printk here ?

Oops, that's a left-over debug message. I'll remove it.

> 
>> +	v4l2_device_unregister(&dev->v4l2_dev);
>> +	v4l2_m2m_release(dev->m2m_dev);
>> +	kfree(dev);
>> +}
>> +
>>  static const struct v4l2_file_operations vim2m_fops = {
>>  	.owner		= THIS_MODULE,
>>  	.open		= vim2m_open,
>> @@ -1102,7 +1112,7 @@ static const struct video_device vim2m_videodev = {
>>  	.fops		= &vim2m_fops,
>>  	.ioctl_ops	= &vim2m_ioctl_ops,
>>  	.minor		= -1,
>> -	.release	= video_device_release_empty,
>> +	.release	= vim2m_device_release,
>>  	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
>>  };
>>  
>> @@ -1123,13 +1133,13 @@ static int vim2m_probe(struct platform_device *pdev)
>>  	struct video_device *vfd;
>>  	int ret;
>>  
>> -	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
>> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>  	if (!dev)
>>  		return -ENOMEM;
>>  
>>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>>  	if (ret)
>> -		return ret;
>> +		goto unreg_free;
>>  
>>  	atomic_set(&dev->num_inst, 0);
>>  	mutex_init(&dev->dev_mutex);
>> @@ -1192,6 +1202,8 @@ static int vim2m_probe(struct platform_device *pdev)
>>  	video_unregister_device(&dev->vfd);
>>  unreg_v4l2:
>>  	v4l2_device_unregister(&dev->v4l2_dev);
>> +unreg_free:
> 
> I'd call the label error_free, and rename the other ones with an error_
> prefix, as you don't register anything here.

OK

> 
> With these two small issues fixes,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Regards,

	Hans

> 
>> +	kfree(dev);
>>  
>>  	return ret;
>>  }
>> @@ -1207,9 +1219,7 @@ static int vim2m_remove(struct platform_device *pdev)
>>  	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
>>  	media_device_cleanup(&dev->mdev);
>>  #endif
>> -	v4l2_m2m_release(dev->m2m_dev);
>>  	video_unregister_device(&dev->vfd);
>> -	v4l2_device_unregister(&dev->v4l2_dev);
>>  
>>  	return 0;
>>  }
> 

