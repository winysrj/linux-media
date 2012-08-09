Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22938 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2HINwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 09:52:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8H00GN1QJU17B0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 14:52:42 +0100 (BST)
Content-transfer-encoding: 8BIT
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8H0078NQIS4Q50@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 14:52:04 +0100 (BST)
Message-id: <5023C083.8040003@samsung.com>
Date: Thu, 09 Aug 2012 15:52:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Richard Zhao <richard.zhao@freescale.com>,
	linux-media@vger.kernel.org
Subject: Re: __video_register_device: warning cannot be reached if
 warn_if_nr_in_use
References: <20120809125501.GD3824@b20223-02.ap.freescale.net>
 <201208091519.19254.hverkuil@xs4all.nl>
In-reply-to: <201208091519.19254.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2012 03:19 PM, Hans Verkuil wrote:
> On Thu August 9 2012 14:55:02 Richard Zhao wrote:
>> In file drivers/media/video/v4l2-dev.c
>>
>> int __video_register_device(struct video_device *vdev, int type, int nr,
>> 		int warn_if_nr_in_use, struct module *owner)
>> {
>> [...]
>> 	vdev->minor = i + minor_offset;
>> 878:	vdev->num = nr;
>>
>> vdev->num is set to nr here. 
>> [...]
>> 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
>> 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
>> 			name_base, nr, video_device_node_name(vdev));
>>
>> so nr != vdev->num is always false. The warning can never be printed.
> 
> Hmm, true. The question is, should we just fix this, or drop the warning altogether?
> Clearly nobody missed that warning.
> 
> I'm inclined to drop the warning altogether and so also the video_register_device_no_warn
> inline function.
> 
> What do others think?

Yeah, let's remove it.

--

Regards,
Sylwester


-- 
Sylwester Nawrocki
실베스터 나브로츠키
Samsung Poland R&D Center
