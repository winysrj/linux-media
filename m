Return-path: <linux-media-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59952 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3I1SIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 14:08:14 -0400
Date: Sat, 28 Sep 2013 11:08:11 -0700
From: Marc MERLIN <marc@merlins.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Cannot shutdown power use from built in webcam in thinkpad T530 questions]
Message-ID: <20130928180811.GD3177@merlins.org>
References: <20130922193102.GA28515@merlins.org> <Pine.LNX.4.44L0.1309221623390.3257-100000@netrider.rowland.org> <20130922203622.GB28515@merlins.org> <523FFA03.7050404@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523FFA03.7050404@rempel-privat.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 23, 2013 at 10:21:23AM +0200, Oleksij Rempel wrote:
> > Understood, just making sure this was still potentially useful considering
> > what I found out since my last message.
> 
> Which version of powertop are you actually using? None of current

The latest, i.e. 2.4.

> versions would show you Watt usage for devices.

Sure it does :)

Summary: 3182.2 wakeups/second,  82.5 GPU ops/seconds, 0.0 VFS ops/sec and 33.5%

Power est.              Usage       Events/s    Category       Description
  9.82 W    100.0%                      Device         USB device: Yubico Yubike
  2.67 W      4.1 ms/s      43.2        Process        /usr/bin/pulseaudio --sta
  2.58 W    100.0%                      Device         USB device: Integrated Ca
  2.35 W    100.0%                      Device         USB device: BCM20702A0 (B
  2.32 W     32.9%                      Device         Display backlight
  1.39 W    100.0%                      Device         Radio device: btusb
  343 mW    100.0%                      Device         Radio device: thinkpad_ac

Now, I've found those values to be often wrong or questionable.

> you can use "watch grep . *" instead and check fallowing fields:
> runtime_suspended_time - suspend time. If it is growing device is suspended
> runtime_active_kids - if not zero, some program use it
> control - if "on" then autosuspend is disabled.

Understood.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
