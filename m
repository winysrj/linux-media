Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2AESsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 13:48:21 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05ImLx1012118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 13:48:21 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2] [media] dvb_frontend: Update the dynamic info->type
Date: Thu,  5 Jan 2012 16:47:15 -0200
Message-Id: <1325789235-16924-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-6-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-6-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of changing the ops.info.type struct, updates only
the data that will be returned to userspace.

Also add some debug messages to help tracking such issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index cd3c0f6..128f677 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1551,6 +1551,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 			}
 		}
 	}
+	dprintk("change delivery system on cache to %d\n", c->delivery_system);
+
 	return 0;
 }
 
@@ -1965,6 +1967,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	switch (cmd) {
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
+
 		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
 		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
 
@@ -1981,16 +1984,16 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		 */
 		switch (dvbv3_type(c->delivery_system)) {
 		case DVBV3_QPSK:
-			fe->ops.info.type = FE_QPSK;
+			info->type = FE_QPSK;
 			break;
 		case DVBV3_ATSC:
-			fe->ops.info.type = FE_ATSC;
+			info->type = FE_ATSC;
 			break;
 		case DVBV3_QAM:
-			fe->ops.info.type = FE_QAM;
+			info->type = FE_QAM;
 			break;
 		case DVBV3_OFDM:
-			fe->ops.info.type = FE_OFDM;
+			info->type = FE_OFDM;
 			break;
 		default:
 			printk(KERN_ERR
@@ -1998,6 +2001,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			       __func__, c->delivery_system);
 			fe->ops.info.type = FE_OFDM;
 		}
+		dprintk("current delivery system on cache: %d, V3 type: %d\n",
+			c->delivery_system, fe->ops.info.type);
 
 		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
 		 * do it, it is done for it. */
-- 
1.7.7.5

