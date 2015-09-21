Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34733 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbbIUNgW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 09:36:22 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 25/38] staging: media: davinci_vpfe: fix ipipe_mode type
Date: Mon, 21 Sep 2015 15:33:57 +0200
Message-id: <1442842450-29769-26-git-send-email-a.hajda@samsung.com>
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variable can take negative values.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index 2a3a56b..b1d5e23 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -254,7 +254,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
 	void __iomem *ipipe_base = ipipe->base_addr;
 	struct v4l2_mbus_framefmt *outformat;
 	u32 color_pat;
-	u32 ipipe_mode;
+	int ipipe_mode;
 	u32 data_path;
 
 	/* enable clock to IPIPE */
-- 
1.9.1

