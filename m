Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:48777 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdB1MDr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 07:03:47 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [RFC 1/1] omap3isp: Ignore endpoints with invalid configuration
Date: Tue, 28 Feb 2017 14:02:30 +0200
Message-Id: <1488283350-5695-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If endpoint has an invalid configuration, ignore it instead of happily
proceeding to use it nonetheless. Ignoring such an endpoint is better than
failing since there could be multiple endpoints, only some of which are
bad.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Pavel,

How about this one? isp_fwnode_parse() is expected to return an error if
there's one but currently it's quite shy. With this patch, the faulty
endpoint is simply ignored. This is completely untested so far.

 drivers/media/platform/omap3isp/isp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 95850b9..8026221 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2120,10 +2120,12 @@ static int isp_fwnodes_parse(struct device *dev,
 		if (!isd)
 			goto error;
 
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
+		if (isp_fwnode_parse(dev, fwn, isd)) {
+			devm_kfree(dev, isd);
+			continue;
+		}
 
-		if (isp_fwnode_parse(dev, fwn, isd))
-			goto error;
+		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
 
 		isd->asd.match.fwnode.fwn =
 			fwnode_graph_get_remote_port_parent(fwn);
-- 
2.7.4
