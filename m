Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbeHGMMe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 08:12:34 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH] media: imx: shut up a false positive warning
Date: Tue,  7 Aug 2018 05:58:58 -0400
Message-Id: <132f3c7bb98673f713be9511de16b7622803df36.1533635936.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With imx, gcc produces a false positive warning:

	drivers/staging/media/imx/imx-media-csi.c: In function 'csi_idmac_setup_channel':
	drivers/staging/media/imx/imx-media-csi.c:457:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
	   if (passthrough) {
	      ^
	drivers/staging/media/imx/imx-media-csi.c:464:2: note: here
	  default:
	  ^~~~~~~

That's because the regex it uses for fall trough is not
good enough. So, rearrange the fall through comment in a way
that gcc will recognize.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/imx/imx-media-csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4647206f92ca..b7ffd231c64b 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -460,7 +460,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 			passthrough_cycles = incc->cycles;
 			break;
 		}
-		/* fallthrough for non-passthrough RGB565 (CSI-2 bus) */
+		/* for non-passthrough RGB565 (CSI-2 bus) */
+		/* Falls through */
 	default:
 		burst_size = (image.pix.width & 0xf) ? 8 : 16;
 		passthrough_bits = 16;
-- 
2.17.1
