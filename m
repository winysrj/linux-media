Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:43641 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1CUSeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 14:34:04 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	js@linuxtv.org, tskd2@yahoo.co.jp, liplianin@me.by,
	g.marco@freenet.de, aet@rasterburn.org, pb@linuxtv.org,
	mkrufky@linuxtv.org, nick@nick-andrew.net, max@veneto.com,
	janne-dvb@grunau.be, Florian Mickler <florian@mickler.org>
Subject: [PATCH 3/6] [media] friio: get rid of on-stack dma buffers
Date: Mon, 21 Mar 2011 19:33:43 +0100
Message-Id: <1300732426-18958-4-git-send-email-florian@mickler.org>
In-Reply-To: <1300732426-18958-1-git-send-email-florian@mickler.org>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/friio.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/friio.c b/drivers/media/dvb/dvb-usb/friio.c
index 14a65b4..76159ae 100644
--- a/drivers/media/dvb/dvb-usb/friio.c
+++ b/drivers/media/dvb/dvb-usb/friio.c
@@ -142,17 +142,20 @@ static u32 gl861_i2c_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C;
 }
 
-
 static int friio_ext_ctl(struct dvb_usb_adapter *adap,
 			 u32 sat_color, int lnb_on)
 {
 	int i;
 	int ret;
 	struct i2c_msg msg;
-	u8 buf[2];
+	u8 *buf;
 	u32 mask;
 	u8 lnb = (lnb_on) ? FRIIO_CTL_LNB : 0;
 
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	msg.addr = 0x00;
 	msg.flags = 0;
 	msg.len = 2;
@@ -189,6 +192,7 @@ static int friio_ext_ctl(struct dvb_usb_adapter *adap,
 	buf[1] |= FRIIO_CTL_CLK;
 	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
 
+	kfree(buf);
 	return (ret == 70);
 }
 
@@ -219,11 +223,20 @@ static int friio_initialize(struct dvb_usb_device *d)
 	int ret;
 	int i;
 	int retry = 0;
-	u8 rbuf[2];
-	u8 wbuf[3];
+	u8 *rbuf, *wbuf;
 
 	deb_info("%s called.\n", __func__);
 
+	wbuf = kmalloc(3, GFP_KERNEL);
+	if (!wbuf)
+		return -ENOMEM;
+
+	rbuf = kmalloc(2, GFP_KERNEL);
+	if (!rbuf) {
+		kfree(wbuf);
+		return -ENOMEM;
+	}
+
 	/* use gl861_i2c_msg instead of gl861_i2c_xfer(), */
 	/* because the i2c device is not set up yet. */
 	wbuf[0] = 0x11;
@@ -358,6 +371,8 @@ restart:
 	return 0;
 
 error:
+	kfree(wbuf);
+	kfree(rbuf);
 	deb_info("%s:ret == %d\n", __func__, ret);
 	return -EIO;
 }
-- 
1.7.4.1

