Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:40214 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3GHVlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jul 2013 17:41:16 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] lirc: make transmit interface consistent
Date: Mon,  8 Jul 2013 22:33:09 +0100
Message-Id: <1373319192-26816-2-git-send-email-sean@mess.org>
In-Reply-To: <1373319192-26816-1-git-send-email-sean@mess.org>
References: <1373319192-26816-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All lirc drivers that can transmit, return EINVAL when they are passed
more than IR data than they can send. That is, except for two drivers
which I touched.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/DocBook/media/v4l/lirc_device_interface.xml | 4 +++-
 drivers/media/rc/iguanair.c                               | 4 ++--
 drivers/media/rc/redrat3.c                                | 7 ++++---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index 8d7eb6b..34cada2 100644
--- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
@@ -46,7 +46,9 @@ describing an IR signal are read from the chardev.</para>
 values. Pulses and spaces are only marked implicitly by their position. The
 data must start and end with a pulse, therefore, the data must always include
 an uneven number of samples. The write function must block until the data has
-been transmitted by the hardware.</para>
+been transmitted by the hardware. If more data is provided than the hardware
+can send, the driver returns EINVAL.</para>
+
 </section>
 
 <section id="lirc_ioctl">
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a4ab2e6..19632b1 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -364,8 +364,8 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 		periods = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
 		bytes = DIV_ROUND_UP(periods, 127);
 		if (size + bytes > ir->bufsize) {
-			count = i;
-			break;
+			rc = -EINVAL;
+			goto out;
 		}
 		while (periods > 127) {
 			ir->packet->payload[size++] = 127 | space;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 3749443..0042367 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -762,7 +762,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		return -EAGAIN;
 	}
 
-	count = min_t(unsigned, count, RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN);
+	if (count > RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN)
+		return -EINVAL;
 
 	/* rr3 will disable rc detector on transmit */
 	rr3->transmitting = true;
@@ -801,8 +802,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 						&irdata->lens[curlencheck]);
 				curlencheck++;
 			} else {
-				count = i - 1;
-				break;
+				ret = -EINVAL;
+				goto out;
 			}
 		}
 		irdata->sigdata[i] = lencheck;
-- 
1.8.3.1

