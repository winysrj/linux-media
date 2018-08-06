Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbeHFQsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 12:48:35 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        kbingham@kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/4] MAINTAINERS: VSP1: Add co-maintainer
Date: Mon,  6 Aug 2018 15:39:02 +0100
Message-Id: <20180806143904.4716-2-kieran.bingham@ideasonboard.com>
In-Reply-To: <20180806143904.4716-1-kieran.bingham@ideasonboard.com>
References: <20180806143904.4716-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Add myself as a co-maintainer for the Renesas VSP driver.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c7cecb9201b3..6a30a5332b18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8935,6 +8935,7 @@ F:	drivers/media/platform/rcar-vin/
 
 MEDIA DRIVERS FOR RENESAS - VSP1
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+M:	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 L:	linux-renesas-soc@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-- 
2.17.1
