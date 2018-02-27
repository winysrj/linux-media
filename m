Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59827 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbeB0RdC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 12:33:02 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        dylan.laduranty@mesotic.com, linux-media@vger.kernel.org
Subject: [PATCH] media: platform: renesas-ceu: Fix CSTRST_CPON mask
Date: Tue, 27 Feb 2018 18:32:52 +0100
Message-Id: <1519752772-1583-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSTRST_CPON mask was wrongly assigned to BIT(1) instead of BIT(0).
Fix that by changing the mask opportunely.

Reported-by: Dylan Laduranty <dylan.laduranty@mesotic.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
Mauro: could you please pick up this patch since you already applied the
CEU series to your tree if I'm not wrong?

Laurent, in this email exchange:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg123779.html
you asked me to measure the number of cycles required to fully reset the
interface in order to quantify the proper delay loops. I was testing this
using the wrong bit, and I always got 0, and I assumed 1usec was enough.
Good news is that I re-tested this on SH and RZ and I still have 0, so
no driver change is required apart from the bitmask one \o/

---
 drivers/media/platform/renesas-ceu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index cfabe1a..c7d3659 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -95,7 +95,7 @@

 /* CEU operating flag bit. */
 #define CEU_CAPCR_CTNCP			BIT(16)
-#define CEU_CSTRST_CPTON		BIT(1)
+#define CEU_CSTRST_CPTON		BIT(0)

 /* Platform specific IRQ source flags. */
 #define CEU_CETCR_ALL_IRQS_RZ		0x397f313
--
2.7.4
