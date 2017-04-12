Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40216 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752474AbdDLLhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 07:37:37 -0400
Subject: Re: Looking for device driver advice
To: Patrick Doyle <wpdster@gmail.com>, linux-media@vger.kernel.org
References: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
Date: Wed, 12 Apr 2017 13:37:33 +0200
MIME-Version: 1.0
In-Reply-To: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

On 04/10/2017 10:13 PM, Patrick Doyle wrote:
> I am looking for advice regarding the construction of a device driver
> for a MIPI CSI2 imager (a Sony IMX241) that is connected to a
> MIPI<->Parallel converter (Toshiba TC358748) wired into a parallel
> interface on a Soc (a Microchip/Atmel SAMAD2x device.)
> 
> The Sony imager is controlled and configured via I2C, as is the
> Toshiba converter.  I could write a single driver that configures both
> devices and treats them as a single device that just happens to use 2
> i2c addresses.  I could use the i2c_new_dummy() API to construct the
> device abstraction for the second physical device at probe time for
> the first physical device.
> 
> Or I could do something smarter (or at least different), specifying
> the two devices independently via my device tree file, perhaps linking
> them together via "port" nodes.  Currently, I use the "port" node
> concept to link an i2c imager to the Image System Controller (isc)
> node in the SAMA5 device.  Perhaps that generalizes to a chain of
> nodes linked together... I don't know.

That would be the right solution. Unfortunately the atmel-isc.c driver
(at least the version in the mainline kernel) only supports a single
subdev device. At least, as far as I can see.

What you have is a video pipeline of 2 subdevs and the atmel-isc as DMA
engine:

imx241 -> tc358748 -> atmel-isc

connected in the device tree by ports.

Looking at the code I think both subdev drivers would be loaded, but
the atmel-isc driver would only call ops from the tc358748.

The v4l2_subdev_call functions in atmel-isc should most likely be replaced
by v4l2_device_call_all().

But I don't have the tc358748 datasheet with the register information, so
I am not sure if this is sufficient.

> I'm also not sure how these two devices might play into V4L2's
> "subdev" concept.  Are they separate, independent sub devices of the
> ISC, or are they a single sub device.

subdev drivers are standalone drivers for, among others, i2c devices. The
top-level driver (atmel-isc + the device tree) is what pulls everything together.

This allows us to reuse such subdev drivers on other devices.

Regards,

	Hans

> 
> Any thoughts, intuition, pointers to existing code that addresses
> questions such as these, would be welcome.
> 
> Thanks.
> 
> --wpd
> 
