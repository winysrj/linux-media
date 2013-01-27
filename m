Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:33363 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:59 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 6/7] saa7134: v4l2-compliance: remove V4L2_IN_ST_NO_SYNC from enum_input
Date: Sun, 27 Jan 2013 20:45:11 +0100
Message-Id: <1359315912-1767-7-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: don't set bogus V4L2_IN_ST_NO_SYNC
flag in enum_input as it's for digital video only

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 0b42f0c..fff6735 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1757,8 +1757,6 @@ static int saa7134_enum_input(struct file *file, void *priv,
 
 		if (0 != (v1 & 0x40))
 			i->status |= V4L2_IN_ST_NO_H_LOCK;
-		if (0 != (v2 & 0x40))
-			i->status |= V4L2_IN_ST_NO_SYNC;
 		if (0 != (v2 & 0x0e))
 			i->status |= V4L2_IN_ST_MACROVISION;
 	}
-- 
Ondrej Zary

