Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:50071 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaJKPpa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 11:45:30 -0400
Date: Sat, 11 Oct 2014 17:45:25 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: JPT <j-p-t@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: technisat-usb2: i2c-error
Message-ID: <20141011174525.30fde69f@vdr>
In-Reply-To: <5437B048.4090100@gmx.net>
References: <5434226B.3010804@gmx.net>
	<20141009172614.5e16f240@vdr>
	<5437B048.4090100@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Oct 2014 12:09:12 +0200
JPT <j-p-t@gmx.net> wrote:

> Hi Patrick,
> 
> Am 09.10.2014 um 17:26 schrieb Patrick Boettcher:
> > Hi Jan,
> > 
> >> What exactly do the i2c-errors mean? 
> > 
> > I can't tell you exactly what happens in the device, but I can tell
> > you that I have the same problem with my device on my PC sometimes. 
> > 
> > In addition to this I2c-failures from time to time the box is quite
> > sensitive regarding: repowering, replugging and host-rebooting.
> > This is a USB-device-firmware problem which makes the device crash
> > and all subsequent USB-transfers are failed. Reloading the module
> > or replugging the device will make it work again.
> 
> That's bad news. Could you please add this info on the Wikipage?
> http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
> 
> > How many days without interruption did you use the device?
> 
> Well, this was about 2 days and 1.5 ;) recordings

Matches my experience.

> > I was following quietly you're discussion with Antti. Has someone
> > taken care of the your changes regarding the transfer-size?
> 
> No. Since I don't understand anything about what I did ;)

Could you resent the changes figured out by you and Antti ? (ideally in
a form of a patch).

> And I don't know the process of officially working on the kernel...
> (Just wondered if I will ever learn that much about kernel
> programming;)

There you can be helped: http://eudyptula-challenge.org/

> > I think it should included.
> 
> Then someone with more insight should change the buffers and create a
> patch. o.O

Create the patch, I will try it with my box and when it's ok after some
time we'll get it in.

regards,
-- 
Patrick.
