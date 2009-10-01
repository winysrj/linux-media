Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:40616 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZJAVm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 17:42:27 -0400
Date: Thu, 1 Oct 2009 16:42:24 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: How to make my device work with linux?
In-Reply-To: <c85228170910011414n29837812y28010ef0d97b7bf1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910011628420.21852@cnc.isely.net>
References: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>  <37219a840910011227r155d4bc1kc98935e3a52a4a17@mail.gmail.com> <c85228170910011414n29837812y28010ef0d97b7bf1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Oct 2009, Wellington Terumi Uemura wrote:

> I was looking around to find that there is a driver for that Fujitsu
> MB86A16 inside the "Linux Mantis Driver" project, Fujitsu MB86A16
> DVB-S/DSS DC Receiver driver made by Manu Abraham
> http://www.verbraak.org/wiki/index.php/Linux_Mantis_driver.
> 
> I've done a few tests with usbsnoop and other tools but USB sniffer
> doesn't see any valid command, jut a bunch of bytes that makes no
> sense:
> http://www.isely.net/pvrusb2/firmware.html#FX2

What you've pointed at here is a page that describes using a trick with 
the pvrusb2 driver to suck an image of the FX2 firmware out of the FX2 
processor itself.  That won't work in your case however since it 
requires that the pvrusb2 driver already be talking to the chip.  The 
procedure documented at that link is really about firmware extraction 
not reverse-engineering the data link protocol between the FX2 and the 
host.

> 
> I will try my luck compiling that Fujitsu driver, but my best guess is
> that without a proper I/O from that FX2 it will end up with nothing at
> all.

It's that data link protocol that you need to understand.  Please 
realize that the FX2 is "just" an 8051 microcontroller which happens to 
have a fairly interesting USB device interface resident on the same 
silicon.  Beyond that, the chip's behavior is really up to whatever the 
firmware does.  For pvrusb2-driven devices that firmware's behavior is 
pretty well understood.  That driver also benefits from the fact that 
essentially all USB hosted analog (and some hybrid) capture cards with 
an mpeg encoder and an FX2 all are derivations from a reference design 
by a single vendor.  That reference design included "reference 
firmware", which each manufacturer of course tweaked a bit.  For that 
reason, all those different devices tend to implement a similar enough 
data link protocol that the pvrusb2 driver can handle them all with the 
same implementation.

The problem is, we don't know if any of that is true for your device.  
You are dealing with a digital-only capture device so it can't be based 
on that same reference design.  It is entirely sensible that the FX2 
firmware was set up in that case with similar requirements in mind so 
the result *might* be similar in behavior.  But it really isn't known.  
So when you scan documentation for other drivers (e.g. pvrusb2) you must 
really look at it all with a rather large helping of scepticism.

Mike Krufky mentions a driver for the TDA18271 and he's right.  There is 
one - because the pvrusb2 driver also relies on that when driving an 
HVR-1950 capture device which happens to use that same part.  But that 
isn't "the" driver you need.  What you need is a bridge driver that can 
implement the host side of the data link protocol implemented by your 
device's FX2.  That is what the pvrusb2 driver does for the capture 
devices it handles.  With the proper bridge driver set up, then the 
TDA18271 sub-device driver can ride over that data link to establish 
communications with its hardware in the device.  THEN you'll be on the 
way to having something working.

I know that none of the about is the answer you're looking for.  But 
perhaps it will lead you in the right direction.  It is entirely 
possible that there is another bridge driver out there which can handle 
this part, but I can't help you there.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
