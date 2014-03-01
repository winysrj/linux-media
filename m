Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20992 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaCANwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 08:52:33 -0500
Date: Sat, 1 Mar 2014 16:51:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] av7110_hw: fix a sanity check in av7110_fw_cmd()
Message-ID: <20140301135136.GA23929@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ARRAY_SIZE(buf) (8 elements) was intended instead of sizeof(buf) (16
bytes).  But this is just a sanity check and the callers always pass
valid values so this doesn't cause a problem.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index 6299d5dadb82..300bd3c94738 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -501,7 +501,7 @@ int av7110_fw_cmd(struct av7110 *av7110, int type, int com, int num, ...)
 
 //	dprintk(4, "%p\n", av7110);
 
-	if (2 + num > sizeof(buf)) {
+	if (2 + num > ARRAY_SIZE(buf)) {
 		printk(KERN_WARNING
 		       "%s: %s len=%d is too big!\n",
 		       KBUILD_MODNAME, __func__, num);
