Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:50629 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab0AMWEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 17:04:02 -0500
Received: by fxm25 with SMTP id 25so712356fxm.21
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 14:04:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <430160.90047.qm@web32702.mail.mud.yahoo.com>
References: <430160.90047.qm@web32702.mail.mud.yahoo.com>
Date: Wed, 13 Jan 2010 17:04:00 -0500
Message-ID: <829197381001131404x48a8596arf16186e476d1744c@mail.gmail.com>
Subject: Re: Kworld 315U and SAA7113?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Franklin Meng <fmeng2002@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 9, 2010 at 2:30 PM, Franklin Meng <fmeng2002@yahoo.com> wrote:
> I tweaked the GPIO's a bit more for the Kworld 315U and switching between analog and digital signals is more reliable now.  Attached is an updated diff.

Hello Franklin,

This is pretty good stuff.  A few questions/comments about your patch:

The code has different GPIO configurations for the two analog modes.
This is a bit unusual for an em28xx design.  Do you know what the
difference is in terms of what GPIO7 controls?

The digital GPIO block strobes GPO3 to reset the lgdt3303.  While I
generally believe that it's good to explicitly strobe the reset low,
this could cause problems with em28xx devices.  This is because the
em28xx calls the digital GPIO whenever starting streaming.  Hence, you
could end up with the chip being reset without the demod driver's
init() routine being called, resulting in the chip's register state
not being in sync with the driver's state info.  In fact, we have this
issue with one of the Terratec boards where the zl10353 driver state
gets out of sync with the hardware (I still need to submit a patch
upstream for that case).  Your code at this point should probably only
ensure the 3303 is not in reset (by setting the GPIO pin high).

It's not surprising that you would uncover an issue with the suspend
logic.  Despite the fact that the em28xx driver provides a suspend
method it is not actually used today in any of the board profiles.

The saa7115 stuff looks pretty reasonable at first glance, although I
am a bit worried about the possibility that it could cause a
regression in other products that use that decoder.

Did you actually do any power analysis to confirm that the suspend
functionality is working properly?

I agree with Mauro though that this should be split into multiple
patches.  In fact, I would seriously consider three patches instead of
two - the first patch adds the basic functionality to get the board
working, the second adds the saa7115 code, and the third adds the
suspend GPIO changes.  This will make it easier for others who have
problems to isolate whether any problems are a basic issue with the
board not working or whether it is related to the suspend and power
management changes.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
