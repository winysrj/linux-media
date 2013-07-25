Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9235 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3GYJiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:38:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQH003ZFK3VKX50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jul 2013 10:38:53 +0100 (BST)
Message-id: <51F0F22B.4090900@samsung.com>
Date: Thu, 25 Jul 2013 11:38:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <201307241216.26949.hverkuil@xs4all.nl>
In-reply-to: <201307241216.26949.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2013 12:16 PM, Hans Verkuil wrote:
> On Mon 22 July 2013 20:04:42 Sylwester Nawrocki wrote:
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
>> I thought it's a reasonable and simple enough way to support device
>> tree based systems. Comments/other ideas are of course welcome.
> 
> Looks good!
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thank you for the review, Hans. We can always be sure nothing miss
your eye ;)

--
Regards,
Sylwester
