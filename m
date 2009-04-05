Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:54578 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZDEMcp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 08:32:45 -0400
Message-ID: <49D8A58A.2070303@hhs.nl>
Date: Sun, 05 Apr 2009 14:35:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
References: <49D7C17B.80708@gmail.com> <49D87524.9050309@hhs.nl> <49D8955C.8030806@gmail.com>
In-Reply-To: <49D8955C.8030806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/2009 01:26 PM, Erik Andrén wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
>
> Hans de Goede wrote:
>> On 04/04/2009 10:22 PM, Erik Andrén wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> Hi,
>>>
>>> While trying to get hflip and vflip working for the stv06xx webcam
>>> bridge coupled to the vv6410 sensor I've come across the following
>>> problem.
>>>
>>> When flipping the image horizontally, vertically or both, the sensor
>>> pixel ordering changes. In the m5602 driver I was able to compensate
>>> for this in the bridge code. In the stv06xx I don't have this
>>> option. One way of solving this problem is by changing the
>>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>>> format. When a vertical flip is required, change the format to
>>> V4L2_SBGGR8.
>>>
>>> My current understanding of libv4l is that it probes the pixelformat
>>>     upon device open. In order for this to work we would need either
>>> poll the current pixelformat regularly or implement some kind of
>>> notification mechanism upon a flipping request.
>>>
>>> What do you think is this the right way to go or is there another
>>> alternative.
>>>
>> The changing of the pixelformat only happens when you flip the data
>> before conversion. If you look at the current upside down handling
>> code you will see it does the rotate 180 degrees after conversion.
>>
>> This is how the vflip / hflip should be handled too. We only have
>> 4 (2 really since we don't care about r versus b / u versus v while
>> flippiing) destination formats for which we then need to write flipping
>> code. Otherwise we need to write flipping code for *all* supported input
>> formats, not to mention flipping some input formats is close to impossible
>> (JPEG for example).
>>
>
> So you mean we should do the vflip/hflip in software, just exposing
> one native format?
>

Erm, yes that is what I was saying, but that is because I was confusing
things with the sq905 driver some other people are working on.

Now I understand what you were trying to ask. So the problem is that
the vv6410 sensor can do flipping in hardware, and then the order in
which it sends out the pixels changes from gbgbgb (for example)
to bgbgbg, for the lines which have blue, effectively changing the
pixelformat, right?

In that case I think the only solution is to simply return -EBUSY when
the vflip / hflip controls are changed while a stream is active.

As for the race window with one application querying the format (or even
setting it) and then another app changing the flip before the application
which just set the format starts the stream, we already have that wrt 2
applications doing this:
app a: setformat x
app b: setformat y
app a: start stream (thinking format is x)

Which is something which normally (luckily) never happens.

Does that sound like a plan ?

Note that this is a solution at the driver level, which IMHO is the only
way as we cannot assume libv4l is always being used.

Regards,

Hans
