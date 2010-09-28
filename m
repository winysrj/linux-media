Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab0I1Su0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:50:26 -0400
Date: Tue, 28 Sep 2010 15:46:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/10] V4L/DVB: cx231xx: properly implement URB control
 messages log
Message-ID: <20100928154656.2a4548d8@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 5406ff2..983b120 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -47,11 +47,6 @@ static unsigned int reg_debug;
 module_param(reg_debug, int, 0644);
 MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
-#define cx231xx_regdbg(fmt, arg...) do {\
-	if (reg_debug) \
-		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __func__ , ##arg); } while (0)
-
 static int alt = CX231XX_PINOUT;
 module_param(alt, int, 0644);
 MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
@@ -240,6 +235,66 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 EXPORT_SYMBOL_GPL(cx231xx_send_usb_command);
 
 /*
+ * Sends/Receives URB control messages, assuring to use a kalloced buffer
+ * for all operations (dev->urb_buf), to avoid using stacked buffers, as
+ * they aren't safe for usage with USB, due to DMA restrictions.
+ * Also implements the debug code for control URB's.
+ */
+static int __usb_control_msg(struct cx231xx *dev, unsigned int pipe,
+	__u8 request, __u8 requesttype, __u16 value, __u16 index,
+	void *data, __u16 size, int timeout)
+{
+	int rc, i;
+
+	if (reg_debug) {
+		printk(KERN_DEBUG "%s: (pipe 0x%08x): "
+				"%s:  %02x %02x %02x %02x %02x %02x %02x %02x ",
+				dev->name,
+				pipe,
+				(requesttype & USB_DIR_IN) ? "IN" : "OUT",
+				requesttype,
+				request,
+				value & 0xff, value >> 8,
+				index & 0xff, index >> 8,
+				size & 0xff, size >> 8);
+		if (!(requesttype & USB_DIR_IN)) {
+			printk(KERN_CONT ">>>");
+			for (i = 0; i < size; i++)
+				printk(KERN_CONT " %02x",
+				       ((unsigned char *)data)[i]);
+		}
+	}
+
+	/* Do the real call to usb_control_msg */
+	mutex_lock(&dev->ctrl_urb_lock);
+	if (!(requesttype & USB_DIR_IN) && size)
+		memcpy(dev->urb_buf, data, size);
+	rc = usb_control_msg(dev->udev, pipe, request, requesttype, value,
+			     index, dev->urb_buf, size, timeout);
+	if ((requesttype & USB_DIR_IN) && size)
+		memcpy(data, dev->urb_buf, size);
+	mutex_unlock(&dev->ctrl_urb_lock);
+
+	if (reg_debug) {
+		if (unlikely(rc < 0)) {
+			printk(KERN_CONT "FAILED!\n");
+			return rc;
+		}
+
+		if ((requesttype & USB_DIR_IN)) {
+			printk(KERN_CONT "<<<");
+			for (i = 0; i < size; i++)
+				printk(KERN_CONT " %02x",
+				       ((unsigned char *)data)[i]);
+		}
+		printk(KERN_CONT "\n");
+	}
+
+	return rc;
+}
+
+
+/*
  * cx231xx_read_ctrl_reg()
  * reads data from the usb device specifying bRequest and wValue
  */
@@ -276,39 +331,9 @@ int cx231xx_read_ctrl_reg(struct cx231xx *dev, u8 req, u16 reg,
 	if (val == 0xFF)
 		return -EINVAL;
 
-	if (reg_debug) {
-		cx231xx_isocdbg("(pipe 0x%08x): "
-				"IN:  %02x %02x %02x %02x %02x %02x %02x %02x ",
-				pipe,
-				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				req, 0, val,
-				reg & 0xff, reg >> 8, len & 0xff, len >> 8);
-	}
-
-	mutex_lock(&dev->ctrl_urb_lock);
-	ret = usb_control_msg(dev->udev, pipe, req,
+	ret = __usb_control_msg(dev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      val, reg, dev->urb_buf, len, HZ);
-	if (ret < 0) {
-		cx231xx_isocdbg(" failed!\n");
-		mutex_unlock(&dev->ctrl_urb_lock);
-		return ret;
-	}
-
-	if (len)
-		memcpy(buf, dev->urb_buf, len);
-
-	mutex_unlock(&dev->ctrl_urb_lock);
-
-	if (reg_debug) {
-		int byte;
-
-		cx231xx_isocdbg("<<<");
-		for (byte = 0; byte < len; byte++)
-			cx231xx_isocdbg(" %02x", (unsigned char)buf[byte]);
-		cx231xx_isocdbg("\n");
-	}
-
+			      val, reg, buf, len, HZ);
 	return ret;
 }
 
