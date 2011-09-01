Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1IAG1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 02:27:23 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] tm6000: Enable fast USB quirk on Cinergy Hybrid
Date: Thu,  1 Sep 2011 08:27:21 +0200
Message-Id: <1314858441-30813-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1314858441-30813-1-git-send-email-thierry.reding@avionic-design.de>
References: <4E5F1C87.9050207@redhat.com>
 <1314858441-30813-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cinergy Hybrid cards are known not to need an artificial delay after
USB accesses so the quirk can safely be enabled.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 5393976..aa18173 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -1002,6 +1002,16 @@ static int fill_board_specific_data(struct tm6000_core *dev)
 	dev->vinput[2] = tm6000_boards[dev->model].vinput[2];
 	dev->rinput = tm6000_boards[dev->model].rinput;
 
+	/* setup per-model quirks */
+	switch (dev->model) {
+	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		dev->quirks |= TM6000_QUIRK_NO_USB_DELAY;
+		break;
+
+	default:
+		break;
+	}
+
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
-- 
1.7.6.1

