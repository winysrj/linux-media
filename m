Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24652 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaIVH7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 03:59:31 -0400
Date: Mon, 22 Sep 2014 10:58:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Dreissig <mukadr@gmail.com>,
	Martin Kepplinger <martink@posteo.de>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] as102: remove some unneeded checks
Message-ID: <20140922075853.GA12362@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We know "ret" is zero so we don't need to test for it.  It upsets the
static checkers when we test stuff but we know the answer.

drivers/media/usb/as102/as102_usb_drv.c:164 as102_send_ep1() warn: we tested 'ret' before and it was 'false'
drivers/media/usb/as102/as102_usb_drv.c:189 as102_read_ep2() warn: we tested 'ret' before and it was 'false'

Also, we don't need to initialize "ret".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 43133df..3f66906 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -145,7 +145,7 @@ static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
 			  int send_buf_len,
 			  int swap32)
 {
-	int ret = 0, actual_len;
+	int ret, actual_len;
 
 	ret = usb_bulk_msg(bus_adap->usb_dev,
 			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
@@ -161,13 +161,13 @@ static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
 			actual_len, send_buf_len);
 		return -1;
 	}
-	return ret ? ret : actual_len;
+	return actual_len;
 }
 
 static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 		   unsigned char *recv_buf, int recv_buf_len)
 {
-	int ret = 0, actual_len;
+	int ret, actual_len;
 
 	if (recv_buf == NULL)
 		return -EINVAL;
@@ -186,7 +186,7 @@ static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 			actual_len, recv_buf_len);
 		return -1;
 	}
-	return ret ? ret : actual_len;
+	return actual_len;
 }
 
 static struct as102_priv_ops_t as102_priv_ops = {
