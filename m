Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40369
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754636AbdERMiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 08:38:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/5] [media] saa7164: better handle error codes
Date: Thu, 18 May 2017 09:38:36 -0300
Message-Id: <26c356e6512bc7227a5af0dac87d4afbd2063e01.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, the driver is doing the right thing for
PVC_ERRORCODE_UNKNOWN and PVC_ERRORCODE_INVALID_CONTROL:
for both, it returns an error code (SAA_ERR_NOT_SUPPORTED).

However, it is printing two error messages instead of one
on those cases.

Fix the logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7164/saa7164-cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
index 175015ca79f2..dfebd77ada59 100644
--- a/drivers/media/pci/saa7164/saa7164-cmd.c
+++ b/drivers/media/pci/saa7164/saa7164-cmd.c
@@ -506,6 +506,8 @@ int saa7164_cmd_send(struct saa7164_dev *dev, u8 id, enum tmComResCmd command,
 				dprintk(DBGLVL_CMD,
 					"%s() UNKNOWN OR INVALID CONTROL\n",
 					__func__);
+				ret = SAA_ERR_NOT_SUPPORTED;
+				break;
 			default:
 				dprintk(DBGLVL_CMD, "%s() UNKNOWN\n", __func__);
 				ret = SAA_ERR_NOT_SUPPORTED;
-- 
2.9.3
