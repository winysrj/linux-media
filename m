Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753814AbdJPX21 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:28:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Hans Verkuil <hansverk@cisco.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH] media: rga: make some functions static
Date: Mon, 16 Oct 2017 16:28:10 -0700
Message-Id: <ec8df85f312e299e6d92f7cc3446e67e510ccafb.1508196474.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/rockchip/rga/rga-hw.c:383:6: warning: no previous prototype for 'rga_cmd_set' [-Wmissing-prototypes]
 void rga_cmd_set(struct rga_ctx *ctx)
      ^~~~~~~~~~~
drivers/media/platform/rockchip/rga/rga.c:359:17: warning: no previous prototype for 'rga_fmt_find' [-Wmissing-prototypes]
 struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
                 ^~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 2 +-
 drivers/media/platform/rockchip/rga/rga.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index 0645481c9a5e..96d1b1b3fe8e 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -380,7 +380,7 @@ static void rga_cmd_set_mode(struct rga_ctx *ctx)
 	dest[(RGA_MODE_CTRL - RGA_MODE_BASE_REG) >> 2] = mode.val;
 }
 
-void rga_cmd_set(struct rga_ctx *ctx)
+static void rga_cmd_set(struct rga_ctx *ctx)
 {
 	struct rockchip_rga *rga = ctx->rga;
 
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 2cf3bb29a2b3..e7d1b34baf1c 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -356,7 +356,7 @@ struct rga_fmt formats[] = {
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
 
-struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
+static struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
 {
 	unsigned int i;
 
-- 
2.13.6
