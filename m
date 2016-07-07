Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34360 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933546AbcGGIdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2016 04:33:09 -0400
Subject: Re: Developing Linux Kernel Driver for media Codec Driver
To: Hao Zhang <hao5781286@gmail.com>, wens@csie.org
References: <CAJeuY79hD7Zzp7j1D=AfW+MRqmmFdOxJUW_eyQE+L9MjtQHGow@mail.gmail.com>
Cc: kernelnewbies@kernelnewbies.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <577E13B2.4070501@xs4all.nl>
Date: Thu, 7 Jul 2016 10:32:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAJeuY79hD7Zzp7j1D=AfW+MRqmmFdOxJUW_eyQE+L9MjtQHGow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/16 10:12, Hao Zhang wrote:
> hi all
> 
> i am developing a linux kernel driver for a 4-CH AHD2.0 RX and 9-CH
> Audio Codec which is named nvp6124 .
> 
> wedsite : http://www.nextchip.com/ch/products/product.asp?hGubun=AHD.
> 
> below are few of its characteristics:
> 
> video codec:
> it digitizes and decodes ntsc/pal/comet/AHD1.0/AHD2.O video signal into digital
> video components which represents 8bit bt656/1120 4:2:2 byte interleave fotmat.
> 
> audio codec:
> output pcm digital signal converted from analog audio input signals and analog
> audio signals converted from pcm digital audio.
> 
> control interface:
> control and configure through i2c interface.
> 
> video interface:
> 4ch analog video input and output 2ch digital signal, each channal has
> 8 data ports and a clk clock port
> which can connect to the embedded processer.
> 
> 
> audio interface(two i2s interface):
> audio data convert to PCM data,and outputed via i2s interface .
> PCM data can also input via i2s interface, the input audio data is
> outputed via internal DAC.
> 
> 
> i want to submit the driver, but i have some problem on the below points:
> 
> 1.must i submit the driver through device tree binding? Does the
> kernel tree accept the driver without device tree binding?
> just see the video interface ,i know i2c port can binding below the
> i2c node, but, how can i bind other data port and clock signal port
> with device trees?

This driver should be implemented as a v4l2-subdevice (see many examples of
such drivers in drivers/media/i2c). Drivers like this can be used both on
embedded platforms using a device tree and on e.g. PCIe cards and in that
case a struct platform_data is used to pass the necessary information to
the driver. (Note: in the future there is a good chance that PCIe drivers will
start to use device tree overlays for this, but not at the moment AFAIK).

If you look at e.g. the adv7604.c driver you'll see that it can both parse the
DT and use platform_data.

See Documentation/devicetree/bindings/media/video-interfaces.txt for details
on how to bind data/clock signals in the DT.

If this is tested on an embedded board, then you'll need DT bindings.

> 2.how to use device tree to bind device and how does the kernel uses
> it to match device? can i obtain some document about this?

Look at e.g. arch/arm/boot/dts/r8a7790-lager.dts and search for adv7180.

> 3.i creat the driver for Cubieboard one(allwinner a10 processer) and
> Banana PI BPI-M1(allwinner a20 processer) ,if i submit patch
> ,which  kernel version shoudle i use ? must i use the lastest kernel
> (download in www.kernel.org isn't the sdk of the board)in that boards
> ?

The master branch of our media repository (https://git.linuxtv.org/media_tree.git)
is preferred.

> 
> 4.does someone know which lastest kernel version does Cubieboard one
> and Banana PI BPI-M1 supports?

I thought Cubieboard one supports the latest kernel, but I'm not sure about
the banana board.

> 
> 5.the maintainer doesn't has the device, how do they know the driver
> is work well on my board? just buit without error or warning ?

I have a cubieboard one, so I should be able to test. But in general I
assume that the developer actually has tested it (what's the point otherwise?!).

Also, before I accept a driver it has to pass the v4l2-compliance test found here:

https://git.linuxtv.org/v4l-utils.git/

This does pretty exhaustive tests and if it all passes, then the driver is in
pretty decent shape.

Regards,

	Hans
