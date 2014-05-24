Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59642 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaEXJgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 05:36:04 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so5837448wgh.29
        for <linux-media@vger.kernel.org>; Sat, 24 May 2014 02:36:02 -0700 (PDT)
Received: from [192.168.1.100] (94.196.241.181.threembb.co.uk. [94.196.241.181])
        by mx.google.com with ESMTPSA id ln3sm9275407wjc.8.2014.05.24.02.36.00
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 24 May 2014 02:36:01 -0700 (PDT)
Message-ID: <1400924157.2813.3.camel@canaries64-MCP7A>
Subject: [PATCH] lmedm04: rs2000 check if interrupt urb is over due
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 24 May 2014 10:35:57 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Change handling of signal_lock on rs2000. Use ibuf[2] to detect
lock as there is a longer wait for lock to appear in ibuf[6].

Remove last_key and key_timeout and use jiffies plus 60ms
to detect that streaming is still active.

If the current jiffies is time_after the interrupt urb overdue and
clear signal lock.

This results in far faster recovery of lock and streaming.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f674dc0..7d685bc 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -125,14 +125,13 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define TUNER_RS2000	0x4
 
 struct lme2510_state {
+	unsigned long int_urb_due;
 	u8 id;
 	u8 tuner_config;
 	u8 signal_lock;
 	u8 signal_level;
 	u8 signal_sn;
 	u8 time_key;
-	u8 last_key;
-	u8 key_timeout;
 	u8 i2c_talk_onoff;
 	u8 i2c_gate;
 	u8 i2c_tuner_gate_w;
@@ -323,7 +322,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 				}
 				break;
 			case TUNER_RS2000:
-				if (ibuf[1] == 0x3 &&  ibuf[6] == 0xff)
+				if (ibuf[2] & 0x1)
 					st->signal_lock = 0xff;
 				else
 					st->signal_lock = 0x00;
@@ -343,7 +342,12 @@ static void lme2510_int_response(struct urb *lme_urb)
 		break;
 		}
 	}
+
 	usb_submit_urb(lme_urb, GFP_ATOMIC);
+
+	/* interrupt urb is due every 48 msecs while streaming
+	 *	add 12msecs for system lag */
+	st->int_urb_due = jiffies + msecs_to_jiffies(60);
 }
 
 static int lme2510_int_read(struct dvb_usb_adapter *adap)
@@ -584,14 +588,13 @@ static int lme2510_msg(struct dvb_usb_device *d,
 			switch (wbuf[3]) {
 			case 0x8c:
 				rbuf[0] = 0x55;
-				rbuf[1] = 0xff;
-				if (st->last_key == st->time_key) {
-					st->key_timeout++;
-					if (st->key_timeout > 5)
-						rbuf[1] = 0;
-				} else
-					st->key_timeout = 0;
-				st->last_key = st->time_key;
+				rbuf[1] = st->signal_lock;
+
+				/* If int_urb_due overdue
+				 *  set rbuf[1] to 0 to clear lock */
+				if (time_after(jiffies,	st->int_urb_due))
+					rbuf[1] = 0;
+
 				break;
 			default:
 				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-- 
1.9.1

