Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1347 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3JLIAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 04:00:24 -0400
Message-ID: <52590184.5030806@xs4all.nl>
Date: Sat, 12 Oct 2013 10:00:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: John Sheu <sheu@google.com>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>, pawel@osciak.com
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP
 to encoder
References: <1381362589-32237-1-git-send-email-sheu@google.com> <1381362589-32237-4-git-send-email-sheu@google.com> <52564DE6.6090709@xs4all.nl> <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com> <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
In-Reply-To: <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/2013 01:48 AM, John Sheu wrote:
> On Wed, Oct 9, 2013 at 11:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> The main problem is that you use the wrong API: you need to use G/S_SELECTION instead
>> of G/S_CROP. S_CROP on an output video node doesn't crop, it composes. And if your
>> reaction is 'Huh?', then you're not alone. Which is why the selection API was added.
>>
>> The selection API can crop and compose for both capture and output nodes, and it
>> does what you expect.
> 
> 
> Happy to fix up the patch.  I'll just need some clarification on the
> terminology here.  So, as I understand it:
> 
> (I'll use "source"/"sink" to refer to the device's inputs/outputs,
> since "output" collides with the V4L2 concept of an OUTPUT device or
> OUTPUT queue).
> 
> In all cases, the crop boundary refers to the area in the source
> image; for a CAPTURE device, this is the (presumably analog) sensor,

Correct.

> and for an OUTPUT device, this is the memory buffer.

Correct.

> My particular
> case is a memory-to-memory device, with both CAPTURE and OUTPUT
> queues.  In this case, {G,S}_CROP on either the CAPTURE or OUTPUT
> queues should effect exactly the same operation: cropping on the
> source image, i.e. whatever image buffer I'm providing to the OUTPUT
> queue.

Incorrect.

S_CROP on an OUTPUT queue does the inverse: it refers to the area in
the sink image.

When the S_CROP API was designed a long time ago output devices were
very rare. Those that existed would output video to a S-Video or Composite
connector and often could scale the source image down to a particular
rectangle on the screen with the area outside of that rectangle either
having a fixed color or being a graphical picture.

The rectangle for the video on the output image was set by S_CROP, thus
effectively composing instead of cropping.

As the spec says (http://hverkuil.home.xs4all.nl/spec/media.html#crop):

"On a video output device the source are the images passed in by the
 application, and their size is again negotiated with the VIDIOC_G/S_FMT ioctls,
 or may be encoded in a compressed video stream. The target is the video signal,
 and the cropping ioctls determine the area where the images are inserted."

This was always confusing, but since there were so few output drivers it
was never that important. But when we started seeing many more output and
m2m drivers this became a real issue, in particular since S_CROP did only
half the operation (cropping for capture, composing for output) and was
missing composing for capture and "real" cropping for output.

> 
> The addition of {G,S}_SELECTION is to allow this same operation,
> except on the sink side this time.

No, it adds the compose operation for capture and the crop operation for
output, and it uses the terms 'cropping' and 'composing' correctly
without the inversion that S_CROP introduced on the output side.

> So, {G,S}_SELECTION setting the
> compose bounds on either the CAPTURE or OUTPUT queues should also
> effect exactly the same operation; cropping on the sink image, i.e.
> whatever memory buffer I'm providing to the CAPTURE queue.
> 
> Not sure what you mean by "S_CROP on an output video node doesn't
> crop, it composes", though.

I hope I explained it better this time.

Bottom line: S_CROP for capture is equivalent to S_SELECTION(V4L2_SEL_TGT_CROP).
S_CROP for output is equivalent to S_SELECTION(V4L2_SEL_TGT_COMPOSE).

Highly counter-intuitive, blame the original designers of the V4L2 API.

Regards,

	Hans
