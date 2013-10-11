Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63378 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3JKXsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 19:48:15 -0400
Received: by mail-qc0-f173.google.com with SMTP id l13so2581529qcy.4
        for <linux-media@vger.kernel.org>; Fri, 11 Oct 2013 16:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
	<1381362589-32237-4-git-send-email-sheu@google.com>
	<52564DE6.6090709@xs4all.nl>
	<CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
Date: Fri, 11 Oct 2013 16:48:14 -0700
Message-ID: <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
Subject: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP
 to encoder
From: John Sheu <sheu@google.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>, pawel@osciak.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 9, 2013 at 11:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> The main problem is that you use the wrong API: you need to use G/S_SELECTION instead
> of G/S_CROP. S_CROP on an output video node doesn't crop, it composes. And if your
> reaction is 'Huh?', then you're not alone. Which is why the selection API was added.
>
> The selection API can crop and compose for both capture and output nodes, and it
> does what you expect.


Happy to fix up the patch.  I'll just need some clarification on the
terminology here.  So, as I understand it:

(I'll use "source"/"sink" to refer to the device's inputs/outputs,
since "output" collides with the V4L2 concept of an OUTPUT device or
OUTPUT queue).

In all cases, the crop boundary refers to the area in the source
image; for a CAPTURE device, this is the (presumably analog) sensor,
and for an OUTPUT device, this is the memory buffer.  My particular
case is a memory-to-memory device, with both CAPTURE and OUTPUT
queues.  In this case, {G,S}_CROP on either the CAPTURE or OUTPUT
queues should effect exactly the same operation: cropping on the
source image, i.e. whatever image buffer I'm providing to the OUTPUT
queue.

The addition of {G,S}_SELECTION is to allow this same operation,
except on the sink side this time.  So, {G,S}_SELECTION setting the
compose bounds on either the CAPTURE or OUTPUT queues should also
effect exactly the same operation; cropping on the sink image, i.e.
whatever memory buffer I'm providing to the CAPTURE queue.

Not sure what you mean by "S_CROP on an output video node doesn't
crop, it composes", though.

Thanks,
-John Sheu
