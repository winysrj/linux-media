Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62391 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaJJKJ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 06:09:26 -0400
Message-ID: <5437B048.4090100@gmx.net>
Date: Fri, 10 Oct 2014 12:09:12 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@posteo.de>
CC: linux-media@vger.kernel.org
Subject: Re: technisat-usb2: i2c-error
References: <5434226B.3010804@gmx.net> <20141009172614.5e16f240@vdr>
In-Reply-To: <20141009172614.5e16f240@vdr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Am 09.10.2014 um 17:26 schrieb Patrick Boettcher:
> Hi Jan,
> 
>> What exactly do the i2c-errors mean? 
> 
> I can't tell you exactly what happens in the device, but I can tell you
> that I have the same problem with my device on my PC sometimes. 
> 
> In addition to this I2c-failures from time to time the box is quite
> sensitive regarding: repowering, replugging and host-rebooting. This is
> a USB-device-firmware problem which makes the device crash and all
> subsequent USB-transfers are failed. Reloading the module or replugging
> the device will make it work again.

That's bad news. Could you please add this info on the Wikipage?
http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD

> How many days without interruption did you use the device?

Well, this was about 2 days and 1.5 ;) recordings

It's now another 3 days. and there were only a few i2c errors, but
nothing serious.
I did only two SD recordings in the meantime. No problems yet.

I changed the watchdog from 60 secs to 10 mins.
I added a delay of 10 secs between unload and reload of the modules in
the runvdr script.
I hope the machine will be able to recover automatically next time.


> I was following quietly you're discussion with Antti. Has someone taken
> care of the your changes regarding the transfer-size?

No. Since I don't understand anything about what I did ;)
And I don't know the process of officially working on the kernel...
(Just wondered if I will ever learn that much about kernel programming;)

> I think it should included.

Then someone with more insight should change the buffers and create a
patch. o.O


Jan
