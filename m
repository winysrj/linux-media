Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50694 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbbKHNnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2015 08:43:14 -0500
Subject: Re: [PATCH 1/2] vb2: drop v4l2_format argument from queue_setup
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
 <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
 <20151107204045.GR17128@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, jh1009.sung@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563F516D.5060304@xs4all.nl>
Date: Sun, 8 Nov 2015 14:43:09 +0100
MIME-Version: 1.0
In-Reply-To: <20151107204045.GR17128@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2015 09:40 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, Oct 29, 2015 at 05:24:25AM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The queue_setup callback has a void pointer that is just for V4L2
>> and is the pointer to the v4l2_format struct that was passed to
>> VIDIOC_CREATE_BUFS. The idea was that drivers would use the information
>> from that struct to buffers suitable for the requested format.
>>
>> After the vb2 split series this pointer is now a void pointer,
>> which is ugly, and the reality is that all existing drivers will
>> effectively just look at the sizeimage field of v4l2_format.
>>
>> To make this more generic the queue_setup callback is changed:
>> the void pointer is dropped, instead if the *num_planes argument
>> is 0, then use the current format size, if it is non-zero, then
>> it contains the number of requested planes and the sizes array
>> contains the requested sizes. If either is unsupported, then return
>> -EINVAL, otherwise use the requested size(s).
> 
> Please don't.
> 
> This effectively prevents allocating new buffers while streaming if they're
> for a different format than that used by the stream.

Why would this prevent that feature? It's perfectly fine to do that. The only
limitation is that you may need to verify the format beforehand (using TRY_FMT).

Even if drivers really need to do something special, then they can still do
that by providing their own vidioc_create_bufs() callback that does the validation.

Regards,

	Hans

> That was the very point
> in struct v4l2_format being part of the argument to the IOCTL.
> 
> If this is not used right now I could well imagine someone to need it sooner
> or later.
> 

