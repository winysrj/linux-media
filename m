Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53328 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbeJQRLG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 13:11:06 -0400
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <1711632.PTPtFUq1Nv@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3d5261b9-05e5-8d32-37c9-628ac0071ef3@xs4all.nl>
Date: Wed, 17 Oct 2018 11:16:14 +0200
MIME-Version: 1.0
In-Reply-To: <1711632.PTPtFUq1Nv@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2018 10:57 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday, 20 September 2018 17:42:15 EEST Hans Verkuil wrote:
>> Some parts of the V4L2 API are awkward to use and I think it would be
>> a good idea to look at possible candidates for that.
>>
>> Examples are the ioctls that use struct v4l2_buffer: the multiplanar support
>> is really horrible, and writing code to support both single and multiplanar
>> is hard. We are also running out of fields and the timeval isn't y2038
>> compliant.
>>
>> A proof-of-concept is here:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95
>> 549df06d9900f3559afdbb9da06bd4b22d1f3
>>
>> It's a bit old, but it gives a good impression of what I have in mind.
>>
>> Another candidate is
>> VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS: expressing
>> frame intervals as a fraction is really awkward and so is the fact that the
>> subdev and 'normal' ioctls are not the same.
>>
>> Would using nanoseconds or something along those lines for intervals be
>> better?
>>
>> I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there is no
>> stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But it
>> should be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with stepwise
>> support, I think.
> 
> If we refresh the enumeration ioctls, I propose moving away from the one 
> syscall per value model, and returning everything in one (userspace-allocated) 
> buffer. The same could apply to all enumerations (such as controls for 
> instance), even if we don't address them all in one go.

I'm not convinced about this, primarily because I think these enums are done
at configuration time, and rarely if ever while streaming. So does it really
make a difference in practice? Feedback on this would be welcome during the
summit meeting.

> 
>> Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, again
>> in order to improve single vs multiplanar handling.
> 
> If we refresh the G/S/TRY format ioctls (and I think we should), I would 
> propose moving to a G/S model with ACTIVE and TRY formats, as for subdevs. 
> This should make it easier to construct full device states internally, in 
> order to implement proper request API support for formats. We should then also 
> document much better how formats and selection rectangles interact.

Interesting. I was planning a slide for this.

>> It is not the intention to come to a full design, it's more to test the
>> waters so to speak.
> 
> Another item that we're missing is a way to delete buffers (the counterpart of 
> VIDIOC_CREATE_BUFS). As this will introduce holes in the buffer indices, we 
> might also need to revamp VIDIOC_CREATE_BUFS (which would give us a chance to 
> move away from the format structure passed to that ioctl).
> 

I'm just writing the slide for that :-)

Regards,

	Hans
