Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62315 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZAaVt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2009 16:49:27 -0500
Received: by fxm13 with SMTP id 13so817792fxm.13
        for <linux-media@vger.kernel.org>; Sat, 31 Jan 2009 13:49:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7951d5d30901311346i162ce575j76fd660fa0b0e176@mail.gmail.com>
References: <7951d5d30901311346i162ce575j76fd660fa0b0e176@mail.gmail.com>
Date: Sat, 31 Jan 2009 22:49:25 +0100
Message-ID: <7951d5d30901311349l769195b7x9202b78970b6b8b5@mail.gmail.com>
Subject: Re: PXA Quick capture interface with HV7131RP-Camera
From: Bennet Fischer <bennetfischer@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


I am trying to get a camera to work together with an PXA270 processor.
My system has the following specs:

Platform: Gumstix Verdex Pro
Camera: HV7131RP
OS: Linux 2.6.28

I wrote a simple driver for the camera which omits all the i2c-stuff
because the camera starts already in a default configuration which
works fine for me.
A V4L2-device is generated and everything looks fine. But when i start
to capture, no data arrives BUT the Quick Capture Interface outputs a
MCLK and the camera responds with a PCLK, LV and FV (and data of
couse).
For getting a bit closer to the origin of the problem I disabled DMA
in pxa_camera.c and enabled all Interrupts in the CICR0 register. No
interrupt is generated. Even by disabling DMA and IRQ and looking into
CISR nothing happens.
I checked all the CIF registers bitwise. The polarity of the LV and FV
is correct, the alternate pin functions are correct, the interrupt bit
is non-masked, the size of the pixel matrix is correct. I'm a bit
desperate because at the moment I have no idea what to do next. I
would be thankful for any hint.


Greetings,
Bennet.
