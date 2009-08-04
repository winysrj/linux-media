Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da06.mx.aol.com ([205.188.169.203]:57561 "EHLO
	imr-da06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZHDNVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 09:21:25 -0400
Message-ID: <4A783459.6040507@netscape.net>
Date: Tue, 04 Aug 2009 14:15:05 +0100
From: Kaya Saman <SamanKaya@netscape.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV usb 1 not working?
References: <4A782DC0.2080905@netscape.net> <829197380908040603l484a4c2el528fbeff937bc8b6@mail.gmail.com>
In-Reply-To: <829197380908040603l484a4c2el528fbeff937bc8b6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can indeed confirm what you are seeing. I tried out the device a
> few months ago and hit the same results. The maximum capture
> resolution is 320x200 so it won't work for tvtime, and I did hit
> intermittent segfaults with other apps.
>
> Note that zapping will not work since the device does not have an
> onboard tuner.  It only has composite and s-video inputs.
>
> The chipset in question does have support for 640x480, but the driver
> never had the support added.  The device is pretty ancient so I didn't
> have the time to invest in cleaning up all the bugs I found (and newer
> USB2 based devices are so cheap I didn't think it was worth the
> effort).
>
> Devin
>
>   
Hmm, ok that makes sense.

When you say that the device doesn't have an onboard tuner you mean that 
the machine that it's attached to does the tuning? My card has S-Video, 
RCA and Co-Ax inputs....

I think to be honest about the newer models that they are priced 
similarly?? I just checked dabs.com since I am in UK and they are round 
£50-70 which is what I paid for mine, although the £75 I did pay was 
only because I got it at the very expensive shop on my university campus 
back then!

Kaya


