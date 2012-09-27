Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56546 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2I0NUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 09:20:23 -0400
Received: by bkcjk13 with SMTP id jk13so1764769bkc.19
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 06:20:21 -0700 (PDT)
Message-ID: <50645295.1090609@googlemail.com>
Date: Thu, 27 Sep 2012 15:20:21 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com> <506429D1.4090401@redhat.com>
In-Reply-To: <506429D1.4090401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 27.09.2012 12:26, schrieb Hans de Goede:
> Hi,
>
> On 09/26/2012 11:04 PM, Frank Schäfer wrote:
>> Hi,
>>
>> I've noticed the following issues/bugs while playing with qv4l:
>> 1.) with pac7302-webcams, only the RGB3 (RGB24) format is working. BGR3,
>> YU12 and YV12 are broken
>> 2.) for upside-down-mounted devices with an entry in libv4lconvert,
>> automatic h/v-flipping doesn't work with some formats
>>
>> I've been digging a bit deeper into the code and it seems that both
>> issues are caused by a problem with the libv4lconvert-API:
>> Besides image format conversion, function v4lconvert_convert() also does
>> the automatic image flipping and rotation (for devices with flags
>> V4LCONTROL_HFLIPPED, V4LCONTROL_VFLIPPED and V4LCONTROL_ROTATED_90_JPEG)
>> The problem is, that this function can be called multiple times for the
>> same frame, which then of course results in repeated flipping and
>> rotation...
>>
>> And this is exactly what happens with qv4l2:
>> qv4l2 gets the frame from libv4l2, which calls v4lconvert_convert() in
>> v4l2_dequeue_and_convert() or v4l2_read_and_convert().
>> The retrieved frame has the requested format and is already
>> flipped/rotated.
>> qv4l2 then calls v4lconvert_convert() again directly to convert the
>> frame to RGB24 for GUI-output and this is where things are going wrong.
>> In case of h/v-flip, the double conversion "only" equalizes the
>> V4LCONTROL_HFLIPPED, V4LCONTROL_VFLIPPED flags, but for rotated devices,
>> the image gets corrupted.
>>
>> Sure, what qv4l2 does is a crazy. Applications usually request the
>> format needed for GUI-output directly from libv4l2.
>> Anyway, as long as it is valid to call libv4lconvert directly, we can
>> not assume that v4lconvert_convert() is called only one time.
>>
>> At the moment, I see no possibility to fix this without changing the
>> libv4lconvert-API.
>> Thoughts ?
>
> What you've found is a qv4l2 bug (do you have the latest version?)

Of course, I'm using the latest developer version.

Even if this is just a qv4l2-bug: how do you want to fix it without
removing the format selction feature ?

> one
> is supposed to either use libv4l2, or do raw device access and then
> call libv4lconvert directly.

Even when using libv4lconvert only, multiple frame conversions are still
causing the same trouble.

Hans, first of all, I would like to say that my intention is not to
savage your work.
I know API design and maintanance is very difficult and you are doing a
great job.
Things like this just happen and we have to make the best out of it.

But saying that libv4l2 and libv4lconvert can't be used at the same
(although they are separate public libraries) and that
v4lconvert_convert() may only be called once per frame seems to me like
a - I would say "weird" - reinterpretation of the API...
I don't think this is what applications currently expect (qv4l2 doesn't
;) ) and at least this would need public clarification.

So let's see if there is a possibility to fix the issue by improving the
libraries without breaking the API.

What about the following solution:
- make v4lconvert_convert_pixfmt() and v4lconvert_crop() public
functions and fix qv4l2 to use them instead of v4lconvert_convert()
- also make the flip and rotation functions (v4lconvert_flip(),
v4lconvert_rotate90()) publicly available
- modify libv4l2 to call v4lconvert_convert_pixfmt() and the
flip+rotation+crop functions instead of v4lconvert_convert()
- fix v4lconvert_convert() to not do transparent image flipping/rotation
(means => call v4lconvert_convert_pixfmt() and v4lconvert_crop() only).
For API-clean-up:
- create a copy of (the fixed) v4lconvert_convert() called something
like v4lconvert_convert_crop()
- declare v4lconvert_convert() as deprecated so that we can remove it
sometime in the future

What do you think ?

Regards,
Frank



> These are also the 2 modes qv4l2 has
> (for testing purposes), it is not supposed to do the manual convert call
> when using libv4l2 to access the device ...
>
> Regards,
>
> Hans

