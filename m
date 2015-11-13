Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6945 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbbKMLuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 06:50:10 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] [media] radio-shark2: constify radio_tea5777_ops structures
Date: Fri, 13 Nov 2015 12:38:32 +0100
Message-Id: <1447414712-26586-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The radio_tea5777_ops structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/radio/radio-shark2.c  |    2 +-
 drivers/media/radio/radio-tea5777.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-tea5777.h b/drivers/media/radio/radio-tea5777.h
index 4ea43a9..4bd9425 100644
--- a/drivers/media/radio/radio-tea5777.h
+++ b/drivers/media/radio/radio-tea5777.h
@@ -76,7 +76,7 @@ struct radio_tea5777 {
 	u32 read_reg;
 	u64 write_reg;
 	struct mutex mutex;
-	struct radio_tea5777_ops *ops;
+	const struct radio_tea5777_ops *ops;
 	void *private_data;
 	u8 card[32];
 	u8 bus_info[32];
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 8654e0d..0e65a85 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -137,7 +137,7 @@ static int shark_read_reg(struct radio_tea5777 *tea, u32 *reg_ret)
 	return 0;
 }
 
-static struct radio_tea5777_ops shark_tea_ops = {
+static const struct radio_tea5777_ops shark_tea_ops = {
 	.write_reg = shark_write_reg,
 	.read_reg  = shark_read_reg,
 };

