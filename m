Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:38114 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3JLJI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 05:08:56 -0400
Received: by mail-qe0-f50.google.com with SMTP id 1so1643877qee.37
        for <linux-media@vger.kernel.org>; Sat, 12 Oct 2013 02:08:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52590184.5030806@xs4all.nl>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
	<1381362589-32237-4-git-send-email-sheu@google.com>
	<52564DE6.6090709@xs4all.nl>
	<CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
	<CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
	<52590184.5030806@xs4all.nl>
Date: Sat, 12 Oct 2013 02:08:55 -0700
Message-ID: <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for
 VIDIOC_{G,S}_CROP to encoder
From: John Sheu <sheu@google.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>, pawel@osciak.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I thought you were not making sense for a bit.  Then I walked away,
came back, and I think you're making sense now.  So:

* Crop always refers to the source image
* Compose always refers to the destination image

On Sat, Oct 12, 2013 at 1:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 10/12/2013 01:48 AM, John Sheu wrote:
>> On Wed, Oct 9, 2013 at 11:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> In all cases, the crop boundary refers to the area in the source
>> image; for a CAPTURE device, this is the (presumably analog) sensor,
>
> Correct.
>
>> and for an OUTPUT device, this is the memory buffer.
>
> Correct.

Here you are referring to the crop boundary, which is _not_ always
what {G,S}_CROP refers to.  (Confusing part).  {G,S}_CROP refers to
the crop boundary only for a CAPTURE queue.

>> My particular
>> case is a memory-to-memory device, with both CAPTURE and OUTPUT
>> queues.  In this case, {G,S}_CROP on either the CAPTURE or OUTPUT
>> queues should effect exactly the same operation: cropping on the
>> source image, i.e. whatever image buffer I'm providing to the OUTPUT
>> queue.
>
> Incorrect.
>
> S_CROP on an OUTPUT queue does the inverse: it refers to the area in
> the sink image.

This confused me for a bit (seeming contradiction with the above),
until I realized that you're referring to the S_CROP ioctl here, which
is _not_ the "crop boundary"; on an OUTPUT queue it refers to the
compose boundary.

> No, it adds the compose operation for capture and the crop operation for
> output, and it uses the terms 'cropping' and 'composing' correctly
> without the inversion that S_CROP introduced on the output side.
>
> Bottom line: S_CROP for capture is equivalent to S_SELECTION(V4L2_SEL_TGT_CROP).
> S_CROP for output is equivalent to S_SELECTION(V4L2_SEL_TGT_COMPOSE).

So yes.  By adding the {G,S}_SELECTION ioctls we can now refer to the
compose boundary for CAPTURE, and crop boundary for OUTPUT.


Now, here's a question.  It seems that for a mem2mem device, since
{G,S}_CROP on the CAPTURE queue covers the crop boundary, and
{G,S}_CROP on the OUTPUT queue capture the compose boundary, is there
any missing functionality that {G,S}_SELECTION is covering here.  In
other words: for a mem2mem device, the crop and compose boundaries
should be identical for the CAPTURE and OUTPUT queues?

-John Sheu
