Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32707.mail.mud.yahoo.com ([68.142.207.251]:41874 "HELO
	web32707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751160Ab0ANSyf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 13:54:35 -0500
Message-ID: <753580.52410.qm@web32707.mail.mud.yahoo.com>
Date: Thu, 14 Jan 2010 10:54:33 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <829197381001131404x48a8596arf16186e476d1744c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin, 


> 
> This is pretty good stuff.  A few questions/comments
> about your patch:
> 
> The code has different GPIO configurations for the two
> analog modes.
> This is a bit unusual for an em28xx design.  Do you
> know what the
> difference is in terms of what GPIO7 controls?

Unfortunately, I do not know the difference.  I thought it might be to do something to the tuner but I am not quite sure.  If I remember correctly, the traces that I obtained also showed a difference between the analog modes.  I do know that if I leave the bit on it does not cause any adverse affects (other than maybe more power is being drawn)..

> 
> The digital GPIO block strobes GPO3 to reset the
> lgdt3303.  While I
> generally believe that it's good to explicitly strobe the
> reset low,
> this could cause problems with em28xx devices.  This
> is because the
> em28xx calls the digital GPIO whenever starting
> streaming.  Hence, you
> could end up with the chip being reset without the demod
> driver's
> init() routine being called, resulting in the chip's
> register state
> not being in sync with the driver's state info.  In
> fact, we have this
> issue with one of the Terratec boards where the zl10353
> driver state
> gets out of sync with the hardware (I still need to submit
> a patch
> upstream for that case).  Your code at this point
> should probably only
> ensure the 3303 is not in reset (by setting the GPIO pin
> high).
> 

I might try leaving the GPIO pin high..  I had lots of issues switching between analog and digital modes so changing this bit may cause one or the other to not work.  For example if I leave both pins for the SAA/EM202 and the demod high, the analog doesn't seem to work correctly.  I'm guessing that there probably isn't enough power to keep both devices operational.  I'll try it out some more to see what happens.  

> It's not surprising that you would uncover an issue with
> the suspend
> logic.  Despite the fact that the em28xx driver
> provides a suspend
> method it is not actually used today in any of the board
> profiles.

I saw it was available so I decided to use it.  I actually also implemented a suspend state for the AC97 chip (the EM202 I believe) though I wasn't fully happy with the code so I didn't include it this time around.

> 
> The saa7115 stuff looks pretty reasonable at first glance,
> although I
> am a bit worried about the possibility that it could cause
> a
> regression in other products that use that decoder.

As far as I can tell, the Kworld 315U is the only board that uses this combination of parts..  Thomson tuner, LG demod, and SAA7113.  I don't think any other device has used the SAA7113 together with a digital demod.  Most products seem to only have the SAA711X on an analog only board.  Since I don't have any other USB adapters with the SAA chip I was unable to do any further testing on the SAA code changes.  

> 
> Did you actually do any power analysis to confirm that the
> suspend
> functionality is working properly?

Humm.. I did not actually do this.  Though, maybe I can figure this out by seeing how much power draw is on the USB bus.  I don't recall if there is a way to figure this out or not from within Linux.  I do remember Windows having such a feature..  I probably need to do a comparison between both OS's to make sure I get things are correct..  Is there a way to get information on how much power draw is happening on the USB bus in Linux?

> 
> I agree with Mauro though that this should be split into
> multiple
> patches.  In fact, I would seriously consider three
> patches instead of
> two - the first patch adds the basic functionality to get
> the board
> working, the second adds the saa7115 code, and the third
> adds the
> suspend GPIO changes.  This will make it easier for
> others who have
> problems to isolate whether any problems are a basic issue
> with the
> board not working or whether it is related to the suspend
> and power
> management changes.
> 

Well basic functionality of the board is already included (digital only).  Douglas helped me get those changes in earlier.  I'll see if I can split up the patches better.

Last thing is that my responses may be kind of slow since I had a new addition to the family not too long ago. :)

Thanks,
Franklin 


      
