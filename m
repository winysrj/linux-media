Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51585 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756749AbeDFOXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/21] media: omap_vout: fix wrong identing
Date: Fri,  6 Apr 2018 10:23:22 -0400
Message-Id: <c8630dfb45071c12c7021f21187490a57bd812ae.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned:
	drivers/media/platform/omap/omap_vout.c:711 omap_vout_buffer_setup() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/omap_vout.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index a795a9fae899..e2723fedac8d 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -702,19 +702,18 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		virt_addr = omap_vout_alloc_buffer(vout->buffer_size,
 				&phy_addr);
 		if (!virt_addr) {
-			if (ovid->rotation_type == VOUT_ROT_NONE) {
+			if (ovid->rotation_type == VOUT_ROT_NONE)
 				break;
-			} else {
-				if (!is_rotation_enabled(vout))
-					break;
+
+			if (!is_rotation_enabled(vout))
+				break;
+
 			/* Free the VRFB buffers if no space for V4L2 buffers */
 			for (j = i; j < *count; j++) {
-				omap_vout_free_buffer(
-						vout->smsshado_virt_addr[j],
-						vout->smsshado_size);
+				omap_vout_free_buffer(vout->smsshado_virt_addr[j],
+						      vout->smsshado_size);
 				vout->smsshado_virt_addr[j] = 0;
 				vout->smsshado_phy_addr[j] = 0;
-				}
 			}
 		}
 		vout->buf_virt_addr[i] = virt_addr;
-- 
2.14.3
