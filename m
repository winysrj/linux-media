Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57085 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab0ANTNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 14:13:36 -0500
Received: by fxm25 with SMTP id 25so398124fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 11:13:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <753580.52410.qm@web32707.mail.mud.yahoo.com>
References: <829197381001131404x48a8596arf16186e476d1744c@mail.gmail.com>
	 <753580.52410.qm@web32707.mail.mud.yahoo.com>
Date: Thu, 14 Jan 2010 14:13:35 -0500
Message-ID: <829197381001141113v695b2958q389ee152b8342ddf@mail.gmail.com>
Subject: Re: Kworld 315U and SAA7113?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Franklin Meng <fmeng2002@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 1:54 PM, Franklin Meng <fmeng2002@yahoo.com> wrote:
> Unfortunately, I do not know the difference.  I thought it might be to do something to the tuner but I am not quite sure.  If I remember correctly, the traces that I obtained also showed a difference between the analog modes.  I do know that if I leave the bit on it does not cause any adverse affects (other than maybe more power is being drawn)..

If there is no difference, it might make sense to just pick one.  If
you could measure the power draw though, you might gain some insight
regarding the difference.

> I might try leaving the GPIO pin high..  I had lots of issues switching between analog and digital modes so changing this bit may cause one or the other to not work.  For example if I leave both pins for the SAA/EM202 and the demod high, the analog doesn't seem to work correctly.  I'm guessing that there probably isn't enough power to keep both devices operational.  I'll try it out some more to see what happens.

You would obviously need to retest.  The cases where having the
digital GPIO do an actual reset were exposed when performing multiple
tuning attempts without closing the DVB device in between attempts.

> As far as I can tell, the Kworld 315U is the only board that uses this combination of parts..  Thomson tuner, LG demod, and SAA7113.  I don't think any other device has used the SAA7113 together with a digital demod.  Most products seem to only have the SAA711X on an analog only board.  Since I don't have any other USB adapters with the SAA chip I was unable to do any further testing on the SAA code changes.

I'm more worried about it interfering with other devices that use some
other bridge, regardless of whether that device has a demodulator.
Implementing power management on any chip is likely to expose bugs in
neighboring components like the bridge.

>>
>> Did you actually do any power analysis to confirm that the
>> suspend
>> functionality is working properly?
>
> Humm.. I did not actually do this.  Though, maybe I can figure this out by seeing how much power draw is on the USB bus.  I don't recall if there is a way to figure this out or not from within Linux.  I do remember Windows having such a feature..  I probably need to do a comparison between both OS's to make sure I get things are correct..  Is there a way to get information on how much power draw is happening on the USB bus in Linux?

I don't trust the operating system when it comes to that sort of
thing.  I cut up an old USB cable and put an ammeter in-line.  Has
helped alot in finding all sorts of power management bugs both in
drivers and in the v4l-dvb core.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
