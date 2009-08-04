Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:50681 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbZHDNDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 09:03:13 -0400
Received: by ywh7 with SMTP id 7so5054076ywh.21
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 06:03:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A782DC0.2080905@netscape.net>
References: <4A782DC0.2080905@netscape.net>
Date: Tue, 4 Aug 2009 09:03:12 -0400
Message-ID: <829197380908040603l484a4c2el528fbeff937bc8b6@mail.gmail.com>
Subject: Re: Hauppauge WinTV usb 1 not working?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Kaya Saman <SamanKaya@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 4, 2009 at 8:46 AM, Kaya Saman<SamanKaya@netscape.net> wrote:
> Hi,
>
> I hope I'm in the right place!!
>
> I have a Hauppauge WinTV usb 1.1 tuner but I don't seem to be able to get it
> working.
>
> I am running Kubuntu 9.04 64-bit edition.
>
> The tuner detects in the kernel as:
> Bus 006 Device 002: ID 0573:4d22 Zoran Co. Personal Media Division
> (Nogatech) Hauppauge WinTV-USB II (PAL) Model 566
>
> Using the USBVision driver.
>
> In the kernel using dmesg the tuner is detected as a WinTV Pro??
>
> I have tried various apps to watch tv including tvtime, xawtv, and Zapping.
>
> Running tvtime-scanner gives this output:
>
> Reading configuration from /etc/tvtime/tvtime.xml
> Reading configuration from /home/kaya/.tvtime/tvtime.xml
> Scanning using TV standard PAL.
> /home/kaya/.tvtime/stationlist.xml: No existing PAL station list "Custom".
>
>  Your capture card driver: USBVision [Hauppauge WinTV USB Pro (PAL
> I)/6-2/2313]
>  does not support full size studio-quality images required by tvtime.
>  This is true for many low-quality webcams.  Please select a
>  different video device for tvtime to use with the command line
>  option --device.
>
> And xawtv and zapping seg fault each time I run them....??
>
> I have an ancient Hauppauge WinTV/Radio PCI card which uses the bttv driver
> and xawtv works fine on it so I'm not sure why this one isn't working.
>
> Can anyone help at all or suggest something??
>
> Many thanks,
>
> Kaya

I can indeed confirm what you are seeing.  I tried out the device a
few months ago and hit the same results. The maximum capture
resolution is 320x200 so it won't work for tvtime, and I did hit
intermittent segfaults with other apps.

Note that zapping will not work since the device does not have an
onboard tuner.  It only has composite and s-video inputs.

The chipset in question does have support for 640x480, but the driver
never had the support added.  The device is pretty ancient so I didn't
have the time to invest in cleaning up all the bugs I found (and newer
USB2 based devices are so cheap I didn't think it was worth the
effort).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
