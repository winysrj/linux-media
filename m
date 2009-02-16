Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3748 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbZBPOAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 09:00:51 -0500
Message-ID: <42583.62.70.2.252.1234792848.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Feb 2009 15:00:48 +0100 (CET)
Subject: Re: Adding a control for Sensor Orientation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Olivier Lorin" <o.lorin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> If you want to add two bits with
>> mount information, feel free. But don't abuse them for pivot
>> information.
>> If you want that, then add another two bits for the rotation:
>>
>> #define V4L2_BUF_FLAG_VFLIP     0x0400
>> #define V4L2_BUF_FLAG_HFLIP     0x0800
>>
>> #define V4L2_BUF_FLAG_PIVOT_0   0x0000
>> #define V4L2_BUF_FLAG_PIVOT_90  0x1000
>> #define V4L2_BUF_FLAG_PIVOT_180 0x2000
>> #define V4L2_BUF_FLAG_PIVOT_270 0x3000
>> #define V4L2_BUF_FLAG_PIVOT_MSK 0x3000
>>
>
> Ok, this seems good. But if we want to distinguish between static sensor
> mount
> information, and dynamic sensor orientation changing due to pivotting,
> then I
> think we should only put the pivot flags in the buffer flags, and the
> static
> flags should be in the VIDIOC_QUERYCAP capabilities flag, what do you
> think of
> that?

That's for driver global information. This type of information is
input-specific (e.g. input 1 might be from an S-Video input and does not
require v/hflip, and input 2 is from a sensor and does require v/hflip).
So struct v4l2_input seems a good place for it.

Looking at v4l2_input there is a status field, but the status information
is valid for the current input only. We can:

1) add flags here and only set the mounting information for the current
input,

2) add flags here and document that these flags are valid for any input,
not just the current, or:

3) take one of the reserved fields and turn that into a 'flags' field that
can be used for static info about the input.

To be honest, I prefer 3.

The same can be done for v4l2_output should it become necessary in the
future.

Actually, pivot information could be stored here as well. Doing that makes
it possible to obtain the orientation without needing to start a capture,
and makes it possible to be used (although awkwardly) with the read()
interface.

You still want to report this information in v4l2_buffer as well since it
can change on the fly.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

