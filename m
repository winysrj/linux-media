Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46448
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751073AbdESMKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        mjpeg-users@lists.sourceforge.net
Subject: [PATCH 3/6] [media] zoran: annotate switch fall through
Date: Fri, 19 May 2017 09:10:01 -0300
Message-Id: <9ca3ae0d5e46a48b7eaf4afcdc68887e32692c17.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two cases here that it does a switch fall through.
Annotate it, in order to shut up gcc warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 180f3d7af3e1..a11cb501c550 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -534,6 +534,7 @@ static int zoran_v4l_queue_frame(struct zoran_fh *fh, int num)
 				KERN_WARNING
 				"%s: %s - queueing buffer %d in state DONE!?\n",
 				ZR_DEVNAME(zr), __func__, num);
+			/* fall through */
 		case BUZ_STATE_USER:
 			/* since there is at least one unused buffer there's room for at least
 			 * one more pend[] entry */
@@ -693,6 +694,7 @@ static int zoran_jpg_queue_frame(struct zoran_fh *fh, int num,
 				KERN_WARNING
 				"%s: %s - queing frame in BUZ_STATE_DONE state!?\n",
 				ZR_DEVNAME(zr), __func__);
+			/* fall through */
 		case BUZ_STATE_USER:
 			/* since there is at least one unused buffer there's room for at
 			 *least one more pend[] entry */
-- 
2.9.3
