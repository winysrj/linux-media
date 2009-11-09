Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZKIRbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 12:31:19 -0500
Date: Mon, 9 Nov 2009 15:30:46 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
Message-ID: <20091109153046.5a488106@pedra.chehab.org>
In-Reply-To: <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	<20091109144647.2f876934@pedra.chehab.org>
	<ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Nov 2009 18:19:34 +0100
Valerio Bontempi <valerio.bontempi@gmail.com> escreveu:

> Hi All,
> 
> first thank you for your quick support.
> I have already extracted and installed the xc3028-v27.fw firmware file
> following the instructions contained in
> http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware
> 
> but with no luck, the device is detected but the dvb device /dev/dvb
> is not created

The creation of the DVB interface is not related to firmware. It means that
the driver you're using doesn't know yet how to make DVB available on your
device.
> 
> Attached you find the v4l-info output.
> 
> I think that the extracted firmware is not the right one, since the
> device is detected correctly.
> 
> Just two note:
> first: until kernel 2.6.31 I was able to use this device compiling
> em28xx-new source tree, but this driver version is no more compatible
> with last kernel versions.
> second: I tried to compile last v4l-dvb source code but the compilation failed.
> 
> Is there a way to solve this problem?
> 
> Thanks a lot.
> 
> Valerio
> 
You should try to use the latest driver available at
http://linuvtv.org/hg/v4l-dvb

I may be mistaken, but the DVB support for this device were added recently. I
suspect that they were added at 2.6.32-rc1 kernel.

Cheers,
Mauro
