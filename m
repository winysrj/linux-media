Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34436 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbcGGIMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 04:12:39 -0400
MIME-Version: 1.0
From: Hao Zhang <hao5781286@gmail.com>
Date: Thu, 7 Jul 2016 16:12:21 +0800
Message-ID: <CAJeuY79hD7Zzp7j1D=AfW+MRqmmFdOxJUW_eyQE+L9MjtQHGow@mail.gmail.com>
Subject: Developing Linux Kernel Driver for media Codec Driver
To: wens@csie.org
Cc: kernelnewbies@kernelnewbies.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi all

i am developing a linux kernel driver for a 4-CH AHD2.0 RX and 9-CH
Audio Codec which is named nvp6124 .

wedsite : http://www.nextchip.com/ch/products/product.asp?hGubun=AHD.

below are few of its characteristics:

video codec:
it digitizes and decodes ntsc/pal/comet/AHD1.0/AHD2.O video signal into digital
video components which represents 8bit bt656/1120 4:2:2 byte interleave fotmat.

audio codec:
output pcm digital signal converted from analog audio input signals and analog
audio signals converted from pcm digital audio.

control interface:
control and configure through i2c interface.

video interface:
4ch analog video input and output 2ch digital signal, each channal has
8 data ports and a clk clock port
which can connect to the embedded processer.


audio interface(two i2s interface):
audio data convert to PCM data,and outputed via i2s interface .
PCM data can also input via i2s interface, the input audio data is
outputed via internal DAC.


i want to submit the driver, but i have some problem on the below points:

1.must i submit the driver through device tree binding? Does the
kernel tree accept the driver without device tree binding?
just see the video interface ,i know i2c port can binding below the
i2c node, but, how can i bind other data port and clock signal port
with device trees?

2.how to use device tree to bind device and how does the kernel uses
it to match device? can i obtain some document about this?

3.i creat the driver for Cubieboard one(allwinner a10 processer) and
Banana PI BPI-M1(allwinner a20 processer) ,if i submit patch
,which  kernel version shoudle i use ? must i use the lastest kernel
(download in www.kernel.org isn't the sdk of the board)in that boards
?

4.does someone know which lastest kernel version does Cubieboard one
and Banana PI BPI-M1 supports?

5.the maintainer doesn't has the device, how do they know the driver
is work well on my board? just buit without error or warning ?



Best regards :)

Hao Zhang
