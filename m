Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9664 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2JJJeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 05:34:12 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO003587XR0D70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 10:34:39 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBO007IE7WYW6A0@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 10:34:10 +0100 (BST)
Message-id: <50754110.9030702@samsung.com>
Date: Wed, 10 Oct 2012 11:34:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Michael West <michael@iposs.co.nz>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement
 .get_frame_desc subdev callback
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
 <201210081503.36502.hverkuil@xs4all.nl> <20121009220530.2025b1af@redhat.com>
 <201210100827.26254.hverkuil@xs4all.nl>
In-reply-to: <201210100827.26254.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2012 08:27 AM, Hans Verkuil wrote:
>>>> diff --git a/drivers/media/i2c/m5mols/m5mols.h b/drivers/media/i2c/m5mols/m5mols.h
>>>> index 4ab8b37..30654f5 100644
>>>> --- a/drivers/media/i2c/m5mols/m5mols.h
>>>> +++ b/drivers/media/i2c/m5mols/m5mols.h
>>>> @@ -24,7 +24,7 @@
>>>>   * determined by CAPP_JPEG_SIZE_MAX register.
>>>>   */
>>>>  #define M5MOLS_JPEG_TAGS_SIZE		0x20000
>>>> -#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * SZ_1M)
>>>> +#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * 1024 * 1024)
>>
>> Nah! Please don't do that! we shouldn't be patching a driver upstream
>> just because it broke media_build. Also, fixing it there is as simple as
>> adding something similar to this at compat.h:
>>
>> #ifndef SZ_1M
>> 	#define SZ_1m (1024 * 1024)
>> #endif
> 
> Actually, I prefer 1024 * 1024 over SZ_1M. The alternative patch is this:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg53424.html
> 
> Note that the arm architecture will pull in linux/sizes.h, but the x86 arch
> doesn't, so this driver won't compile with x86. It's a real driver bug that
> has nothing to do with media_build.
> 
> So you need to merge one of these two patches to fix this problem. I prefer
> the first, but the second is fine too.

Yes, there is a bug in a driver now, even though the driver compiles on 
ARM, where linux/sizes.h is included indirectly, it won't build on other
architectures where it's not the case. I'm not sure which patch is better,
but one of them needs to be applied. Otherwise we're going to see bug 
reports from people building kernel 3.6+ with allyesconfig, etc..

--

Regards,
Sylwester
