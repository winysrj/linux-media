Return-path: <linux-media-owner@vger.kernel.org>
Received: from server50105.uk2net.com ([83.170.97.106]:44074 "EHLO
	mail.autotrain.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbZGBNuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 09:50:00 -0400
Date: Thu, 2 Jul 2009 14:50:02 +0100 (BST)
From: Tim Williams <tmw@autotrain.org>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USBVision device defaults
In-Reply-To: <1246495183.4227.77.camel@palomino.walls.org>
Message-ID: <alpine.LRH.2.00.0907021419270.988@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>  <1246275235.3917.12.camel@palomino.walls.org>  <alpine.LRH.2.00.0906291303170.29847@server50105.uk2net.com> <1246495183.4227.77.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Jul 2009, Andy Walls wrote:

> It's unclear to me if the PowerOnAtOpen module parameter works properly
> when set to 0.  It might actually prevent the automatic shutoff in 3
> seconds if set to zero.

I hadn't spotted that option, it does seem to work and enables the device 
to stay active after the programme using it has exited, preserving the 
settings. With PowerOnAtOpen=0, using the normal unmodified driver, I can't 
get a picture using either flash or kdetv. However, using my bodged driver 
which forces use of the SVideo input, I can now get a colour picture in 
flash by starting and exiting kdetv first. Odd, but it does at least 
provide a workable solution to my problem.

> Also, by inspection I think the driver has a bug you may be able to
> exploit.  If you already have the driver open with an application,
> trying to open it with another application will fail, but not before
> reseting the poweroff timer back to three seconds.  So if you have an
> app that attempts to open() and close() the usbvision device node every
> 1 second, I think you can keep it from powering down and losing it's
> settings.
>
> Here's a useless little program to do just that.  Compile it and invoke
> it as 'program-name /dev/video0'

I gave the code a try, it works up to a point, I get a colour picture in 
flash, but the picture is frozen. I suspect your programme is grabbing 
the video device back from flash before I can kill it.

Thankyou for your help ! If anybody on this list decides to try and neaten 
up the code for the usbvision driver, I'm happy to do a bit of testing 
work (contant me on tmw@autotrain.org, I may not stay subscribed to this 
email list permanantly).

Tim W

-- 
Tim Williams BSc MSc MBCS
Euromotor Autotrain LLP
58 Jacoby Place
Priory Road
Edgbaston
Birmingham
B5 7UW
United Kingdom

Web : http://www.autotrain.org
Tel : +44 (0)121 414 2214

EuroMotor-AutoTrain is a company registered in the UK, Registration
number: OC317070.
