Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31604 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3GYJd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:33:26 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQH003MAJQ40A60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jul 2013 10:33:25 +0100 (BST)
Message-id: <51F0F0E3.1030800@samsung.com>
Date: Thu, 25 Jul 2013 11:33:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <4947234.Fd6zD5WqhW@avalon>
In-reply-to: <4947234.Fd6zD5WqhW@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/24/2013 12:06 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Thanks for the patches.
> 
> On Monday 22 July 2013 20:04:42 Sylwester Nawrocki wrote:
>> Hello,
>>
>> This is a few patches for the v4l2-async API I wrote while adding
>> the asynchronous subdev registration support to the exynos4-is
>> driver.
>>
>> The most significant change is addition of V4L2_ASYNC_MATCH_OF
>> subdev matching method, where host driver can pass a list of
>> of_node pointers identifying its subdevs.
>>
>> I thought it's a reasonable and simple enough way to support device tree
>> based systems. Comments/other ideas are of course welcome.
> 
> I have similar patches in my tree that I haven't posted yet, so I like the 
> idea :-) For the whole series,

Hm, what a coincidence :-) Thank you for the review.

> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

--
Regards,
Sylwester
