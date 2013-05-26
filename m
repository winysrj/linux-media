Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61617 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3EZMC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 08:02:26 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 3/9] media: davinci: vpif: remove unnecessary braces around defines
Date: Sun, 26 May 2013 17:30:06 +0530
Message-Id: <1369569612-30915-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes unnecessary braces around defines.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index f857d8f..77763f1 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -32,10 +32,10 @@
 MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
 MODULE_LICENSE("GPL");
 
-#define VPIF_CH0_MAX_MODES	(22)
-#define VPIF_CH1_MAX_MODES	(02)
-#define VPIF_CH2_MAX_MODES	(15)
-#define VPIF_CH3_MAX_MODES	(02)
+#define VPIF_CH0_MAX_MODES	22
+#define VPIF_CH1_MAX_MODES	2
+#define VPIF_CH2_MAX_MODES	15
+#define VPIF_CH3_MAX_MODES	2
 
 spinlock_t vpif_lock;
 
-- 
1.7.0.4

