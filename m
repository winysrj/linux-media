Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11939 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GYJwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:52:55 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQH00KF2KO7JQ60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jul 2013 10:52:52 +0100 (BST)
Message-id: <51F0F573.5090709@samsung.com>
Date: Thu, 25 Jul 2013 11:52:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 4/5] V4L2: Rename subdev field of struct
 v4l2_async_notifier
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1307241322100.30777@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1307241322100.30777@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gueannadi,

On 07/24/2013 01:26 PM, Guennadi Liakhovetski wrote:
> On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:
> 
>> > This is a purely cosmetic change. Since the 'subdev' member
>> > points to an array of subdevs it seems more intuitive to name
>> > it in plural form.
>
> Well, I was aware of the fact, that "subdev" is an array and that the 
> plural form of "subdev" would be "subdevs" :-) It was kind of a conscious 
> choice. I think, both ways can be found in the kernel: using singulars and 
> plurals for array names. Whether one of them is better than the other - no 
> idea. My personal preference is somewhat with the singular form as in, say 
> "subdev array" instead of "subdevs array," i.e. as an adjective, but I 
> really don't care all that much :) Feel free to change if that's important 
> for you or for others on V4L :)

Sorry, I expected this patch to be a bit controversial... :) I agree it
might be a matter of taste, but subdev/num_subdevs pair bothered me quite
a bit so I've decided to post the patch anyway.
If you don't mind that much I'd like to keep that patch in this series.

--
Thanks,
Sylwester
