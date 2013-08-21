Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58332 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HUIZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:25:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRV00ME2GNJ8960@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Aug 2013 09:25:19 +0100 (BST)
Content-transfer-encoding: 8BIT
Message-id: <5214796E.5050000@samsung.com>
Date: Wed, 21 Aug 2013 10:25:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] s5p-tv: Include missing v4l2-dv-timings.h header file
References: <1376856050-30538-1-git-send-email-s.nawrocki@samsung.com>
 <5211C608.60201@xs4all.nl>
In-reply-to: <5211C608.60201@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 08/19/2013 09:15 AM, Hans Verkuil wrote:
> On 08/18/2013 10:00 PM, Sylwester Nawrocki wrote:
>> Include the v4l2-dv-timings.h header file which in the s5p-tv driver which
>> was supposed to be updated in commit 2576415846bcbad3c0a6885fc44f95083710
>> "[media] v4l2: move dv-timings related code to v4l2-dv-timings.c"
>>
>> This fixes following build error:
>>
>> drivers/media/platform/s5p-tv/hdmi_drv.c: In function ‘hdmi_s_dv_timings’:
>> drivers/media/platform/s5p-tv/hdmi_drv.c:628:3: error: implicit declaration of function ‘v4l_match_dv_timings’
>>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> My apologies for missing this one.

That's all right. Shit happens. I was wondering why this error
didn't show up in your daily builds.

--
Regards,
Sylwester