@@ -331,28 +356,10 @@ int cx231xx_send_vendor_cmd(struct cx231xx *dev,
 	else
 		pipe = usb_sndctrlpipe(dev->udev, 0);
 
-	if (reg_debug) {
-		int byte;
-
-		cx231xx_isocdbg("(pipe 0x%08x): "
-				"OUT: %02x %02x %02x %04x %04x %04x >>>",
-				pipe,
-				ven_req->
-				direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				ven_req->bRequest, 0, ven_req->wValue,
-				ven_req->wIndex, ven_req->wLength);
-
-		for (byte = 0; byte < ven_req->wLength; byte++)
-			cx231xx_isocdbg(" %02x",
-					(unsigned char)ven_req->pBuff[byte]);
-		cx231xx_isocdbg("\n");
-	}
-
-
-/*
-If the cx23102 read more than 4 bytes with i2c bus,
-need chop to 4 byte per request
-*/
+	/*
+	 * If the cx23102 read more than 4 bytes with i2c bus,
+	 * need chop to 4 byte per request
+	 */
 	if ((ven_req->wLength > 4) && ((ven_req->bRequest == 0x4) ||
 					(ven_req->bRequest == 0x5) ||
 					(ven_req->bRequest == 0x6))) {
@@ -362,71 +369,39 @@ need chop to 4 byte per request
 
 		unsend_size = ven_req->wLength;
 
-		mutex_lock(&dev->ctrl_urb_lock);
-		/* the first package*/
+		/* the first package */
 		ven_req->wValue = ven_req->wValue & 0xFFFB;
 		ven_req->wValue = (ven_req->wValue & 0xFFBD) | 0x2;
-		/*printk(KERN_INFO " !!!!! 0x%x 0x%x 0x%x 0x%x \n",
-			ven_req->bRequest,
-			ven_req->direction | USB_TYPE_VENDOR |
-			USB_RECIP_DEVICE,ven_req->wValue,ven_req->wIndex);*/
-		ret = usb_control_msg(dev->udev, pipe, ven_req->bRequest,
-			ven_req->
-			direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		ret = __usb_control_msg(dev, pipe, ven_req->bRequest,
+			ven_req->direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			ven_req->wValue, ven_req->wIndex, pdata,
 			0x0004, HZ);
 		unsend_size = unsend_size - 4;
-		mutex_unlock(&dev->ctrl_urb_lock);
 
-		/* the middle package*/
+		/* the middle package */
 		ven_req->wValue = (ven_req->wValue & 0xFFBD) | 0x42;
 		while (unsend_size - 4 > 0) {
 			pdata = pdata + 4;
-			/*printk(KERN_INFO " !!!!! 0x%x 0x%x 0x%x 0x%x \n",
+			ret = __usb_control_msg(dev, pipe,
 				ven_req->bRequest,
-				ven_req->direction | USB_TYPE_VENDOR |
-				USB_RECIP_DEVICE,
-				ven_req->wValue,ven_req->wIndex);*/
-			mutex_lock(&dev->ctrl_urb_lock);
-			ret = usb_control_msg(dev->udev, pipe,
-				 ven_req->bRequest,
-				ven_req->
-				direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				ven_req->direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				ven_req->wValue, ven_req->wIndex, pdata,
 				0x0004, HZ);
-			mutex_unlock(&dev->ctrl_urb_lock);
 			unsend_size = unsend_size - 4;
 		}
 
-
-		/* the last package*/
+		/* the last package */
 		ven_req->wValue = (ven_req->wValue & 0xFFBD) | 0x40;
 		pdata = pdata + 4;
-		/*printk(KERN_INFO " !!!!! 0x%x 0x%x 0x%x 0x%x \n",
-			ven_req->bRequest,
-			ven_req->direction | USB_TYPE_VENDOR |
-			USB_RECIP_DEVICE,ven_req->wValue,ven_req->wIndex);*/
-		mutex_lock(&dev->ctrl_urb_lock);
-		ret = usb_control_msg(dev->udev, pipe, ven_req->bRequest,
-			ven_req->
-			direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		ret = __usb_control_msg(dev, pipe, ven_req->bRequest,
+			ven_req->direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			ven_req->wValue, ven_req->wIndex, pdata,
 			unsend_size, HZ);
-		mutex_unlock(&dev->ctrl_urb_lock);
-		/*printk(KERN_INFO " @@@@@ temp_buffer[0]=0x%x 0x%x 0x%x 0x%x
-			  0x%x 0x%x\n",ven_req->pBuff[0],ven_req->pBuff[1],
-			ven_req->pBuff[2], ven_req->pBuff[3],ven_req->pBuff[4],
-			ven_req->pBuff[5]);*/
-
 	} else {
-		mutex_lock(&dev->ctrl_urb_lock);
-		ret = usb_control_msg(dev->udev, pipe, ven_req->bRequest,
-				ven_req->
-				direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		ret = __usb_control_msg(dev, pipe, ven_req->bRequest,
+				ven_req->direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				ven_req->wValue, ven_req->wIndex,
-				 ven_req->pBuff, ven_req->wLength, HZ);
-		mutex_unlock(&dev->ctrl_urb_lock);
-
+				ven_req->pBuff, ven_req->wLength, HZ);
 	}
 
 	return ret;
@@ -484,12 +459,9 @@ int cx231xx_write_ctrl_reg(struct cx231xx *dev, u8 req, u16 reg, char *buf,
 		cx231xx_isocdbg("\n");
 	}
 
-	mutex_lock(&dev->ctrl_urb_lock);
-	memcpy(dev->urb_buf, buf, len);
-	ret = usb_control_msg(dev->udev, pipe, req,
+	ret = __usb_control_msg(dev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      val, reg, dev->urb_buf, len, HZ);
-	mutex_unlock(&dev->ctrl_urb_lock);
+			      val, reg, buf, len, HZ);
 
 	return ret;
 }
-- 
1.7.1


