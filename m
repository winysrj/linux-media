Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60197 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2JDJ0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 05:26:11 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD003BC3K8YQ80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 10:26:32 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBD00B913JKM740@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 10:26:09 +0100 (BST)
Message-id: <506D5630.2020004@samsung.com>
Date: Thu, 04 Oct 2012 11:26:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Anatolij Gustschin <agust@denx.de>
Subject: Re: [RFC PATCH 1/3] s5p-g2d: fix compiler warning
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
 <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
 <506C1090.9040008@samsung.com> <201210040843.55489.hverkuil@xs4all.nl>
In-reply-to: <201210040843.55489.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2012 08:43 AM, Hans Verkuil wrote:
> On Wed October 3 2012 12:16:48 Sylwester Nawrocki wrote:
>> On 10/02/2012 10:57 AM, Hans Verkuil wrote:
>>> drivers/media/platform/s5p-g2d/g2d.c:535:2: warning: passing argument 3 of 'vidioc_try_crop' discards 'const' qualifier from pointer target type [enabled by default]
>>> drivers/media/platform/s5p-g2d/g2d.c:510:12: note: expected 'struct v4l2_crop *' but argument is of type 'const struct v4l2_crop *'
>>>
>>> This is fall-out from this commit:
>>>
>>> commit 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
>>> Author: Hans Verkuil <hans.verkuil@cisco.com>
>>> Date:   Wed Sep 5 05:10:48 2012 -0300
>>>
>>>     [media] v4l2: make vidioc_s_crop const
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Aplied, thanks.
> 
> Just to be clear, you're taking care of these s5p patches through your tree, right?

Yes, from now on I will be picking all s5p/exynos patches from LMML
and sending it through my tree, were appropriate. In fact I have been
doing it already in most part. Same with other Samsung media drivers,
like camera sensors. I'll look what needs to be changed at the
MAINTAINERS file. This is to lower volume of patches that needs to be
handled by Mauro. Please Cc me on any s5p/Exynos patches.

--

Thanks,
Sylwester
