Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20395 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3CALBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:01:14 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIZ002ZVAJQAF70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:01:11 +0000 (GMT)
Received: from [106.116.147.108] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MIZ00JPEALYMG50@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:01:11 +0000 (GMT)
Message-id: <51308A75.4040300@samsung.com>
Date: Fri, 01 Mar 2013 12:01:09 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [RFC PATCH 00/18] Remove DV_PRESET API
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for the patches.
I applied the patchset on the top of SPRC's 3.8-rc4 kernel.
I tested the s5p-tv dv-timings using 0.9.3 using v4l-utils.
The test platform was Universal C210 (based on Exynos 4210 SoC).

Every timing mode worked correctly so do not hesitate to add:

Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

to all s5p-tv related patches.

I tested following features:
a) v4l2-ctl --list-dv-timings
   Result: got 10 timings entries as expected
b) v4l2-ctl --get-dv-timings-cap
   Result: got timings caps. The was minor issue. Minimal with is 720 not 640.
c) for each available timing
   v4l2-ctl --set-dv-bt-timings=index={index}
   v4l2-ctl --get-dv-bt-timings
   Show test image on the screen
   Result: TV detected correct timings for all cases

I found some minor issues in the patches.
Please refer to the inlined comments.

BTW.
The v4l2-ctl reports that fps for 1080i50 and 1080i60 as 25 and 30 respectively.
I agree that those values correctly reflects relation between
image resolution and the pixel rate.
However, I admit it looks a little bit confusing when suddenly 50 changes into 25.
It should clarified if F in FPS stands for "frame" or "field".

Regards,
Tomasz Stanislawski

On 02/16/2013 10:28 AM, Hans Verkuil wrote:
> Hi all!
> 
> This patch series removes the last remnants of the deprecated DV_PRESET API
> from the kernel:
> 
> - remove the dv_preset ops from the tvp7002 driver: all bridge drivers that
>   use this i2c driver have already been converted to the DV_TIMINGS API, so
>   these ops are no longer used. Prabhakar, can you test this for me?
> 
> - fix some remaining references to the preset API from the davinci drivers.
>   It's trivial stuff, but I would appreciate it if you can look at it, 
>   Prabhakar.
> 
> - rename some CUSTOM_TIMINGS defines to DV_TIMINGS since CUSTOM_TIMINGS
>   is deprecated. It certainly shouldn't be used anymore in the kernel.
>   Trivial patches, but please look at it as well, Prabhakar and Scott.
> 
> - convert the s5p-tv drivers from the DV_PRESET to the DV_TIMINGS API and
>   remove the DV_PRESET API. Tomasz or Kyungmin Park, can you test this?
>   I do not know whether removal of the DV_PRESET API is possible at this
>   stage for the s5p-tv since I do not know if any code inside Samsung
>   uses the DV_PRESET API. If the DV_PRESET API cannot be removed at this
>   time, then let me know. I would have to make some changes to allow the
>   preset and timings APIs to co-exist. I would really like to remove the
>   preset API some time this year, though, if only to prevent new drivers 
>   from attempting to use the preset API.
> 
> - finally remove the remaining core DV_PRESET support.
> 
> - remove the DV_PRESET API from the videodev2.h header. Note that I am not
>   at all certain if we should do this. I know that the DV_PRESET API has
>   only been used in embedded systems, so the impact should be very limited.
>   But it is probably better to wait for a year or so before actually 
>   removing it from the header. The main reason for adding this removal is
>   to verify that I haven't forgotten any driver conversions.
> 
> Comments are welcome!
> 
> Regards,
> 
> 	Hans
> 

