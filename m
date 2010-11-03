Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57265 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0KCJm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 05:42:57 -0400
Received: by iwn10 with SMTP id 10so564082iwn.19
        for <linux-media@vger.kernel.org>; Wed, 03 Nov 2010 02:42:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Nov 2010 10:42:56 +0100
Message-ID: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com>
Subject: OMAP3530 ISP irqs disabled
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello ISP team,

I succeeded to stream the first images from the sensor to userspace
using Laurent's media-ctl and yafta. Unfortunately all images are
black (10MB of zeros).
Once by chance I streamed some images (1 of 20 about) with content.
All values were < 0x400, so that I assume the values were correctly
transferred for my 10-bit pixels.

I shortly describe my setup:
As I need xclk_a activated for my sensor to work (I2C), I activate the
xclk in the isp_probe function. Early hack that I want to remove
later.
While I placed my activation in mid of the probe function, I had
somehow the interrupts disabled when trying to stream using yafta. So
I hacked in the reenabling of the interrupts somewhere else in probe()
too.
As I dug through the isp code I saw that it is better to place the
clock activation after the final isp_put in probe() then the
interrupts keep working, but this way I never got a valid picture so
far. It's all a mess, I know. I try to transfer the activation to my
sensor code and board-setup code like in the et8ek8 code.

However... please help me get rid of these zeros! I keep reading
through the ISP and the mt9p031 docs to find some settings that could
have influence on the data sampling. The sensor is working fine now,
so the solution should be somewhere within the isp.

Thank you all,

 Bastian
