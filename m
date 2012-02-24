Return-path: <linux-media-owner@vger.kernel.org>
Received: from isp-bos-01.edutel.nl ([88.159.1.182]:46968 "EHLO
	isp-bos-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2BXR5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 12:57:41 -0500
From: linux@eikelenboom.it
To: linux-media@vger.kernel.org
Cc: shu.lin@conexant.com, hiep.huynh@conexant.com, stoth@linuxtv.org,
	hans.verkuil@cisco.com, mchehab@infradead.org,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: [PATCH] media/cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000
Date: Fri, 24 Feb 2012 18:23:10 +0100
Message-Id: <1330104190-1220-2-git-send-email-linux@eikelenboom.it>
In-Reply-To: <1330104190-1220-1-git-send-email-linux@eikelenboom.it>
References: <1330104190-1220-1-git-send-email-linux@eikelenboom.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sander Eikelenboom <linux@eikelenboom.it>

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 drivers/media/video/cx25821/cx25821-core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
index f617474..f51f790 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -1472,8 +1472,13 @@ static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
 		/* CX25821 Athena */
 		.vendor = 0x14f1,
 		.device = 0x8210,
-		.subvendor = 0x14f1,
-		.subdevice = 0x0920,
+	},
+	{
+		/* CX25821 No Brand */
+		.vendor = 0x14f1,
+		.device = 0x8210,
+		.subvendor = 0x0000,
+		.subdevice = 0x0000,
 	},
 	{
 		/* --- end of list --- */
-- 
1.7.2.5

