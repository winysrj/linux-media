Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp12.wxs.nl ([195.121.247.24]:47585 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0F1Tuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 15:50:32 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L4Q007NWPRXVY@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Mon, 28 Jun 2010 21:50:31 +0200 (MEST)
Date: Mon, 28 Jun 2010 21:48:56 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: v4l-dvb unsupported device: Conceptronic CTVDIGUSB2 1b80:d393
 (Afatech) - possibly similar to CTVCTVDIGRCU v3.0?
In-reply-to: <AANLkTikojhopHeY2WuHxK_tbCs99_SV7ksWnYv4UXM4W@mail.gmail.com>
To: matteo sisti sette <matteosistisette@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4C28FCA8.5090005@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <AANLkTikojhopHeY2WuHxK_tbCs99_SV7ksWnYv4UXM4W@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matteo:

If I read this well, CTVDIGUSB2 1b80:d393 (Afatech) is not at all
similar to the CTVDIGRCU.
The CTVDIGRCU has a Realtek RTL2831U decoder, and is NOT included in the
standard dvb list.
Conceptronic just packages sticks from other vendors.
The fact that the device ID is recognized point towards the afatech
driver, and not the Realtek RTL2831U driver.

Fot background on the Realtek RTL2831U driver, see:

http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U

matteo sisti sette wrote:
> Hi,
> 
> I hope this is the right place for reporting this; if not, please
> forgive and redirect me.
> 
> My DVB-T USB stick, a "Conceptronic USB 2.0 Digital TV Receiver"
> CTVDIGUSB2 doesn't work after succesfully compiling and installing
> v4l-dvb, and it seems it is not supported according to the device
> list.
> 
> The ID is 1b80:d393
> 
> The name "Conceptronic USB 2.0" is very similar to that of CTVDIGRCU,
> which _is_ supported and the chipset seems to be indeed an Afatech as
> the output of lsusb reports:
> Bus 002 Device 007: ID 1b80:d393 Afatech
> (or isn't that reliable?)
> 
> So I wonder whether this is one of the cases where the following applies:
> "The driver has to be aware that it's related to some hardware
> (typically through the subsystem ID from the USB ID or PCI ID). If the
> driver doesn't recognize/bind to your particular hardware, then the
> module will probably load but then proceed to not do anything. In
> other words, support for your device would have to be added to the
> driver."
> 
> If I understand correctly (pleas correct me if I am wrong), IF that is
> the case (which may be not), then making it work should be just a
> matter of adding the id of the device to the source code of the driver
> somewhere and recompiling it and it would work??
> 
> If so, is it something I may try following some step-by-step guide?
> 
> Thanks
> m.
> 


-- 
Jan Hoogenraad


