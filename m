Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:44079 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932840AbdBQHNA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 02:13:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 22/35] drivers/media: Convert remaining use of pr_warning to pr_warn
Date: Thu, 16 Feb 2017 23:11:35 -0800
Message-Id: <b47856d4b3a020cff303dc03fac17b85dae297c4.1487314667.git.joe@perches.com>
In-Reply-To: <cover.1487314666.git.joe@perches.com>
References: <cover.1487314666.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To enable eventual removal of pr_warning

This makes pr_warn use consistent for drivers/media

Prior to this patch, there was 1 use of pr_warning and
310 uses of pr_warn in drivers/media

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/platform/sh_vou.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index ef2a519bcd4c..992d61a8b961 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -813,8 +813,8 @@ static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
 {
 	switch (bus_fmt) {
 	default:
-		pr_warning("%s(): Invalid bus-format code %d, using default 8-bit\n",
-			   __func__, bus_fmt);
+		pr_warn("%s(): Invalid bus-format code %d, using default 8-bit\n",
+			__func__, bus_fmt);
 	case SH_VOU_BUS_8BIT:
 		return 1;
 	case SH_VOU_BUS_16BIT:
-- 
2.10.0.rc2.1.g053435c
