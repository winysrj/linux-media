Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23957 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2DTGu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 02:50:58 -0400
Date: Fri, 20 Apr 2012 09:50:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] saa7164: saa7164_vbi_stop_port() returns linux error
 codes
Message-ID: <20120420065045.GF22649@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7164_vbi_stop_port() changes the SAA_ERR_ALREADY_STOPPED result
code to -EIO before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/video/saa7164/saa7164-vbi.c
index 273cf80..d8e6c8f 100644
--- a/drivers/media/video/saa7164/saa7164-vbi.c
+++ b/drivers/media/video/saa7164/saa7164-vbi.c
@@ -952,7 +952,7 @@ static int saa7164_vbi_start_streaming(struct saa7164_port *port)
 
 		/* Stop the hardware, regardless */
 		result = saa7164_vbi_stop_port(port);
-		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
+		if (result != SAA_OK) {
 			printk(KERN_ERR "%s() pause/forced stop transition "
 				"failed, res = 0x%x\n", __func__, result);
 		}
@@ -971,7 +971,7 @@ static int saa7164_vbi_start_streaming(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_vbi_acquire_port(port);
 		result = saa7164_vbi_stop_port(port);
-		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
+		if (result != SAA_OK) {
 			printk(KERN_ERR "%s() run/forced stop transition "
 				"failed, res = 0x%x\n", __func__, result);
 		}
