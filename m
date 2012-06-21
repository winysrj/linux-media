Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab2FUTxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:46 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so879477yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:46 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 05/10] staging: solo6x10: Remove format type mismatch warning
Date: Thu, 21 Jun 2012 16:52:07 -0300
Message-Id: <1340308332-1118-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch removes this warning:
warning: format ‘%d’ expects type ‘int’,
but argument 2 has type ‘long unsigned int’

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/tw28.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/solo6x10/tw28.c b/drivers/staging/media/solo6x10/tw28.c
index db56b42..f946f68 100644
--- a/drivers/staging/media/solo6x10/tw28.c
+++ b/drivers/staging/media/solo6x10/tw28.c
@@ -586,11 +586,11 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 		 solo_dev->tw28_cnt, solo_dev->tw28_cnt == 1 ? "" : "s");
 
 	if (solo_dev->tw2865)
-		printk(" tw2865[%d]", hweight32(solo_dev->tw2865));
+		printk(" tw2865[%lu]", hweight32(solo_dev->tw2865));
 	if (solo_dev->tw2864)
-		printk(" tw2864[%d]", hweight32(solo_dev->tw2864));
+		printk(" tw2864[%lu]", hweight32(solo_dev->tw2864));
 	if (solo_dev->tw2815)
-		printk(" tw2815[%d]", hweight32(solo_dev->tw2815));
+		printk(" tw2815[%lu]", hweight32(solo_dev->tw2815));
 	printk("\n");
 
 	return 0;
-- 
1.7.4.4

