Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1A2VMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 16:12:12 -0500
Received: by ewy5 with SMTP id 5so2011602ewy.19
        for <linux-media@vger.kernel.org>; Sat, 29 Jan 2011 13:12:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=D4GOqJB+9CS1xZGAc4vs3WPM5S=GQwm8PK2Sa@mail.gmail.com>
References: <AANLkTi=D4GOqJB+9CS1xZGAc4vs3WPM5S=GQwm8PK2Sa@mail.gmail.com>
Date: Sat, 29 Jan 2011 16:12:10 -0500
Message-ID: <AANLkTik3AdkKpL6wza3rG92E0pv=Y2StP1ZBppO8=HzV@mail.gmail.com>
Subject: Re: HVR1255 svideo
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jon Goldberg <jond578@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jan 29, 2011 at 1:53 PM, Jon Goldberg <jond578@gmail.com> wrote:
> Hi
>
> I've been trying to get the Svideo input on my HVR-1255 working.  From
> the latest code in cx23885-cards.c, it seems that only DVB is
> supported.  I have some experience writing Linux Kernel/Drivers so I'm
> determined to get this working.
>
> I copied the cx23885_boards[CX23885_BOARD_HAUPPAUGE_HVR1250] settings
> and did get the V4L layer connected enough to get a /dev/video0,
> albeit with only green video and no picture.  I then realized that was
> probably a dumb thing to do (possibly damaging the GPIO), since the
> eeprom is clearly different based on what I saw in tveeprom.c.
>
> My question is, am I going down the right path to add this support?
> Should I go ahead and install Windows (sigh) and get the output from
> RegSpy?  Are there any developer git trees that are focused on this
> area?

Steven did a bunch of analog work on the cx23885, although I do not
believe he brought up the 1255 specifically.  I would definitely look
at his tree as a starting point (if for no other reason than he's the
cx23885 maintainer and will have to ACK any patches you send):

https://www.kernellabs.com/hg/~stoth/cx23885-mpx/

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
