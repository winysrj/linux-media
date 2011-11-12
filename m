Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33610 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1KLOSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 09:18:02 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so5204668iag.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 06:18:02 -0800 (PST)
Message-ID: <4EBE8018.6010005@gmail.com>
Date: Sat, 12 Nov 2011 08:18:00 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Rory McCann <rory@technomancy.org>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Any update on the Hauppauge WinTV-HVR-900H?
References: <4EBE73F4.4080002@technomancy.org>
In-Reply-To: <4EBE73F4.4080002@technomancy.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 07:26 AM, Rory McCann wrote:
> Hi,
> 
> I recently bought a Hauppauge WinTV-HVR-900H (usb id: 2040:b138), but I
> see from this wiki page
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-900H that there is
> no driver for it. However that's as of 2008.
> 
> Has there been any progress on this since? Is that wiki page correct
> that there is still no support for that card? Is there anyway to get
> this USB device to work under linux?
> 
> Thanks,
> 

Hi Rory,

If you search for the 900H, you'll find a thread titled "Hauppauge
HVR900H don't work with kernel 3.*". The original submitter stated that
it worked in 2.6.x, but when the computer was upgraded to a 3.x kernel,
it stopped working.  This was two days ago (9 November 2011), so I'm not
sure how much progress was made (if any).

So, if your running a 2.6.x kernel, it *may* work, but it seems to be
broken on the 3.x kernels (Ubuntu 11.10 or similar distros).
Unfortunately I don't have that tuner, so I can't help out with it.

I would say try it. You can check dmesg to see if the tuner is even
being recognized (and drivers loaded). If so, then see if it works. If
not, then you might need the latest build of the v4l. You can get
information on installing the latest version from
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
.  Then make it (without your tuner plugged in) and try plugging it in
again. Check dmesg again, and if it's recognized, try it.

Sorry I couldn't find more information on this. Also if anyone else
posts a reply, I would defer to their suggestions--as they have more
experience with this than me.

Have a good weekend.:)
Patrick.
