Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:34533 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759703Ab2FUQqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 12:46:07 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] media: no semicolon after switch
Date: Thu, 21 Jun 2012 18:46:05 +0200
Message-Id: <1340297165-4018-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Meerwald <p.meerwald@bct-electronic.com>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/media/video/omap3isp/ispccdc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 7e32331..b74f7e9 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -835,7 +835,7 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 	case 13:
 		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
 		break;
-	};
+	}
 
 	if (pipe->input)
 		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
@@ -991,7 +991,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	case 12:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
 		break;
-	};
+	}
 
 	if (syncif->fldmode)
 		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
-- 
1.7.9.5

