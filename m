Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2590 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3GWGrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 02:47:08 -0400
Message-ID: <51EE26DF.5000103@xs4all.nl>
Date: Tue, 23 Jul 2013 08:46:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Expected behavior for S_INPUT while streaming in progress?
References: <CAGoCfiyGJQFCrqaSW3da7YUjL7hEFvun0YgZr6vJL6pstu8q2g@mail.gmail.com>
In-Reply-To: <CAGoCfiyGJQFCrqaSW3da7YUjL7hEFvun0YgZr6vJL6pstu8q2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On 07/22/2013 09:48 PM, Devin Heitmueller wrote:
> Hello,
> 
> I'm doing some cleanup on the au8522 driver, and one thing I noticed
> was that you are actually allowed to issue an S_INPUT while streaming
> is active.  This seems like dangerous behavior, since it can result in
> things like the standard and/or resolution changing while the device
> is actively streaming video.
> 
> Should we be returning -EBUSY for S_INPUT if streaming is in progress?
>  I see cases in drivers where we prevent S_STD from working while
> streaming is in progress, but it seems like S_INPUT is a superset of
> S_STD (it typically happens earlier in the setup process).

Some drivers already return EBUSY for S_INPUT (ivtv). If the hardware
can't safely support it to switch inputs while streaming, then there
is no option but to return EBUSY.

Changing from one SDTV input to another SDTV input should not trigger
a change of standard, so that in itself should not be a cause for
blocking S_INPUT while streaming. Switching between e.g. a HDTV and
a SDTV input is a different matter: there the resolution really
changes and that should return an error while streaming.

> If we did do this, how badly do we think it would break existing
> applications?  It could require applications to do a STREAMOFF before
> setting the input (to handle the possibility that the call wasn't
> issued previously when an app was done with the device), which I
> suspect many applications aren't doing today.

Most drivers allow switching between e.g. the tuner and composite input
on the fly while streaming. Some don't like ivtv where the hardware can't
resync properly. I know there where problems with applications at the
time when I made that change in ivtv, but I haven't heard of it in a long
time, so applications may be fixed.

> Alternatively, we can based it on not just whether streamon was called
> and instead base it on the combination of streamon having been called
> and a filehandle actively doing streaming.  In this case case would
> return EBUSY if both conditions were met, but if only streamon was
> called but streaming wasn't actively being done by a filehandle, we
> would internally call streamoff and then change the input.  This would
> mean that if an application like tvtime were running, externally
> toggling the input would return EBUSY.  But if nothing was actively
> streaming via a /dev/videoX device then the call to set input would be
> successful (after internally stopping the stream).

This seems overkill. When dealing with SDTV inputs I would just
make sure that switching inputs will not change the standard, which is
a perfectly reasonable thing to do.

Regards,

	Hans
