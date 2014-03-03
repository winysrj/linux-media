Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36083 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaCCU1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 15:27:23 -0500
Received: by mail-qa0-f42.google.com with SMTP id k15so4048317qaq.29
        for <linux-media@vger.kernel.org>; Mon, 03 Mar 2014 12:27:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53149518.3060609@xs4all.nl>
References: <53149518.3060609@xs4all.nl>
Date: Mon, 3 Mar 2014 15:27:21 -0500
Message-ID: <CAGoCfizza3gFwpOqF5rKfcEe+YV9L0WkSuBda4Fzs=y8r5vo=w@mail.gmail.com>
Subject: Re: V4L2 and frames vs fields
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> For field formats where both fields are used the spec is reasonably clear. The
> v4l2_format height field refers to the full frame height (combining both fields).

No dispute here.

> For the TOP/BOTTOM/ALTERNATE setting the format's height refers to that of the
> field, not the frame. So the resulting buffer size is still height * bytesperline.

What is the assertion based on?  Looking at different drivers (and if
so, which ones)?  Looking at different userland apps (and if so which
one)?  Somewhere in the spec?

> Drivers can use several strategies on how to handle this:
>
> Some support only one field setting: INTERLACED if height > frameheight / 2 and
> TOP if height <= frameheight / 2. In this case the application cannot change the
> field, it is set by the driver based on the height chosen by the application.

So you're saying that an app says I want V4L2_FIELD_INTERLACED with a
height of 320x240, and the driver will change the field type to
V4L2_FIELD_TOP in the response to the S_FMT call?

> The reverse is also possible: the driver allows you to change the field but not
> the height. So INTERLACED will give a height of 576 and TOP a height of 288.
>
> If there is a hardware scaler as well, then changing the field setting must not
> change the format's height, instead the scaler is adjusted. So if the height
> is 576 and the field is TOP, then the image will be scaled up by a factor of 2.

Are you making a general statement about what you think should be the
desired behavior, or citing what some particular driver does?

> If there are limitations in what the scaler can do (say it can only downscale)
> then it depends on the height which field values are honored. So attempts to
> set FIELD_TOP if the height is 576 and only a downscaler is available should
> result in FIELD_INTERLACE and an unchanged height. Only at heights <= 288 will
> the FIELD_TOP setting work.
>
> When implementing FIELD_ANY drivers can choose to select FIELD_TOP (or BOTTOM)
> if the height <= frameheight / 2 instead of FIELD_INTERLACED.
>
> The description of FIELD_ALTERNATE in the spec has this phrase: "Image sizes
> refer to the frame, not fields." That seems nonsense to me and none of the
> drivers that support FIELD_ALTERNATE does that. If any of FIELD_TOP, BOTTOM
> or ALTERNATE is selected the width, height and sizeimage fields all relate
> to the size of a (possibly scaled) field.
>
> I plan on updating the spec, but I'd like to run this by you all to see if
> I missed anything or got it wrong after all.

This all looks like a pretty big mess, so I'm really wondering who is
actually using any of this functionality (both on the driver and
application side).  If we can't find any apps that actually use any of
this functionality, and the behavior is undefined in the spec, then it
might make sense to decide on what is the "right" approach and then
make the drivers conform rather than trying to figure out what
approach is taken by the most drivers and then updating the spec to
reflect that.

I can appreciate there's a good bit of extra complexity here as a
result of how different chipsets implement their video pipeline and
scaler.  The specific use case *I* care about is that I've got 720x480
NTSC video coming in and I'm rendering it to a small LCD.  I want to
be able to throw away the bottom field since the LCD is smaller than
240 high and this allows me to not require any deinterlacing (simply
rescaling the video to 320x240 using the hardware scaler won't solve
the problem since I'll still get interlaced video, just 120 lines of
the top field and 120 of the bottom).

I suspect at least some of the cases that prompted the creation of
these different field formats is similar, while others such as
ALTERNATE are a result of really old hardware that cannot report which
field it is returning.  I also suspect many of the drivers have code
that implements support for some of these formats not because somebody
needed it but rather because the code was copied from some other
driver (and may not even actually work).

If nothing else, it would be very helpful if you could make more clear
which of the statements you made above are the result of
interpretation of the spec, evaluation of some of the current drivers
which claim to support these field types, or what you think the
correct behavior *should* be independent of how various drivers do it
today.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
