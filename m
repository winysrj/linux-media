Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56753 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3AOHzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 02:55:50 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] media: tvp514x: remove field description
Date: Tue, 15 Jan 2013 13:25:40 +0530
Message-Id: <1358236540-2091-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the field description of fields that no
longer exists, along side aligns the field description of
fields.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 include/media/tvp514x.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
index 74387e8..86ed7e8 100644
--- a/include/media/tvp514x.h
+++ b/include/media/tvp514x.h
@@ -96,12 +96,9 @@ enum tvp514x_output {
 
 /**
  * struct tvp514x_platform_data - Platform data values and access functions.
- * @power_set: Power state access function, zero is off, non-zero is on.
- * @ifparm: Interface parameters access function.
- * @priv_data_set: Device private data (pointer) access function.
  * @clk_polarity: Clock polarity of the current interface.
- * @ hs_polarity: HSYNC Polarity configuration for current interface.
- * @ vs_polarity: VSYNC Polarity configuration for current interface.
+ * @hs_polarity: HSYNC Polarity configuration for current interface.
+ * @vs_polarity: VSYNC Polarity configuration for current interface.
  */
 struct tvp514x_platform_data {
 	/* Interface control params */
-- 
1.7.4.1

