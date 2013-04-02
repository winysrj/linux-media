Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761757Ab3DBQ2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:28:13 -0400
Date: Tue, 2 Apr 2013 18:28:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] DT: export of_get_next_parent() for use by modules: fix
 modular V4L2
Message-ID: <Pine.LNX.4.64.1304021825130.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently modular V4L2 build with enabled OF is broken dur to the
of_get_next_parent() function being unavailable to modules. Export it to
fix the build.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This is for 3.10

 drivers/of/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..1733081 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -382,6 +382,7 @@ struct device_node *of_get_next_parent(struct device_node *node)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return parent;
 }
+EXPORT_SYMBOL(of_get_next_parent);
 
 /**
  *	of_get_next_child - Iterate a node childs
-- 
1.7.2.5

