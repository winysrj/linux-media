Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63230 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab2IKTVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 15:21:08 -0400
Received: by eekc1 with SMTP id c1so712997eek.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 12:21:06 -0700 (PDT)
Message-ID: <504F8F1F.3020703@gmail.com>
Date: Tue, 11 Sep 2012 21:21:03 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com> <50363F19.5070607@samsung.com> <5036754C.4040501@iki.fi> <1479692.F6ROfrmgsS@avalon> <5037383E.3030109@samsung.com> <20120824225118.GM721@valkosipuli.retiisi.org.uk> <503A7764.700@gmail.com> <20120827192840.GA5261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120827192840.GA5261@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/27/2012 09:28 PM, Sakari Ailus wrote:
>>> How about using bytes on video nodes and bus and media bus code specific
>>> extended samples (or how we should call pixels in uncompressed formats and
>>> units of data in compressed formats?) on subdevs? The information how the
>>> former is derived from the latter resides in the driver controlling the DMA
>>> anyway.
>>>
>>> As you proposed originally, this control is more relevant to subdevs so we
>>> could also not define it for video nodes at all. Especially if the control
>>> isn't needed: the information should be available from VIDIOC_TRY_FMT.
>>
>> Yeah, I seem to have forgotten to add a note that this control would be
>> valid only on subdev nodes :/
>> OTOH, how do we handle cases where subdev's controls are inherited by
>> a video node ? Referring to an media bus pixel code seems wrong in that
>> cases.
> 
> I don't think this control ever should be visible on a video device if we
> define it's only valid for subdevs. Even then, if it's implemented by a
> subdev driver, its value refers to samples rather than bytes which would
> make more sense on a video node (in case we'd define it there).

I agree as for not exposing such a control on video nodes. We don't seem to
have support for that in v4l2-core though.

Hmm, not sure how would media bus data samples make sense on a video node,
where media bus is not quite defined at the user space API level.

> AFAIR Hans once suggested a flag to hide low-level controls from video nodes
> and inherit the rest from subdevs; I think that would be a valid use case
> for this flag. On the other hand, I see little or no meaningful use for

Yeah, sounds interesting.

> inheriting controls from subdevs on systems I'm the most familiar with, but
> it may be more useful elsewhere. Most of the subdev controls are not
> something a regular V4L2 application would like to touch as such; look at
> the image processing controls, for example.

Yeah, but in general controls can be inherited and there could be an 
ambiguity. Not all drivers involving subdevs use the subdev user space API.

>> Also for compressed formats, where this control is only needed, the bus
>> receivers/DMA just do transparent transfers, without actually modifying
>> the data stream.
> 
> That makes sense. I don't have the documentation in front of my eyes right
> now, but what would you think about adding a note to the documentation that
> the control is only valid for compressed formats? That would limit the
> defined use of it to cases we (or you) know well?

I think that could be done, all in all nobody ever needed such a control
for uncompressed/raw formats so far.

>> The problem is that ideally this V4L2_CID_FRAMESIZE control shouldn't be
>> exposed to user space. It might be useful, for example for checking what
>> would be resulting file size on a subdev modelling a JPEG encoder, etc.
>> I agree on video nodes ioctls like VIDIOC_[S/G/TRY]_FMT are just sufficient
>> for retrieving that information.
> 
> One case I could imagine where the user might want to touch the control is
> to modify the maximum size of the compressed images, should the hardware
> support that. But in that case, the user should be aware of how to convert
> samples into bytes, and I don't see a regular V4L2 application should
> necessarily be aware of something potentially as hardware-dependent as that.

Yes, V4L2_CID_FRAME_SIZE/SAMPLES looks like something only for a library
to play with. But for compressed formats conversion framesamples <-> data
octets in a memory buffer should be rather straightforward.
 
That said, V4L2_CID_FRAME_SAMPLES control would have been insufficient
where you want to query frame sizes for multiple logical streams within
a frame, e.g. multi-planar frame transmitted on MIPI-CSI2 bus with 
different data types and received on user space side as a multi-planar
v4l2 buffer. We would need to query a value for each plane and single 
control won't do the job in such cases. Hence I'm inclined to drop the 
idea of V4L2_CID_FRAME_SAMPLES control and carry on with the frame format 
descriptors approach. We probably can't/shouldn't have both solutions 
in use.

--

Regards,
Sylwester

