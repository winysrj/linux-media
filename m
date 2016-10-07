Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938855AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Subject: [PATCH 08/26] dib0700_core: don't use stack on I2C reads
Date: Fri,  7 Oct 2016 14:24:18 -0300
Message-Id: <bbcbc1d7e3cebee244e425931a2ad2cbd23bc6c8.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Be sure that I2C reads won't use stack by passing
a pointer to the state buffer, that we know it was
allocated via kmalloc, instead of relying on the buffer
allocated by an I2C client.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 515f89dba199..92d5408684ac 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -213,7 +213,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 						 usb_rcvctrlpipe(d->udev, 0),
 						 REQUEST_NEW_I2C_READ,
 						 USB_TYPE_VENDOR | USB_DIR_IN,
-						 value, index, msg[i].buf,
+						 value, index, st->buf,
 						 msg[i].len,
 						 USB_CTRL_GET_TIMEOUT);
 			if (result < 0) {
@@ -221,6 +221,14 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 				break;
 			}
 
+			if (msg[i].len > sizeof(st->buf)) {
+				deb_info("buffer too small to fit %d bytes\n",
+					 msg[i].len);
+				return -EIO;
+			}
+
+			memcpy(msg[i].buf, st->buf, msg[i].len);
+
 			deb_data("<<< ");
 			debug_dump(msg[i].buf, msg[i].len, deb_data);
 
@@ -238,6 +246,13 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			/* I2C ctrl + FE bus; */
 			st->buf[3] = ((gen_mode << 6) & 0xC0) |
 				 ((bus_mode << 4) & 0x30);
+
+			if (msg[i].len > sizeof(st->buf) - 4) {
+				deb_info("i2c message to big: %d\n",
+					 msg[i].len);
+				return -EIO;
+			}
+
 			/* The Actual i2c payload */
 			memcpy(&st->buf[4], msg[i].buf, msg[i].len);
 
@@ -283,6 +298,11 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 		/* fill in the address */
 		st->buf[1] = msg[i].addr << 1;
 		/* fill the buffer */
+		if (msg[i].len > sizeof(st->buf) - 2) {
+			deb_info("i2c xfer to big: %d\n",
+				msg[i].len);
+			return -EIO;
+		}
 		memcpy(&st->buf[2], msg[i].buf, msg[i].len);
 
 		/* write/read request */
@@ -299,6 +319,11 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				break;
 			}
 
+			if (msg[i + 1].len > sizeof(st->buf)) {
+				deb_info("i2c xfer buffer to small for %d\n",
+					msg[i].len);
+				return -EIO;
+			}
 			memcpy(msg[i + 1].buf, st->buf, msg[i + 1].len);
 
 			msg[i+1].len = len;
-- 
2.7.4


