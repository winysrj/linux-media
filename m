Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36640 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeG0E60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:58:26 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/2] media: pci: cx88: Replace mdelay() with msleep() in cx88_card_setup_pre_i2c()
Date: Fri, 27 Jul 2018 11:38:23 +0800
Message-Id: <20180727033823.4148-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx88_card_setup_pre_i2c() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 4c92d2388c26..07e1483e987d 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3307,9 +3307,9 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
 	case CX88_BOARD_PROLINK_PV_8000GT:
 		cx_write(MO_GP2_IO, 0xcf7);
-		mdelay(50);
+		msleep(50);
 		cx_write(MO_GP2_IO, 0xef5);
-		mdelay(50);
+		msleep(50);
 		cx_write(MO_GP2_IO, 0xcf7);
 		usleep_range(10000, 20000);
 		break;
-- 
2.17.0
