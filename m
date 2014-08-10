Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62096 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaHJUaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 16:30:20 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so3267656wib.16
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 13:30:19 -0700 (PDT)
From: Andreas Ruprecht <rupran@einserver.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] drivers: media: pci: Makefile: Remove duplicate subdirectory from obj-y
Date: Sun, 10 Aug 2014 22:30:18 +0200
Message-Id: <1407702618-17808-1-git-send-email-rupran@einserver.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the list of subdirectories compiled, b2c2/ appears twice.

This patch removes one of the appearances.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/media/pci/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index e5b53fb..dc2ebbe 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -10,7 +10,6 @@ obj-y        +=	ttpci/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
-		b2c2/		\
 		saa7146/
 
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
-- 
1.9.1

