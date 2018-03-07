Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61806 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbeCGPZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 10:25:53 -0500
Date: Wed, 7 Mar 2018 12:25:47 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Akihiro Tsukada <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: I2C media binding model
Message-ID: <20180307122547.6c38f600@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro-san,

There are a number of patches that you sent with a proposal for a new
I2C binding model:

1. [v3,1/4] dvb: qm1d1c0042: use dvb-core i2c binding model template
        http://patchwork.linuxtv.org/patch/27923
2. dvb: mxl301rf: use dvb-core i2c binding model template
        http://patchwork.linuxtv.org/patch/27924
3. [v3,3/4] dvb: tc90522: use dvb-core i2c binding model template
        http://patchwork.linuxtv.org/patch/27925  
4. [v3,4/4] dvb: earth-pt3: use dvb-core i2c binding model template
        http://patchwork.linuxtv.org/patch/27926 
5. Jan,16 2015: [v2,1/2] dvb: tua6034: add a new driver for Infineon tua6034 tuner
        http://patchwork.linuxtv.org/patch/27927 
6. Jan,16 2015: [v2,2/2] dvb-usb-friio: split and merge into dvb-usbv2-gl861
        http://patchwork.linuxtv.org/patch/27928 
7. Mar,25 2015: [RESEND] media: dmxdev: fix possible race condition
        http://patchwork.linuxtv.org/patch/28968 

Yet, at the end of the day, we opted to use Antti's proposal, with has
been implemented on several drivers.

The only missing part were an easy way to bind to it, with was provided
last week with this patch:
	https://git.linuxtv.org/media_tree.git/commit/?id=8f569c0b4e6b6bd5db1d09551b2df87d912f124e

And an example about how to use it:
	https://git.linuxtv.org/media_tree.git/commit/?id=ad32495b1513fe8cbab717411b9cd8d2d285de30

So, could you please modify the drivers you submitted to use this?

I'll mark them at patchwork as "Changes Requested".

Thank you!
Mauro

Thanks,
Mauro
