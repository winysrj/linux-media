Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2FUTxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:52 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so879477yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:52 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 07/10] staging: solo6x10: Merge quoted string split across lines
Date: Thu, 21 Jun 2012 16:52:09 -0300
Message-Id: <1340308332-1118-7-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/core.c |    4 ++--
 drivers/staging/media/solo6x10/v4l2.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index 8c4f5cf..2cfe906 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -174,8 +174,8 @@ static int __devinit solo_pci_probe(struct pci_dev *pdev,
 		solo_dev->nr_ext = 2;
 		break;
 	default:
-		dev_warn(&pdev->dev, "Invalid chip_id 0x%02x, "
-			 "defaulting to 4 channels\n",
+		dev_warn(&pdev->dev,
+			 "Invalid chip_id 0x%02x, defaulting to 4 channels\n",
 			 chip_id);
 	case 5:
 		solo_dev->nr_chans = 4;
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 571c3a3..90e1379 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -933,9 +933,9 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	if (video_nr != -1)
 		video_nr++;
 
-	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
-		 "%d inputs (%d extended)\n", solo_dev->vfd->num,
-		 solo_dev->nr_chans, solo_dev->nr_ext);
+	dev_info(&solo_dev->pdev->dev,
+		"Display as /dev/video%d with %d inputs (%d extended)\n",
+		 solo_dev->vfd->num, solo_dev->nr_chans, solo_dev->nr_ext);
 
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
-- 
1.7.4.4

