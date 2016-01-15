Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2397 "EHLO
	cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbcAOFXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 00:23:17 -0500
From: Xiubo Li <lixiubo@cmss.chinamobile.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: [PATCH 2/3] [media] dvbdev: the space is required after ','
Date: Fri, 15 Jan 2016 13:14:59 +0800
Message-Id: <1452834900-28360-3-git-send-email-lixiubo@cmss.chinamobile.com>
In-Reply-To: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The space is missing after ',', and this will be introduce much
noise when checking new patch around them.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/media/dvb-core/dvbdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index f38fabe..3b6e79e 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -58,7 +58,7 @@ static const char * const dnames[] = {
 #define DVB_MAX_IDS		MAX_DVB_MINORS
 #else
 #define DVB_MAX_IDS		4
-#define nums2minor(num,type,id)	((num << 6) | (id << 4) | type)
+#define nums2minor(num, type, id)	((num << 6) | (id << 4) | type)
 #define MAX_DVB_MINORS		(DVB_MAX_ADAPTERS*64)
 #endif
 
@@ -85,7 +85,7 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		file->private_data = dvbdev;
 		replace_fops(file, new_fops);
 		if (file->f_op->open)
-			err = file->f_op->open(inode,file);
+			err = file->f_op->open(inode, file);
 		up_read(&minor_rwsem);
 		mutex_unlock(&dvbdev_mutex);
 		return err;
@@ -867,7 +867,7 @@ int dvb_usercopy(struct file *file,
 			parg = sbuf;
 		} else {
 			/* too big to allocate from stack */
-			mbuf = kmalloc(_IOC_SIZE(cmd),GFP_KERNEL);
+			mbuf = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
 			if (NULL == mbuf)
 				return -ENOMEM;
 			parg = mbuf;
-- 
1.8.3.1



