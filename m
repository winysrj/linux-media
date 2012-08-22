Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16395 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2HVMJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 08:09:22 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9500DPCOGHR270@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 13:09:53 +0100 (BST)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9500LBVOFJDR60@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 13:09:20 +0100 (BST)
Message-id: <5034CBEE.1020700@samsung.com>
Date: Wed, 22 Aug 2012 14:09:18 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv8 01/26] v4l: Add DMABUF as a memory type
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
 <1344958496-9373-2-git-send-email-t.stanislaws@samsung.com>
 <201208221227.52900.hverkuil@xs4all.nl>
In-reply-to: <201208221227.52900.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank your for the review.
Please refer to the comments below.

On 08/22/2012 12:27 PM, Hans Verkuil wrote:
> On Tue August 14 2012 17:34:31 Tomasz Stanislawski wrote:
>> From: Sumit Semwal <sumit.semwal@ti.com>
>>
>> Adds DMABUF memory type to v4l framework. Also adds the related file
>> descriptor in v4l2_plane and v4l2_buffer.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>    [original work in the PoC for buffer sharing]
>> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>  drivers/media/video/v4l2-compat-ioctl32.c |   18 ++++++++++++++++++
>>  drivers/media/video/v4l2-ioctl.c          |    1 +
>>  include/linux/videodev2.h                 |    7 +++++++
>>  3 files changed, 26 insertions(+)
>>
>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
>> index 9ebd5c5..a2e0549 100644
>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>> @@ -304,6 +304,7 @@ struct v4l2_plane32 {
>>  	union {
>>  		__u32		mem_offset;
>>  		compat_long_t	userptr;
>> +		__u32		fd;
> 
> Shouldn't this be int?
> 

Notice that this field should be consistent with fd field used in
'struct v4l2_exportbuffer'. Therefore I prefer to use fixed-size types.
One could use __s32 here but notice that file descriptors are defined
as small, nonnegative integers according to POSIX spec. The type __u32
suits well for this purpose. The negative values returned by open
syscall are used only to indicate failures.

On the other hand, using __s32 may help to avoid compiler warning while
building userspace apps due to 'signed-vs-unsigned comparisons'.

However, I do not have any strong opinion about 'int vs __u32' issue :).
Do you think that using __s32 for both QUERYBUF and EXPBUF is a good
compromise?

>>  	} m;
>>  	__u32			data_offset;
>>  	__u32			reserved[11];
>> @@ -325,6 +326,7 @@ struct v4l2_buffer32 {
>>  		__u32           offset;
>>  		compat_long_t   userptr;
>>  		compat_caddr_t  planes;
>> +		__u32		fd;
> 
> Ditto.
> 
>>  	} m;
>>  	__u32			length;
>>  	__u32			reserved2;

> Regards,
> 
> 	Hans
> 

Regards,

	Tomasz
