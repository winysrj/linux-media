Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51110 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbbEBBc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 21:32:56 -0400
Message-ID: <55442943.2070304@gmx.net>
Date: Sat, 02 May 2015 03:32:51 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - Linux driver.
References: <55439450.1080206@shic.co.uk>
In-Reply-To: <55439450.1080206@shic.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/01/2015 04:57 PM, Steve wrote:
> Hi,
>
> I'm trying a direct mail to you as you are associated with this page:
>
>      http://linuxtv.org/wiki/index.php/DVB-S2_USB_Devices
>
> I have bought a Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone) - but
> it doesn't work with my 3.19 kernel, which I'd assumed it would from the
> above page.
>
> I've tried asking about the problem in various ways - first to "AskUbuntu":
>
> http://askubuntu.com/questions/613406/absent-frontend0-with-usb-dvbsky-s960-s860-driver-bug
>
>
> ... and, more recently, on the Linux-Media mailing list.  Without
> convincing myself that I've contacted the right person/people to give
> constructive feedback.
>
> By any chance can you offer me some advice about who it is best to
> approach?  (Obviously I'd also be grateful if you can shed any light on
> this problem.)
>
> Steve
>
>

Hi Steve,

The page actually states "Support in-kernel is expected in Linux kernel 
3.18.". Devil's advocate, but it doesn't say it's actually there or 
guarantees it ever will. At the time it was written, 3.18 wasn't out 
yet. Looking at your dmesg output however it seems your kernel is aware 
of the device. (so the patch made it) As for me, I was offered a bargain 
for another device so I have no S960.

Linux-media mailing list is the right place. (and here we are) A few 
quick suggestions:

Did you really, really, really get the right firmware and are you 
absolutely positive it's in the right location and has the right 
filename? Does dmesg mention the firmware being loaded?

Get/compile the latest v4l-dvb sources. 
(http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers) 
Maybe it's just a bug that has already been fixed.

Try another program to access the device. But if even lsusb hangs, this 
is pretty much moot.

Make sure the power supply/device is functioning properly. Try it on 
another OS to make sure it's not defective.

Try another computer, preferably with another chipset. If your RAM is 
faulty or you have a funky USB-controller, you can experience strange 
problems.

Good luck!

Best regards,

P. van Gaans
