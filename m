Return-path: <linux-media-owner@vger.kernel.org>
Received: from isp-bos-02.edutel.nl ([88.159.1.183]:54349 "EHLO
	isp-bos-01.edutel.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755690Ab2BXSz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 13:55:27 -0500
From: linux@eikelenboom.it
To: linux-media@vger.kernel.org
Cc: shu.lin@conexant.com, hiep.huynh@conexant.com, stoth@linuxtv.org,
	hans.verkuil@cisco.com, mchehab@infradead.org,
	S Eikelenboom <linux@eikelenboom.it>
Subject: [PATCH] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000
Date: Fri, 24 Feb 2012 19:49:42 +0100
Message-Id: <1330109382-16505-2-git-send-email-linux@eikelenboom.it>
In-Reply-To: <1330109382-16505-1-git-send-email-linux@eikelenboom.it>
References: <1330109382-16505-1-git-send-email-linux@eikelenboom.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: S Eikelenboom <linux@eikelenboom.it>

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 drivers/media/video/cx25821/cx25821-core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
index f617474..a69ea04 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -1475,6 +1475,13 @@ static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
 		.subvendor = 0x14f1,
 		.subdevice = 0x0920,
 	},
+        {
+                /* CX25821 No Brand */
+                .vendor = 0x14f1,
+                .device = 0x8210,
+                .subvendor = 0x0000,
+                .subdevice = 0x0000,
+        },
 	{
 		/* --- end of list --- */
 	}
-- 
1.7.2.5

