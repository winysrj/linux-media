Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38304 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbaI1T5q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 15:57:46 -0400
Date: Sun, 28 Sep 2014 16:57:41 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: em28xx: Too many ISO frames scheduled when starting stream
Message-ID: <20140928165741.47a19ddc@recife.lan>
In-Reply-To: <54284FE7.5090805@iki.fi>
References: <54284488.60404@iki.fi>
	<54284FE7.5090805@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Sep 2014 21:13:59 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/28/2014 08:25 PM, Antti Palosaari wrote:
> > I want raise that bug:
> > Too many ISO frames scheduled when starting stream
> > https://bugzilla.kernel.org/show_bug.cgi?id=72891
> >
> > Is there anyone who cares to study it? It looks like em28xx driver bug
> > or USB host controller driver or both.
> >
> > According to comments bug appeared on kernel 3.13.
> 
> em28xx didn't even get any notable changes at that time... I looked all 
> the 3.13 em28xx patches and there is no patch that could cause issues 
> listed. So root of cause is somewhere else or there is reports which has 
> kernel with media_build installed.
> Also, em28xx uses ISOC to data transferred, whilst most devices are 
> using BULK. No other reports from other ISOC DVB devices so far though. 
> I suspect it may be some compatibility issue with em28xx chip / em28xx 
> driver / USB stack / USB host controller.
> 
> There were em28xx patches went to 3.13 (stable patches not included):
> bdee6bd [media] em28xx-video: Swap release order to avoid lock nesting
> 6dbea9f [media] Add support for KWorld UB435-Q V2
> be353fa [media] V4L2: em28xx: tell the ov2640 driver to balance clock 
> enabling internally
> fc5d0f8 [media] V4L2: em28xx: register a V4L2 clock source
> 032f1dd [media] em28xx: fix error path in em28xx_start_analog_streaming()
> b68cafc [media] em28xx: fix and unify the coding style of the GPIO 
> register write sequences
> de0fc46 [media] em28xx: MaxMedia UB425-TC change demod settings
> b6c7abb [media] em28xx: MaxMedia UB425-TC switch RF tuner driver to another
> 8d100b2 [media] em28xx: MaxMedia UB425-TC offer firmware for demodulator

None of the above patches seem to be related. Also, I use a lot em28xx
here without any issues on an eHCI USB port. Even on a xHCI USB port,
I was unable to reproduce this bug with just one em28xx device plugged.

I _suspect_ that this issue is related to ISOC transfers, and the
return code is EFBIG.

The EFBIG return code happens if there's not enough space in a given
USB bus to reserve traffic for ISOC transfers when submitting the
URBs. Changing the URB size helps to reduce the amount of ISOC
transfers, making more unlikely for this bug to happen. However, the
em28xx driver already tries to use the max supported size, using the
USB descriptors.

There's one easy way to reproduce it: plug two em28xx devices with
analog TV and try to start both. The first analog TV stream will
allocate about 60% of the bus traffic, and the Kernel will return
EFBIG when trying to stream at the second one.

That's said, on a USB bus where there's just one device connected,
this error shouldn't happen, especially for DVB, where the bandwidth
requirements are generally lower.

It used to be possible to check how much was allocated for ISOC
traffic via:

# cat /sys/kernel/debug/usb/devices 

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=5000 MxCh= 1
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
P:  Vendor=1d6b ProdID=0003 Rev= 3.17
S:  Manufacturer=Linux 3.17.0-rc6+ xhci_hcd
S:  Product=xHCI Host Controller
S:  SerialNumber=0000:00:14.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

The "Alloc" above would indicate how many slots were allocated.
However, at least here on an Atom NUC I'm testing and latest
upstream Kernel + media patches, no matter if I start some traffic
or not there, it still shows 0/800. It seems that there's a bug
somewhere on the USB stack that it is preventing it to show.

In any case, the return of EFBIG doesn't imply that there's a bug at
em28xx driver or at the usb stack. It is just an indication that the
bus has reached its maximum hardware capacity.

That's said, I was never ever be able to get EFBIG when there's
just one isoc device connected into an USB bus. Not sure if
this is the case of the reporter of BZ#72891.

I suggest you to double check if this is the only one device
connected at the bus that could be using ISOC traffic.

If there's just one device connected, and no other weird setup
(like trying to run the driver inside a VM, or some USB hubs
connected internally or externally), then we should seek for this
bug at the USB stack.

Btw, Hans de Goede faced with this issue a lot with his works with
gspca. I think he sent some patches to the USB stack to try to
reduce the changes of this error to happen.

Another possibility is that maybe the USB descriptors are broken
on some versions of the silicon, with makes the USB core to return
such error because em28xx is overriding the physical limits due to
a bad descriptor at the device's ROM. Never saw this on em28xx,
but I have some other USB devices with bad descriptors.

I hope that helps.

Regards,
Mauro
