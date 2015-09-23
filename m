Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40697 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbbIWHSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 03:18:16 -0400
Subject: Re: [RFC PATCH v5 5/8] media: videobuf2: Change queue_setup argument
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-6-git-send-email-jh1009.sung@samsung.com>
 <56015B25.4070102@xs4all.nl> <5601F8CF.2090407@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56025231.3020509@xs4all.nl>
Date: Wed, 23 Sep 2015 09:18:09 +0200
MIME-Version: 1.0
In-Reply-To: <5601F8CF.2090407@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 23-09-15 02:56, Junghak Sung wrote:
> 
> 
> On 09/22/2015 10:44 PM, Hans Verkuil wrote:
>> Hi Junghak,
>>
>> On 22-09-15 15:30, Junghak Sung wrote:
>>> Replace struct v4l2_format * with vb2_format * to make queue_setup()
>>> for common use.
>>>
>>> struct vb2_format {
>>> 	unsigned int	type;
>>> 	unsigned int	pixelformat;
>>> 	unsigned int	width;
>>> 	unsigned int	height;
>>> 	unsigned int	num_planes;
>>> 	unsigned int	bytesperline[VIDEO_MAX_PLANES];
>>> 	unsigned int	req_sizes[VIDEO_MAX_PLANES];
>>> };
>>
>> Why would you need all the other fields besides req_sizes[]?
>>
>> Which drivers actually need those other fields? Drivers like exynos4-is/fimc-lite.c
>> don't actually use anything but req_sizes if you read the code carefully.
>>
>> I suspect any driver that uses more than req_sizes is actually buggy or
>> written carelessly.
>>
>> I wish you'd checked with me before making this struct...
>>
>> Be aware that I'm abroad (vacation/conferences) from tomorrow until October 10,
>> so I won't be able to do in-depth reviews during that time (well, I'm able,
>> but I don't want to!)
>>
>> Regards,
>>
>> 	Hans
> 
> Hi Hans,
> 
> I added the member of struct vb2_format, if the member is used by any 
> device driver.
> These are the usecases for each field besides req_sizes[].
> 
> [platform/s3c-camif/camif-capture.c] pixelformat
> [platform/exynos4-is/fimc-capture.c] pixelformat, width, height
> [platform/exynos4-is/fimc-isp-video.c] pixelformat, width, height
> [platform/exynos4-is/fimc-lite.c] pixelformat, width, height
> [platform/soc_camera/mx3_camera.c] pixelformat, width, bytesperline,
>   height
> [platform/soc_camera/rcar_vin.c] pixelformat, width, bytesperline,
>   height
> [platform/soc_camera/sh_mobile_ceu_camera.c] pixelformat, width, 
> bytesperline,
>   height
> [platform/sh_veu.c] type, pixelformat, width, height, byteperline
> [platform/vivid/vivid-vid-cap.c] num_planes, pixelformat
> [platform/vivid/vivid-vid-out.c] num_planes
> [platform/vsp2/vsp1_video.c] width, height, pixelformat, byteperline,
> num_planes
> 
> And I can not understand that fimc-lite.c do not actually use anything 
> but req_sizes[]. In original source code, it seems that fimc_lite.c
> should use the other fields - pixelformat, width, height - if a user
> set the v4l2_format.
> Would you please explain a little bit more?

There are two different things going on here: validation of the format and
using the sizeimage value in queue_setup.

The queue_setup callback should only receive requested sizes, the format validation
should take place on the v4l2 side of create_buffers.

I'm OK if this is a bit hackish (I'm thinking a separate callback somewhere
where v4l2 drivers can do their format validation). I want to discuss this more
during the upcoming workshop. I always thought that it would be better if
the v4l2 core would call try_format first and leave the validation to that
function. But this needs to be discussed first.

Regards,

	Hans

> 
> Thank you for your review.
> 
> Best regards,
> Junghak
> 
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
