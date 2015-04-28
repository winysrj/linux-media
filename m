Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:8146 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbbD1LMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 07:12:15 -0400
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 07/12] trivial: [media] cx25821: cx25821-medusa-reg.h: fix 0x0x prefix
Date: Tue, 28 Apr 2015 13:11:26 +0200
Message-Id: <1430219491-5076-8-git-send-email-ao2@ao2.it>
In-Reply-To: <1430219491-5076-1-git-send-email-ao2@ao2.it>
References: <1430219491-5076-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the 0x0x prefix in integer constants.

In this case a padding 0 must also be inserted to make the constants
look like all the other 16 bits ones.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/pci/cx25821/cx25821-medusa-reg.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-medusa-reg.h b/drivers/media/pci/cx25821/cx25821-medusa-reg.h
index c98ac94..2e10643 100644
--- a/drivers/media/pci/cx25821/cx25821-medusa-reg.h
+++ b/drivers/media/pci/cx25821/cx25821-medusa-reg.h
@@ -84,9 +84,9 @@
 #define	ABIST_BIN4_VGA3				0x01D4
 #define	ABIST_BIN5_VGA4				0x01D8
 #define	ABIST_BIN6_VGA5				0x01DC
-#define	ABIST_BIN7_VGA6				0x0x1E0
-#define	ABIST_CLAMP_A				0x0x1E4
-#define	ABIST_CLAMP_B				0x0x1E8
+#define	ABIST_BIN7_VGA6				0x01E0
+#define	ABIST_CLAMP_A				0x01E4
+#define	ABIST_CLAMP_B				0x01E8
 #define	ABIST_CLAMP_C				0x01EC
 #define	ABIST_CLAMP_D				0x01F0
 #define	ABIST_CLAMP_E				0x01F4
-- 
2.1.4

