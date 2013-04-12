Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:41545
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988Ab3DLKvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 06:51:31 -0400
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 1/2] [media] blackfin: add display support in ppi driver
Date: Fri, 12 Apr 2013 19:52:57 -0400
Message-ID: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/ppi.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 01b5b50..15e9c2b 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -266,6 +266,18 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 		bfin_write32(&reg->vcnt, params->height);
 		if (params->int_mask)
 			bfin_write32(&reg->imsk, params->int_mask & 0xFF);
+		if (ppi->ppi_control & PORT_DIR) {
+			u32 hsync_width, vsync_width, vsync_period;
+
+			hsync_width = params->hsync
+					* params->bpp / params->dlen;
+			vsync_width = params->vsync * samples_per_line;
+			vsync_period = samples_per_line * params->frame;
+			bfin_write32(&reg->fs1_wlhb, hsync_width);
+			bfin_write32(&reg->fs1_paspl, samples_per_line);
+			bfin_write32(&reg->fs2_wlvb, vsync_width);
+			bfin_write32(&reg->fs2_palpf, vsync_period);
+		}
 		break;
 	}
 	default:
-- 
1.7.0.4


