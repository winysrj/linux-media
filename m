Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64068 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbaFRWbk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 18:31:40 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] [media] v4l: omap4iss: configuration using uninitialized variable
Date: Thu, 19 Jun 2014 00:31:27 +0200
Message-Id: <1403130687-28598-1-git-send-email-xypron.glpk@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Variable reg is not initialized.
Random values are written to OMAP4 ISS registers if !ctx->eof_enabled.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/media/omap4iss/iss_csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index bf8a657..9ae4871 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -317,7 +317,7 @@ static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
 static void csi2_ctx_config(struct iss_csi2_device *csi2,
 			    struct iss_csi2_ctx_cfg *ctx)
 {
-	u32 reg;
+	u32 reg = 0;
 
 	/* Set up CSI2_CTx_CTRL1 */
 	if (ctx->eof_enabled)
-- 
2.0.0

