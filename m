Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:50136 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbIWA4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 20:56:50 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NV300KKMUMO3040@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Sep 2015 09:56:48 +0900 (KST)
Message-id: <5601F8CF.2090407@samsung.com>
Date: Wed, 23 Sep 2015 09:56:47 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v5 5/8] media: videobuf2: Change queue_setup argument
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-6-git-send-email-jh1009.sung@samsung.com>
 <56015B25.4070102@xs4all.nl>
In-reply-to: <56015B25.4070102@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/22/2015 10:44 PM, Hans Verkuil wrote:
> Hi Junghak,
>
> On 22-09-15 15:30, Junghak Sung wrote:
>> Replace struct v4l2_format * with vb2_format * to make queue_setup()
>> for common use.
>>
>> struct vb2_format {
>> 	unsigned int	type;
>> 	unsigned int	pixelformat;
>> 	unsigned int	width;
>> 	unsigned int	height;
>> 	unsigned int	num_planes;
>> 	unsigned int	bytesperline[VIDEO_MAX_PLANES];
>> 	unsigned int	req_sizes[VIDEO_MAX_PLANES];
>> };
>
> Why would you need all the other fields besides req_sizes[]?
>
> Which drivers actually need those other fields? Drivers like exynos4-is/fimc-lite.c
> don't actually use anything but req_sizes if you read the code carefully.
>
> I suspect any driver that uses more than req_sizes is actually buggy or
> written carelessly.
>
> I wish you'd checked with me before making this struct...
>
> Be aware that I'm abroad (vacation/conferences) from tomorrow until October 10,
> so I won't be able to do in-depth reviews during that time (well, I'm able,
> but I don't want to!)
>
> Regards,
>
> 	Hans

Hi Hans,

I added the member of struct vb2_format, if the member is used by any 
device driver.
These are the usecases for each field besides req_sizes[].

[platform/s3c-camif/camif-capture.c] pixelformat
[platform/exynos4-is/fimc-capture.c] pixelformat, width, height
[platform/exynos4-is/fimc-isp-video.c] pixelformat, width, height
[platform/exynos4-is/fimc-lite.c] pixelformat, width, height
[platform/soc_camera/mx3_camera.c] pixelformat, width, bytesperline,
  height
[platform/soc_camera/rcar_vin.c] pixelformat, width, bytesperline,
  height
[platform/soc_camera/sh_mobile_ceu_camera.c] pixelformat, width, 
bytesperline,
  height
[platform/sh_veu.c] type, pixelformat, width, height, byteperline
[platform/vivid/vivid-vid-cap.c] num_planes, pixelformat
[platform/vivid/vivid-vid-out.c] num_planes
[platform/vsp2/vsp1_video.c] width, height, pixelformat, byteperline,
num_planes

And I can not understand that fimc-lite.c do not actually use anything 
but req_sizes[]. In original source code, it seems that fimc_lite.c
should use the other fields - pixelformat, width, height - if a user
set the v4l2_format.
Would you please explain a little bit more?

Thank you for your review.

Best regards,
Junghak


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
