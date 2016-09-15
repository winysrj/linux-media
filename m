Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:57215 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933940AbcIOMS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 08:18:57 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] [media] MAINTAINERS: Add entry for the Renesas VIN driver
Date: Thu, 15 Sep 2016 14:18:36 +0200
Message-Id: <20160915121836.23637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is maintained and supported, document it as such.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a12cd60..a4b5283 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7523,6 +7523,15 @@ F:	Documentation/devicetree/bindings/media/renesas,fcp.txt
 F:	drivers/media/platform/rcar-fcp.c
 F:	include/media/rcar-fcp.h
 
+MEDIA DRIVERS FOR RENESAS - VIN
+M:	Niklas Söderlund <niklas.soderlund@ragnatech.se>
+L:	linux-media@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	Documentation/devicetree/bindings/media/rcar_vin.txt
+F:	drivers/media/platform/rcar-vin/
+
 MEDIA DRIVERS FOR RENESAS - VSP1
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.9.3

