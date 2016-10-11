Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39785 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbcJKKhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:37:50 -0400
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
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH v2 31/31] flexcop-usb: don't use stack for DMA
Date: Tue, 11 Oct 2016 07:09:46 -0300
Message-Id: <cd83f8f3349d51c637c000520e8204128262c0d8.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

While here, remove a dead function calling usb_control_msg().

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 105 +++++++++++++++++++++++------------
 drivers/media/usb/b2c2/flexcop-usb.h |   4 ++
 2 files changed, 72 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index d4bdba60b0f7..f26fc530564b 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -73,23 +73,34 @@ static int flexcop_usb_readwrite_dw(struct flexcop_device *fc, u16 wRegOffsPCI,
 	u8 request_type = (read ? USB_DIR_IN : USB_DIR_OUT) | USB_TYPE_VENDOR;
 	u8 wAddress = B2C2_FLEX_PCIOFFSET_TO_INTERNALADDR(wRegOffsPCI) |
 		(read ? 0x80 : 0);
+	int ret;
 
-	int len = usb_control_msg(fc_usb->udev,
+	mutex_lock(&fc_usb->data_mutex);
+	if (!read)
+		memcpy(fc_usb->data, val, sizeof(*val));
+
+	ret = usb_control_msg(fc_usb->udev,
 			read ? B2C2_USB_CTRL_PIPE_IN : B2C2_USB_CTRL_PIPE_OUT,
 			request,
 			request_type, /* 0xc0 read or 0x40 write */
 			wAddress,
 			0,
-			val,
+			fc_usb->data,
 			sizeof(u32),
 			B2C2_WAIT_FOR_OPERATION_RDW * HZ);
 
-	if (len != sizeof(u32)) {
+	if (ret != sizeof(u32)) {
 		err("error while %s dword from %d (%d).", read ? "reading" :
 				"writing", wAddress, wRegOffsPCI);
-		return -EIO;
+		if (ret >= 0)
+			ret = -EIO;
 	}
-	return 0;
+
+	if (read && ret >= 0)
+		memcpy(val, fc_usb->data, sizeof(*val));
+	mutex_unlock(&fc_usb->data_mutex);
+
+	return ret;
 }
 /*
  * DKT 010817 - add support for V8 memory read/write and flash update
@@ -100,9 +111,14 @@ static int flexcop_usb_v8_memory_req(struct flexcop_usb *fc_usb,
 {
 	u8 request_type = USB_TYPE_VENDOR;
 	u16 wIndex;
-	int nWaitTime, pipe, len;
+	int nWaitTime, pipe, ret;
 	wIndex = page << 8;
 
+	if (buflen > sizeof(fc_usb->data)) {
+		err("Buffer size bigger than max URB control message\n");
+		return -EIO;
+	}
+
 	switch (req) {
 	case B2C2_USB_READ_V8_MEM:
 		nWaitTime = B2C2_WAIT_FOR_OPERATION_V8READ;
@@ -127,17 +143,32 @@ static int flexcop_usb_v8_memory_req(struct flexcop_usb *fc_usb,
 	deb_v8("v8mem: %02x %02x %04x %04x, len: %d\n", request_type, req,
 			wAddress, wIndex, buflen);
 
-	len = usb_control_msg(fc_usb->udev, pipe,
+	mutex_lock(&fc_usb->data_mutex);
+
+	if ((request_type & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT)
+		memcpy(fc_usb->data, pbBuffer, buflen);
+
+	ret = usb_control_msg(fc_usb->udev, pipe,
 			req,
 			request_type,
 			wAddress,
 			wIndex,
-			pbBuffer,
+			fc_usb->data,
 			buflen,
 			nWaitTime * HZ);
+	if (ret != buflen)
+		ret = -EIO;
 
-	debug_dump(pbBuffer, len, deb_v8);
-	return len == buflen ? 0 : -EIO;
+	if (ret >= 0) {
+		ret = 0;
+		if ((request_type & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
+			memcpy(pbBuffer, fc_usb->data, buflen);
+	}
+
+	mutex_unlock(&fc_usb->data_mutex);
+
+	debug_dump(pbBuffer, ret, deb_v8);
+	return ret;
 }
 
 #define bytes_left_to_read_on_page(paddr,buflen) \
@@ -196,29 +227,6 @@ static int flexcop_usb_get_mac_addr(struct flexcop_device *fc, int extended)
 		fc->dvb_adapter.proposed_mac, 6);
 }
 
-#if 0
-static int flexcop_usb_utility_req(struct flexcop_usb *fc_usb, int set,
-		flexcop_usb_utility_function_t func, u8 extra, u16 wIndex,
-		u16 buflen, u8 *pvBuffer)
-{
-	u16 wValue;
-	u8 request_type = (set ? USB_DIR_OUT : USB_DIR_IN) | USB_TYPE_VENDOR;
-	int nWaitTime = 2,
-	    pipe = set ? B2C2_USB_CTRL_PIPE_OUT : B2C2_USB_CTRL_PIPE_IN, len;
-	wValue = (func << 8) | extra;
-
-	len = usb_control_msg(fc_usb->udev,pipe,
-			B2C2_USB_UTILITY,
-			request_type,
-			wValue,
-			wIndex,
-			pvBuffer,
-			buflen,
-			nWaitTime * HZ);
-	return len == buflen ? 0 : -EIO;
-}
-#endif
-
 /* usb i2c stuff */
 static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 		flexcop_usb_request_t req, flexcop_usb_i2c_function_t func,
@@ -226,9 +234,14 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 {
 	struct flexcop_usb *fc_usb = i2c->fc->bus_specific;
 	u16 wValue, wIndex;
-	int nWaitTime,pipe,len;
+	int nWaitTime, pipe, ret;
 	u8 request_type = USB_TYPE_VENDOR;
 
+	if (buflen > sizeof(fc_usb->data)) {
+		err("Buffer size bigger than max URB control message\n");
+		return -EIO;
+	}
+
 	switch (func) {
 	case USB_FUNC_I2C_WRITE:
 	case USB_FUNC_I2C_MULTIWRITE:
@@ -257,15 +270,32 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 			wValue & 0xff, wValue >> 8,
 			wIndex & 0xff, wIndex >> 8);
 
-	len = usb_control_msg(fc_usb->udev,pipe,
+	mutex_lock(&fc_usb->data_mutex);
+
+	if ((request_type & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT)
+		memcpy(fc_usb->data, buf, buflen);
+
+	ret = usb_control_msg(fc_usb->udev,pipe,
 			req,
 			request_type,
 			wValue,
 			wIndex,
-			buf,
+			fc_usb->data,
 			buflen,
 			nWaitTime * HZ);
-	return len == buflen ? 0 : -EREMOTEIO;
+
+	if (ret != buflen)
+		ret = -EIO;
+
+	if (ret >= 0) {
+		ret = 0;
+		if ((request_type & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
+			memcpy(buf, fc_usb->data, buflen);
+	}
+
+	mutex_unlock(&fc_usb->data_mutex);
+
+	return 0;
 }
 
 /* actual bus specific access functions,
@@ -516,6 +546,7 @@ static int flexcop_usb_probe(struct usb_interface *intf,
 	/* general flexcop init */
 	fc_usb = fc->bus_specific;
 	fc_usb->fc_dev = fc;
+	mutex_init(&fc_usb->data_mutex);
 
 	fc->read_ibi_reg  = flexcop_usb_read_ibi_reg;
 	fc->write_ibi_reg = flexcop_usb_write_ibi_reg;
diff --git a/drivers/media/usb/b2c2/flexcop-usb.h b/drivers/media/usb/b2c2/flexcop-usb.h
index 92529a9c4475..25ad43166e78 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.h
+++ b/drivers/media/usb/b2c2/flexcop-usb.h
@@ -29,6 +29,10 @@ struct flexcop_usb {
 
 	u8 tmp_buffer[1023+190];
 	int tmp_buffer_length;
+
+	/* for URB control messages */
+	u8 data[80];
+	struct mutex data_mutex;
 };
 
 #if 0
-- 
2.7.4


