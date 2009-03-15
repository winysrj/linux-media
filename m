Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:23721 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZCORxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 13:53:24 -0400
Date: Sun, 15 Mar 2009 18:53:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090315185313.4c15702c@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 10:42:41 -0700 (PDT), Trent Piepho wrote:
> On Sun, 15 Mar 2009, Jean Delvare wrote:
> > On Sun, 15 Mar 2009 13:44:01 +0100, Hans Verkuil wrote:
> > This is the typical multifunction device problem. It isn't specifically
> > related to I2C, the exact same problem happens for other devices, for
> > example a PCI south bridge including hardware monitoring and SMBus, or
> > a Super-I/O chip including hardware monitoring, parallel port,
> > infrared, watchdog, etc. Linux currently only allows one driver to bind
> > to a given device, so it becomes very difficult to make per-function
> > drivers for such devices.
> >
> > For very specific devices, it isn't necessarily a big problem. You can
> > simply make an all-in-one driver for that specific device. The real
> > problem is when the device in question is fully compatible with other
> > devices which only implement functionality A _and_ fully compatible with
> > other devices which only implement functionality B. You don't really
> > want to support functions A and B in the same driver if most devices
> > out there have either function but not both.
> 
> You can also split the "device" into multiple devices.  Most SoCs have one
> register block where all kinds of devices, from i2c controllers to network
> adapters, exist.  This is shown to linux as many devices, rather than one
> massive multifunction device.

It really depends on the device type. You can't split an I2C or PCI
device that way.

-- 
Jean Delvare
