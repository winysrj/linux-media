Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13008 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3GYKBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 06:01:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQH00KVUL4MJQ60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jul 2013 11:01:50 +0100 (BST)
Message-id: <51F0F78D.1050206@samsung.com>
Date: Thu, 25 Jul 2013 12:01:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1307241333020.30777@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1307241333020.30777@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 07/24/2013 01:36 PM, Guennadi Liakhovetski wrote:
> On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:
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
> Thanks for the patches. In principle I have nothing against them, OF 
> support looks good, integrating asdl into struct v4l2_subdev, dropping 
> redundant checks, renaming "bus" to "match look ok too. Plural vs. 
> singular seems to be a matter of taste to me :) But in general, provided 
> my single comment concerning struct forward-declaration is addressed

Thanks for your review. I'm going to make that change locally, before
sending a pull request with those patches.

> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

--
Regards,
Sylwester
