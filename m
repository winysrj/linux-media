Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:8417 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaAMLCR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 06:02:17 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZC007WT6NP0U00@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jan 2014 06:02:14 -0500 (EST)
Date: Mon, 13 Jan 2014 09:02:08 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Rich Freeman <rich0@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Issue with 3.12.5/7 and CX23880/1/2/3 DVB Card
Message-id: <20140113090208.0437013b@samsung.com>
In-reply-to: <CAGfcS_=jvT5ExkkXiXjzmwR4DgXogM59rwrLhRMLeHe=LRAYjA@mail.gmail.com>
References: <CAGfcS_=jvT5ExkkXiXjzmwR4DgXogM59rwrLhRMLeHe=LRAYjA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Jan 2014 16:26:41 -0500
Rich Freeman <rich0@gentoo.org> escreveu:

> I noticed that you authored commit
> 19496d61f3962fd6470b106b779eddcdbe823c9b, which replaced a dynamic
> buffer with a static one when sending data to the card.
> 
> This broke my ATI HD tuner, listed in lspci as:
> 04:07.0 Multimedia video controller: Conexant Systems, Inc.
> CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
> 04:07.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
> PCI Video and Audio Decoder [Audio Port] (rev 05)
> 04:07.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
> PCI Video and Audio Decoder [MPEG Port] (rev 05)
> 
> (I'd have to rip the card out to actually get the model number - it
> has been ages since I bought it.)
> 
> The card fails to load firmware in 3.12.7 and will not record video.
> It loads with a warning in 3.12.5, and recording works.
> 
> The warnings in 3.12.5 are:
> Dec 20 10:52:04 rich kernel: [   31.747903] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747908] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747910] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747912] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747914] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747916] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747918] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747919] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747921] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747923] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747925] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747926] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747928] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747930] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747931] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747933] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747935] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747937] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747938] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747940] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747942] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747943] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747945] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747947] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747949] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747950] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747952] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747954] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747955] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747957] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747959] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747961] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747962] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747964] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747966] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747967] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747969] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
> Dec 20 10:52:04 rich kernel: [   31.747971] nxt200x:
> nxt200x_writebytes: i2c wr reg=002c: len=149 is too big!
> Dec 20 10:52:04 rich kernel: [   31.750080] nxt200x: nxt2004_init:
> Firmware upload complete
> 
> The error in 3.12.7 is:
> Dec 19 17:35:21 rich kernel: [  128.768232] nxt200x: Error writing
> multireg register 0x08
> Dec 19 17:35:21 rich kernel: [  128.771271] nxt200x: Error writing
> multireg register 0x08
> Dec 19 17:35:21 rich kernel: [  128.783125] nxt200x: Error writing
> multireg register 0x80
> Dec 19 17:35:21 rich kernel: [  128.788617] nxt200x: Error writing
> multireg register 0x08
> Dec 19 17:35:21 rich kernel: [  128.794113] nxt200x: Error writing
> multireg register 0x08
> Dec 19 17:35:21 rich kernel: [  128.799608] nxt200x: Error writing
> multireg register 0x80
> Dec 19 17:35:21 rich kernel: [  128.802640] nxt200x: Error writing
> multireg register 0x81
> Dec 19 17:35:21 rich kernel: [  128.806025] nxt200x: Error writing
> multireg register 0x82
> Dec 19 17:35:21 rich kernel: [  128.811516] nxt200x: Error writing
> multireg register 0x88
> Dec 19 17:35:21 rich kernel: [  128.817014] nxt200x: Error writing
> multireg register 0x80
> Dec 19 17:35:21 rich kernel: [  129.048443] nxt200x: Timeout waiting
> for nxt2004 to init.
> Dec 19 17:35:22 rich kernel: [  129.770854] nxt200x: Timeout waiting
> for nxt200x to stop. This is ok after firmware upload.
> (this was a loop that overran my ring buffer, so I can't vouch for
> which of those errors came first)
> 
> This is using the kernel.org git kernel built from the tagged releases.
> 
> I reverted your commit and the resulting 3.12.7 kernel worked fine,
> initializing the card with no errors/warnings, and the card was able
> to record video.
> 
> Hopefully this is helpful in resolving the problem.  If you need
> additional info or would like me to test any patches let me know.  If
> this is best directed elsewhere, let me know.
> 
> Rich Freeman

Can you please try the following patch?

Thanks!
Mauro

-

nxt200x: increase write buffer size

The buffer size on nxt200x is not enough:

	...
	> Dec 20 10:52:04 rich kernel: [   31.747949] nxt200x: nxt200x_writebytes: i2c wr reg=002c: len=255 is too big!
	...

Increase it to 256 bytes.

Reported-by: Rich Freeman <rich0@gentoo.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index fbca9856313a..4bf057544607 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -40,7 +40,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 /* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#define MAX_XFER_SIZE  256
 
 #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
 #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"


-- 

Cheers,
Mauro
