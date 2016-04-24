Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33152 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbcDXVKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so17688203wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:20 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 07/24] v4l: of: Call CSI2 bus csi2, not csi
Date: Mon, 25 Apr 2016 00:08:07 +0300
Message-Id: <1461532104-24032-8-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The function to parse CSI2 bus parameters was called
v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
anticipation of CSI1/CCP2 support.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 93b3368..f2618fd 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -20,7 +20,7 @@
 
 #include <media/v4l2-of.h>
 
-static int v4l2_of_parse_csi_bus(const struct device_node *node,
+static int v4l2_of_parse_csi2_bus(const struct device_node *node,
 				 struct v4l2_of_endpoint *endpoint)
 {
 	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
@@ -158,7 +158,7 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
 	       offsetof(typeof(*endpoint), bus_type));
 
-	rval = v4l2_of_parse_csi_bus(node, endpoint);
+	rval = v4l2_of_parse_csi2_bus(node, endpoint);
 	if (rval)
 		return rval;
 	/*
-- 
1.9.1

