Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:4536 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbZCORMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 13:12:21 -0400
Date: Sun, 15 Mar 2009 18:12:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090315181207.36d951ac@hyperion.delvare>
In-Reply-To: <200903151344.01730.hverkuil@xs4all.nl>
References: <200903151344.01730.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 15 Mar 2009 13:44:01 +0100, Hans Verkuil wrote:
> Hi Mauro, Jean,
> 
> When converting the bttv driver to v4l2_subdev I found one probing conflict 
> between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in 7-bit notation).
> 
> It turns out that this is one and the same PIC16C54 device used on the 
> ProVideo PV951 board. This chip is used for both audio input selection and 
> for IR handling.
> 
> But the tvaudio module does the audio part and the ir-kbd-i2c module does 
> the IR part. I have truly no idea how this should be handled in the new 
> situation. For that matter, I wonder whether it ever worked at all since my 
> understanding is that once you called i2c_attach_client for a particular 
> address, you cannot do that a second time. So depending on which module 
> happens to register itself first, you either have working audio or working 
> IR, but not both.

You are right.

> It might work if you use lirc, since that uses low-level i2c access 
> (right?). But I can't see how it can work with ir-kbd-i2c and tvaudio at 
> the same time.

I don't know anything about lirc, so I can't comment on this.

> Did some googling and this seems to confirm my analysis:
> 
> http://lists.zerezo.com/video4linux/msg21328.html
> 
> Ideas on a postcard, please... :-)

This is the typical multifunction device problem. It isn't specifically
related to I2C, the exact same problem happens for other devices, for
example a PCI south bridge including hardware monitoring and SMBus, or
a Super-I/O chip including hardware monitoring, parallel port,
infrared, watchdog, etc. Linux currently only allows one driver to bind
to a given device, so it becomes very difficult to make per-function
drivers for such devices.

For very specific devices, it isn't necessarily a big problem. You can
simply make an all-in-one driver for that specific device. The real
problem is when the device in question is fully compatible with other
devices which only implement functionality A _and_ fully compatible with
other devices which only implement functionality B. You don't really
want to support functions A and B in the same driver if most devices
out there have either function but not both.

I know that there was some work in progress to allow multiple drivers
to bind to the same device. However it seems to be very slow because it
is fundamentally incompatible with the device driver model as it was
originally designed.

In the meantime, one workaround is to list the multifunction device as
supported by several drivers, and make the probe functions for this
device fail, while still keeping a reference to the device. The
reference lets you access the device, and is freed when you remove the
drivers. See for example the via686a, vt8231 and i2c-viapro drivers.
This approach may or may not be suitable for the ir-kbd-i2c and tvaudio
drivers. One drawback is that you can't do power management on the
device.

As far as the PIC16C54 is concerned, another possibility would be to
move support to a dedicated driver. Depending on how much code is common
between the PIC16C54 and the other supported devices, the new driver
may either be standalone, or rely on functions exported by the
ir-kbd-i2c and tvaudio modules.

But this is all said without having much knowledge of the bttv, tvaudio
and ir-kbd-i2c drivers, so I might as well be completely off track.

-- 
Jean Delvare
