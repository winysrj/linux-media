Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:48778 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZGTCcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 22:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <4A63D407.6090109@rtr.ca>
References: <4A631C8F.7000002@rtr.ca>
	 <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
	 <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>
	 <4A63A15F.8040804@rtr.ca>
	 <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
	 <4A63D407.6090109@rtr.ca>
Date: Sun, 19 Jul 2009 22:32:10 -0400
Message-ID: <829197380907191932p56391dedj660d2bfc941a53a8@mail.gmail.com>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
	branch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 10:18 PM, Mark Lord<lkml@rtr.ca> wrote:
> Devin Heitmueller wrote:
>>
>> Yeah, the situation with the seven second firmware load time is well
>> known.  It's actually a result of the i2c's implementation in the
>> au0828 hardware not properly supporting i2c clock stretching.  Because
>> of some bugs in the hardware, I have it clocked down to something like
>> 30KHz as a workaround.  I spent about a week investigating the i2c bus
>> issue with my logic analyzer, and had to move on to other things.  I
>> documented the gory details here back in March if you really care:
>
> ..
>
> From your livejournal comments, it sounded like the slow clock might
> not be necessary until *after* the firmware transfer.
>
> Mmm.. I wonder if perhaps a higher clock speed could be used
> during the firmware download, and then switch to the slower 30KHz
> speed afterward ?
>
> This could reduce the firmware transfer to a couple of seconds,
> much better than the current 6-7 second pause.

I did experiment with introducing a tuner callback to inform the
bridge to enter a high speed mode, which in theory would have allowed
the firmware load at 250Khz (and then revert to the slower speed after
the load finished).  However, for some unknown reason the tuner would
not work after the load.  I would see i2c errors on the bus when doing
the tune, and I was not able to identify the cause.

I spent a couple of nights playing with the idea, but didn't have more
time to spend on it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
