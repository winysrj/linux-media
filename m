Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45302 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbcAGS3B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 13:29:01 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 8/8] [media] omap3isp: Check v4l2_of_parse_endpoint() return value
Date: Thu,  7 Jan 2016 15:27:22 -0300
Message-Id: <1452191248-15847-9-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/omap3isp/isp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 79a0b953bba3..891e54394a1c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2235,8 +2235,11 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 	struct isp_bus_cfg *buscfg = &isd->bus;
 	struct v4l2_of_endpoint vep;
 	unsigned int i;
+	int ret;
 
-	v4l2_of_parse_endpoint(node, &vep);
+	ret = v4l2_of_parse_endpoint(node, &vep);
+	if (ret)
+		return ret;
 
 	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
 		vep.base.port);
-- 
2.4.3

