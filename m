Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38156 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFIPVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 11:21:50 -0400
Date: Mon, 9 Jun 2014 18:21:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] zoran: remove duplicate ZR050_MO_COMP define
Message-ID: <20140609152135.GQ9600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ZR050_MO_COMP define is cut and pasted twice so we can delete the
second instance.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/zoran/zr36050.h b/drivers/media/pci/zoran/zr36050.h
index 9f52f0c..ea083ad 100644
--- a/drivers/media/pci/zoran/zr36050.h
+++ b/drivers/media/pci/zoran/zr36050.h
@@ -126,7 +126,6 @@ struct zr36050 {
 /* zr36050 mode register bits */
 
 #define ZR050_MO_COMP                0x80
-#define ZR050_MO_COMP                0x80
 #define ZR050_MO_ATP                 0x40
 #define ZR050_MO_PASS2               0x20
 #define ZR050_MO_TLM                 0x10
