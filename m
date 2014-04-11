Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55154 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaDKNsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 09:48:39 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3V00J5OD0ZYX80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Apr 2014 14:48:35 +0100 (BST)
Message-id: <5347F2B2.5080103@samsung.com>
Date: Fri, 11 Apr 2014 15:48:34 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 02/13] vb2: fix handling of data_offset and
 v4l2_plane.reserved[]
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
 <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl>
 <5347E49E.6020302@samsung.com> <5347E829.2030102@xs4all.nl>
In-reply-to: <5347E829.2030102@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2014 03:03 PM, Hans Verkuil wrote:
> On 04/11/2014 02:48 PM, Tomasz Stanislawski wrote:
>> On 04/07/2014 03:11 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> The videobuf2-core did not zero the 'planes' array in __qbuf_userptr()
>>> and __qbuf_dmabuf(). That's now memset to 0. Without this the reserved
>>> array in struct v4l2_plane would be non-zero, causing v4l2-compliance
>>> errors.
>>>
>>> More serious is the fact that data_offset was not handled correctly:
>>>
>>> - for capture devices it was never zeroed, which meant that it was
>>>   uninitialized. Unless the driver sets it it was a completely random
>>>   number. With the memset above this is now fixed.
>>>
>>> - __qbuf_dmabuf had a completely incorrect length check that included
>>>   data_offset.
>>
>> Hi Hans,
>>
>> I may understand it wrongly but IMO allowing non-zero data offset
>> simplifies buffer sharing using dmabuf.
>> I remember a problem that occurred when someone wanted to use
>> a single dmabuf with multiplanar API.
>>
>> For example, MFC shares a buffer with DRM. Assume that DRM device
>> forces the whole image to be located in one dmabuf.
>>
>> The MFC uses multiplanar API therefore application must use
>> the same dmabuf to describe luma and chroma planes.
>>
>> It is intuitive to use the same dmabuf for both planes and
>> data_offset=0 for luma plane and data_offset = luma_size
>> for chroma offset.
>>
>> The check:
>>
>>> -		if (planes[plane].length < planes[plane].data_offset +
>>> -		    q->plane_sizes[plane]) {
>>
>> assured that the logical plane does not overflow the dmabuf.
>>
>> Am I wrong?
> 
> Yes :-)
> 
> For video capture the data_offset field is set by the *driver*, not the
> application. In practice data_offset is the size of a header that is in
> front of the actual image.
> 
> You cannot use data_offset for the purpose you describe. To do that a new
> offset field would have to be added (user_offset?). I'm not opposed to
> that, I think it is a valid use-case for both dmabuf and userptr and
> even mmap in combination with CREATE_BUFS.

Ok. What do you think about allowing the user to set this field?
The driver would be allowed to adjust it.
This is a slight change of semantics. As long as application
was forced to treat data_offset as a reserved field (I mean zeroing)
then this change would be backward compatible.

Otherwise, a new field could be introduces as you mentioned.
The name buffer_offset or simply offset might be more
appropriate than user_offset.

I can prepare some RFC about this extension.

Regards,
Tomasz Stanislawski

> 
> Regards,
> 
> 	Hans
> 

