Return-path: <linux-media-owner@vger.kernel.org>
Received: from b.a.painless.aa.net.uk ([81.187.30.65]:59720 "EHLO
	b.a.painless.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcALVuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 16:50:44 -0500
Received: from 6.15.169.217.in-addr.arpa ([217.169.15.6] helo=[192.168.2.246])
	by a.painless.aa.net.uk with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <linux-media@destevenson.freeserve.co.uk>)
	id 1aJ5gf-00089a-4A
	for linux-media@vger.kernel.org; Tue, 12 Jan 2016 20:37:07 +0000
To: linux-media@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Subject: Using the V4L2 device kernel drivers - TC358743
Message-ID: <56956454.4090307@destevenson.freeserve.co.uk>
Date: Tue, 12 Jan 2016 20:38:44 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

Apologies for what feels like such a newbie question, but I've failed to 
find useful information elsewhere.

I'm one of the ex-Broadcom developers who is still supporting Raspberry 
Pi, although I'm not employed by Pi Foundation or Trading.
My aim is to open up that platform by exposing the CSI2 receiver block 
(and eventually parts of the ISP) via V4L2. The first use case would be 
for the Toshiba TC358743 HDMI to CSI2 converter, but it should be 
applicable to any of the other device drivers too.
Sadly it probably won't be upstreamable as it will require the GPU to do 
most of the register poking to avoid potential IP issues (Broadcom not 
having released the docs for the relevant hardware blocks). In that 
regard it will be fairly similar to the existing V4L2 driver for the Pi 
camera.

There is now the driver for the TC358743 in mainline, but my stumbling 
block is finding a useful example of how to actually use it. The commit 
text by Mats Randgaard says it was "tested on our hardware and all the 
implemented features works as expected", but I don't know what that 
hardware was or how it was used.

The media controller API seems to be part of the answer, but that seems 
to be a large overhead for an application to have to connect together 
multiple sub-devices when it is only interested in images out the back. 
Is there something that sets up default connections that I'm missing? 
Somewhere within device tree?

I have looked at the OMAP4 ISS driver as a vaguely similar device, but 
that seemingly covers the image processing pipe only, not hooking in to 
the sensor drivers.

I've also got a slight challenge in that ideally I want the GPU to 
allocate the memory, and ARM map that memory (we already have a service 
to do that), but I can't see how that would fit in with the the existing 
videobuf modes. Any thoughts on how I might be able to support that? The 
existing V4L2 driver ends up doing a full copy of every buffer from GPU 
memory to ARM, which isn't great for performance.
There may be an option to use contiguous memory and get the GPU to map 
that, but it's more involved as I don't believe the supporting code is 
on the Pi branch.

Any help much appreciated.

Thanks.
   Dave

PS If those involved in the TC358743 driver are reading, a couple of 
quick emails over the possibility of bringing the audio in over CSI2 
rather than I2S would be appreciated. I can split out the relevant CSI2 
ID stream, but have no idea how I would then feed that through the 
kernel to appear via ALSA.
