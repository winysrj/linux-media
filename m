Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29027 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751662AbdHGT2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 15:28:03 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] vs6624: constify vs6624_default_fmt
Date: Mon,  7 Aug 2017 21:02:32 +0200
Message-Id: <1502132552-2131-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure vs6624_default_fmt is only copied into another
structure field, so it can be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/i2c/vs6624.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index f0741ab..5607382 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -58,7 +58,7 @@ struct vs6624 {
 	},
 };
 
-static struct v4l2_mbus_framefmt vs6624_default_fmt = {
+static const struct v4l2_mbus_framefmt vs6624_default_fmt = {
 	.width = VGA_WIDTH,
 	.height = VGA_HEIGHT,
 	.code = MEDIA_BUS_FMT_UYVY8_2X8,
