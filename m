Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46120 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2GRRlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 13:41:22 -0400
Received: by yenl2 with SMTP id l2so1843514yen.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 10:41:21 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] cx25821: Remove bad strcpy to read-only char*
Date: Wed, 18 Jul 2012 14:41:11 -0300
Message-Id: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The strcpy was being used to set the name of the board.
This was both wrong and redundant,
since the destination char* was read-only and
the name is set statically at compile time.

The type of the name field is changed to const char*
to prevent future errors.

Reported-by: Radek Masin <radek@masin.eu>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Hi Mauro,

I believe without this patch cx25821 driver
is completely unusable.

So perhaps this patch should also go to stable tree?
I'm a bit unsure about this procedure.

Regards,
Ezequiel.
 
---
 drivers/media/video/cx25821/cx25821-core.c |    3 ---
 drivers/media/video/cx25821/cx25821.h      |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
index 83c1aa6..f11f6f0 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -904,9 +904,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	list_add_tail(&dev->devlist, &cx25821_devlist);
 	mutex_unlock(&cx25821_devlist_mutex);
 
-	strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
-	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
-
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
diff --git a/drivers/media/video/cx25821/cx25821.h b/drivers/media/video/cx25821/cx25821.h
index b9aa801..029f293 100644
--- a/drivers/media/video/cx25821/cx25821.h
+++ b/drivers/media/video/cx25821/cx25821.h
@@ -187,7 +187,7 @@ enum port {
 };
 
 struct cx25821_board {
-	char *name;
+	const char *name;
 	enum port porta;
 	enum port portb;
 	enum port portc;
-- 
1.7.4.4

