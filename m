Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FE6C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A4C20823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfARMl7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 07:41:59 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53737 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727436AbfARMl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 07:41:58 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kTT9gkuIYNR5ykTTAgWT2C; Fri, 18 Jan 2019 13:41:56 +0100
Subject: Re: [PATCH v7] media: imx: add mem2mem device
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
 <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
 <1547810284.3375.6.camel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <377d7120-14b5-274d-d4d8-c6d21fba9f3b@xs4all.nl>
Date:   Fri, 18 Jan 2019 13:41:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1547810284.3375.6.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfK9zqnzEJLLTuYvwLD4er8eFUsZxYm6ChVW6a/p+GlunSypzUfuOP50BBQiMkCgSAo137IU0f4BYDZkl7EatsKYPyXkNEfKr6I9Qq6V40J7QQiC4gMY4
 j6MDImJbwZiwhMO8BvHA+T0P/JRR9RaBIGhwxkbhokbvgG0n0rIStFaa/CnrVDSEEl5Ejfc1KGGk96gG+rTY3obTKwl5tdmSp/UeTKP6wjVmgECfi1eXOCqO
 +dbzPSmupDuTepb+gnmtXlfHQ9mAP/4H0Md3oVGYFV6mj94nJa+Mz7HK15mPe9QeEnxROd+2W+GLvaqICHS9bfrPBQboo+XhoU6Cbbv7I7W+jAWjiKltK+qC
 TMZW63texXv0UnocaZVg7EhMv1Px3vm29zduWrYx6h2zhDqhWJufS5H9mMcx8ZHy5SlAbHKM
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/18/19 12:18 PM, Philipp Zabel wrote:
> Hi Hans,
> 
> On Fri, 2019-01-18 at 10:30 +0100, Hans Verkuil wrote:
>> On 1/17/19 4:50 PM, Philipp Zabel wrote:
> [...]
>>> +
>>> +static const struct video_device ipu_csc_scaler_videodev_template = {
>>> +	.name		= "ipu0_ic_pp mem2mem",
>>
>> I would expect to see something like 'imx-media-csc-scaler' as the name.
>> Wouldn't that be more descriptive?
> 
> Yes, thank you. I'll change this as well.
> 
> [...]
>>> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
>>> index 4b344a4a3706..fee2ece0a6f8 100644
>>> --- a/drivers/staging/media/imx/imx-media-dev.c
>>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>>> @@ -318,12 +318,36 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
>>>  		goto unlock;
>>>  
>>>  	ret = v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
>>> -unlock:
>>> -	mutex_unlock(&imxmd->mutex);
>>>  	if (ret)
>>> -		return ret;
>>> +		goto unlock;
>>> +
>>> +	imxmd->m2m_vdev = imx_media_csc_scaler_device_init(imxmd);
>>> +	if (IS_ERR(imxmd->m2m_vdev)) {
>>> +		ret = PTR_ERR(imxmd->m2m_vdev);
>>> +		goto unlock;
>>> +	}
>>>  
>>> -	return media_device_register(&imxmd->md);
>>> +	ret = imx_media_csc_scaler_device_register(imxmd->m2m_vdev);
>>> +	if (ret)
>>> +		goto m2m_remove;
>>> +
>>> +	mutex_unlock(&imxmd->mutex);
>>> +
>>> +	ret = media_device_register(&imxmd->md);
>>> +	if (ret) {
>>> +		mutex_lock(&imxmd->mutex);
>>> +		goto m2m_unreg;
>>> +	}
>>
>> I am missing a call to v4l2_m2m_register_media_controller() to ensure that this
>> device shows up in the media controller.
> 
> I can do that, but what would be the purpose of it showing up in the
> media controller?
> There is nothing to be configured, no interaction with the rest of the
> graph, and the processing subdevice wouldn't even correspond to an
> actual hardware unit. I assumed this would clutter the media controller
> for no good reason.

Just because you can't change routing doesn't mean you can't expose it in the
media controller topology. It makes sense to show in the topology that you
have this block.

That said, I can't decide whether or not to add this. For a standalone m2m
device I would not require it, but in this case you already have a media
device.

I guess it is easy enough to add later, so leave this for now.

> 
> [...]
>>> @@ -262,6 +265,13 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
>>>  					 struct v4l2_pix_format *pix);
>>>  void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
>>>  
>>> +/* imx-media-mem2mem.c */
>>> +struct imx_media_video_dev *
>>> +imx_media_csc_scaler_device_init(struct imx_media_dev *dev);
>>> +void imx_media_csc_scaler_device_remove(struct imx_media_video_dev *vdev);
>>> +int imx_media_csc_scaler_device_register(struct imx_media_video_dev *vdev);
>>> +void imx_media_csc_scaler_device_unregister(struct imx_media_video_dev *vdev);
>>> +
>>>  /* subdev group ids */
>>>  #define IMX_MEDIA_GRP_ID_CSI2      BIT(8)
>>>  #define IMX_MEDIA_GRP_ID_CSI_BIT   9
>>
>> How did you test the rotate control? I'm asking because I would expect to see code
>> that checks this control in the *_fmt ioctls: rotating 90 or 270 degrees would mean
>> that the reported width and height are swapped for the capture queue. And I see no
>> sign that that is done. For the same reason this should also impact the g/s_selection
>> code.
> 
> I'm probably misunderstanding something.
> 
> Which "reported width and height" have to be swapped compared to what?
> Since this is a scaler, the capture queue has its own width and height,
> independent of the output queue width and height.
> What currently happens is that the chosen capture width and height stay
> the same upon rotation, so the image is stretched into the configured
> dimensions.
> 
> The V4L2_CID_ROTATE documentation [1] states:
> 
>     Rotates the image by specified angle. Common angles are 90, 270 and
>     180. Rotating the image to 90 and 270 will reverse the height and
>     width of the display window. It is necessary to set the new height
>     and width of the picture using the VIDIOC_S_FMT ioctl according to
>     the rotation angle selected.
> 
> [1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/control.html#control-ids
> 
> I didn't understand what the "display window" is in the context of a
> mem2mem scaler/rotator/CSC converter. Is this intended to mean that
> aspect ratio should be kept as intact as possible, and that every time
> V4L2_CID_ROTATE changes between 0/180 and 90/270, an automatic S_FMT
> should be issued on the capture queue with width and height switched
> compared to the currently set value? This might still slightly modify
> width and height due to alignment restrictions.

Most drivers that implement rotate do not have a scaler, so rotating a
640x480 image would result in a 480x640 result. Hence for an m2m device
the output queue would have format 640x480 and the capture queue 480x640.

So the question becomes: what if you can both rotate and scale, what
do you do when you change the rotate control?

I would expect as a user of this API that if I first scale 640x480 to
320x240, then rotate 90 degrees, that the capture format is now 240x320.

In other words, rotating comes after scaling.

But even if you keep the current behavior I suspect you still need to
update the format due to alignment restriction. Either due to 4:2:2
formats or due to the 'resizer cannot downsize more than 4:1' limitation.

E.g. in the latter case it is fine to downscale 640x480 to 640x120,
but if you now rotate 90 degrees, then you can no longer downscale
480x640 to 640x120 (640 / 120 > 4).

At least, if I understand the code correctly.

There may also be a corner case with rotate and MIN_W/MIN_H resolutions
(MAX_W == MAX_H, so that's probably fine).

It might be a good idea to set MIN_H equal to MIN_W to simplify the rotate
code.

Regards,

	Hans
