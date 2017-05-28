Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:50770 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdE1Ja6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:30:58 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-renesas-soc@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] [media] v4l: rcar_fdp1: use proper name for the R-Car SoC
Date: Sun, 28 May 2017 11:30:50 +0200
Message-Id: <20170528093051.11816-8-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
References: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 'R-Car', not 'RCar'. No code or binding changes, only descriptive text.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
I suggest this trivial patch should be picked individually per susbsystem.

 drivers/media/platform/rcar_fdp1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 42f25d241edd7c..0da0eba9202cdd 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1,5 +1,5 @@
 /*
- * Renesas RCar Fine Display Processor
+ * Renesas R-Car Fine Display Processor
  *
  * Video format converter and frame deinterlacer device.
  *
-- 
2.11.0
