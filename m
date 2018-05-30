Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42671 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968844AbeE3JNi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:13:38 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: ysato@users.sourceforge.jp, dalias@libc.org,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, linux-sh@vger.kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: arch: sh: migor: Fix TW9910 PDN gpio
Date: Wed, 30 May 2018 11:13:24 +0200
Message-Id: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TW9910 PDN gpio (power down) is listed as active high in the chip
manual. It turns out it is actually active low as when set to physical
level 0 it actually turns the video decoder power off.

Without this patch applied:
tw9910 0-0045: Product ID error 1f:2

With this patch applied:
tw9910 0-0045: tw9910 Product ID b:0

Fixes: commit "186c446f4b840bd77b79d3dc951ca436cb8abe79"

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
Hi,
   sending to both media and sh lists, as all previous CEU-related patches
went through Hans' tree, even the board specific parts.

Thanks
   j
---
 arch/sh/boards/mach-migor/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 271dfc2..3d7d004 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -359,7 +359,7 @@ static struct gpiod_lookup_table ov7725_gpios = {
 static struct gpiod_lookup_table tw9910_gpios = {
 	.dev_id		= "0-0045",
 	.table		= {
-		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT2, "pdn", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT2, "pdn", GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),
 	},
 };
--
2.7.4
