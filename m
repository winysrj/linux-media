Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33189 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbdDLNNk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 09:13:40 -0400
Received: by mail-oi0-f48.google.com with SMTP id b187so30705309oif.0
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 06:13:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
References: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
 <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
From: Patrick Doyle <wpdster@gmail.com>
Date: Wed, 12 Apr 2017 09:13:08 -0400
Message-ID: <CAF_dkJCqcVuSsey697OkA6-E563qEr=fYFWM26V1ZOSdnu4RGQ@mail.gmail.com>
Subject: Re: Looking for device driver advice
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Hans,
I can modify (or work with Atmel/Microchip to have modified) the
atmel-isc driver, so I that's not an issue.

With your feedback, I now have a target implementation to which I can aim.

For now, I'll be happy when I can get any image at all through my
pipeline... wish me luck! :-)

On a similar vein... the image is much higher resolution than I need
at the moment, so I will need to downsample it.

The SAMA5 has a downsampler built into its LCD engine.  Suppose I
wanted to treat that downsampler as an independent device and pass
image buffers through that downsampler (the LCD display output is
disabled in hardware when the device is configured in this mode)....
do you have any recommendations as to how I might structure a device
driver to do that.  At it's core, it would DMA a buffer from memory,
through the downsampler, and back into memory.  Is that something I
might also wire in as a pseudo-subdev of the ISC?  Or is there a
better abstraction for arbitrary image processing pipeline elements?

Oh yeah, and speaking about arbitrary image processing pipeline
elements, the Atmel ISC has a number of elements that could be enabled
(but are not currently supported by the driver).  Is there a model to
follow to enable features such as demosaicing, color space conversion,
gamma correction, 4:2:2 to 4:2:0 downsampling, etc...

All of this is on the list of things that I need to get working... by
next Tuesday ideally :-)
(No, it's not really "next Tuesday", but you get the idea.)

--wpd


On Wed, Apr 12, 2017 at 7:37 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Patrick,
>
> On 04/10/2017 10:13 PM, Patrick Doyle wrote:
>> I am looking for advice regarding the construction of a device driver
>> for a MIPI CSI2 imager (a Sony IMX241) that is connected to a
>> MIPI<->Parallel converter (Toshiba TC358748) wired into a parallel
>> interface on a Soc (a Microchip/Atmel SAMAD2x device.)
>>
>> The Sony imager is controlled and configured via I2C, as is the
>> Toshiba converter.  I could write a single driver that configures both
>> devices and treats them as a single device that just happens to use 2
>> i2c addresses.  I could use the i2c_new_dummy() API to construct the
>> device abstraction for the second physical device at probe time for
>> the first physical device.
>>
>> Or I could do something smarter (or at least different), specifying
>> the two devices independently via my device tree file, perhaps linking
>> them together via "port" nodes.  Currently, I use the "port" node
>> concept to link an i2c imager to the Image System Controller (isc)
>> node in the SAMA5 device.  Perhaps that generalizes to a chain of
>> nodes linked together... I don't know.
>
> That would be the right solution. Unfortunately the atmel-isc.c driver
> (at least the version in the mainline kernel) only supports a single
> subdev device. At least, as far as I can see.
>
> What you have is a video pipeline of 2 subdevs and the atmel-isc as DMA
> engine:
>
> imx241 -> tc358748 -> atmel-isc
>
> connected in the device tree by ports.
>
> Looking at the code I think both subdev drivers would be loaded, but
> the atmel-isc driver would only call ops from the tc358748.
>
> The v4l2_subdev_call functions in atmel-isc should most likely be replaced
> by v4l2_device_call_all().
>
> But I don't have the tc358748 datasheet with the register information, so
> I am not sure if this is sufficient.
>
>> I'm also not sure how these two devices might play into V4L2's
>> "subdev" concept.  Are they separate, independent sub devices of the
>> ISC, or are they a single sub device.
>
> subdev drivers are standalone drivers for, among others, i2c devices. The
> top-level driver (atmel-isc + the device tree) is what pulls everything together.
>
> This allows us to reuse such subdev drivers on other devices.
>
> Regards,
>
>         Hans
>
>>
>> Any thoughts, intuition, pointers to existing code that addresses
>> questions such as these, would be welcome.
>>
>> Thanks.
>>
>> --wpd
>>
>
