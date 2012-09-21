Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15032 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2IUQr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 12:47:57 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAP002DELCQ5E10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:48:26 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAP001YWLBV6M70@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:47:55 +0100 (BST)
Message-id: <505C9A3A.4030500@samsung.com>
Date: Fri, 21 Sep 2012 18:47:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 4/6] videobuf2-core: fill in length field for
 multiplanar buffers.
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
 <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
 <505C9220.9070007@samsung.com> <201209211823.03825.hverkuil@xs4all.nl>
In-reply-to: <201209211823.03825.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2012 06:23 PM, Hans Verkuil wrote:
> On Fri September 21 2012 18:13:20 Sylwester Nawrocki wrote:
>> Hi Hans,
>>
>> On 09/19/2012 04:37 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> length should be set to num_planes in __fill_v4l2_buffer(). That way the
>>> caller knows how many planes there are in the buffer.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> I think this would break VIDIOC_CREATE_BUFS. We need per buffer num_planes.
>> Consider a use case where device is streaming with 2-planar pixel format
>> and we invoke VIDIOC_CREATE_BUFS with single-planar format. On a single 
>> queue there will be buffers with different number of planes. The number of 
>> planes information must be attached to a buffer, otherwise VIDIOC_QUERYBUF 
>> won't work.
> 
> That's a very good point and one I need to meditate on.
> 
> However, your comment applies to patch 1/6, not to this one.
> This patch is about whether or not the length field of v4l2_buffer should
> be filled in with the actual number of planes used by that buffer or not.

Yes, right. Sorry, I was editing response to multiple patches from this
series and have mixed things a bit. I agree that it is logical and expected
to update struct v4l2_buffer for user space.

I have spent some time on this series, and even prepared a patch for s5p-mfc,
as it relies on num_planes being in struct vb2_buffer. But then a realized
there could be buffers with distinct number of planes an a single queue.

Regards,
Sylwester

