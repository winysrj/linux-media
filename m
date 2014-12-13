Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50108 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/10] budget-core: fix sparse warnings
Date: Sat, 13 Dec 2014 12:52:52 +0100
Message-Id: <1418471580-26510-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixes these sparse warnings.

drivers/media/pci/ttpci/budget-core.c:250:17: warning: context imbalance in 'ttpci_budget_debiread' - different lock contexts for basic block
drivers/media/pci/ttpci/budget-core.c:289:17: warning: context imbalance in 'ttpci_budget_debiwrite' - different lock contexts for basic block

To be honest, the new code does look better than the old.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ttpci/budget-core.c | 89 +++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index 37d02fe..23e0549 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -231,63 +231,59 @@ static void vpeirq(unsigned long data)
 }
 
 
-int ttpci_budget_debiread(struct budget *budget, u32 config, int addr, int count,
-			  int uselocks, int nobusyloop)
+static int ttpci_budget_debiread_nolock(struct budget *budget, u32 config,
+		int addr, int count, int nobusyloop)
 {
 	struct saa7146_dev *saa = budget->dev;
-	int result = 0;
-	unsigned long flags = 0;
-
-	if (count > 4 || count <= 0)
-		return 0;
-
-	if (uselocks)
-		spin_lock_irqsave(&budget->debilock, flags);
+	int result;
 
-	if ((result = saa7146_wait_for_debi_done(saa, nobusyloop)) < 0) {
-		if (uselocks)
-			spin_unlock_irqrestore(&budget->debilock, flags);
+	result = saa7146_wait_for_debi_done(saa, nobusyloop);
+	if (result < 0)
 		return result;
-	}
 
 	saa7146_write(saa, DEBI_COMMAND, (count << 17) | 0x10000 | (addr & 0xffff));
 	saa7146_write(saa, DEBI_CONFIG, config);
 	saa7146_write(saa, DEBI_PAGE, 0);
 	saa7146_write(saa, MC2, (2 << 16) | 2);
 
-	if ((result = saa7146_wait_for_debi_done(saa, nobusyloop)) < 0) {
-		if (uselocks)
-			spin_unlock_irqrestore(&budget->debilock, flags);
+	result = saa7146_wait_for_debi_done(saa, nobusyloop);
+	if (result < 0)
 		return result;
-	}
 
 	result = saa7146_read(saa, DEBI_AD);
 	result &= (0xffffffffUL >> ((4 - count) * 8));
-
-	if (uselocks)
-		spin_unlock_irqrestore(&budget->debilock, flags);
-
 	return result;
 }
 
-int ttpci_budget_debiwrite(struct budget *budget, u32 config, int addr,
-			   int count, u32 value, int uselocks, int nobusyloop)
+int ttpci_budget_debiread(struct budget *budget, u32 config, int addr, int count,
+			  int uselocks, int nobusyloop)
 {
-	struct saa7146_dev *saa = budget->dev;
-	unsigned long flags = 0;
-	int result;
-
 	if (count > 4 || count <= 0)
 		return 0;
 
-	if (uselocks)
-		spin_lock_irqsave(&budget->debilock, flags);
+	if (uselocks) {
+		unsigned long flags;
+		int result;
 
-	if ((result = saa7146_wait_for_debi_done(saa, nobusyloop)) < 0) {
-		if (uselocks)
-			spin_unlock_irqrestore(&budget->debilock, flags);
+		spin_lock_irqsave(&budget->debilock, flags);
+		result = ttpci_budget_debiread_nolock(budget, config, addr,
+						      count, nobusyloop);
+		spin_unlock_irqrestore(&budget->debilock, flags);
 		return result;
 	}
+	return ttpci_budget_debiread_nolock(budget, config, addr,
+					    count, nobusyloop);
+}
+
+static int ttpci_budget_debiwrite_nolock(struct budget *budget, u32 config,
+		int addr, int count, u32 value, int nobusyloop)
+{
+	struct saa7146_dev *saa = budget->dev;
+	int result;
+
+	result = saa7146_wait_for_debi_done(saa, nobusyloop);
+	if (result < 0)
+		return result;
 
 	saa7146_write(saa, DEBI_COMMAND, (count << 17) | 0x00000 | (addr & 0xffff));
 	saa7146_write(saa, DEBI_CONFIG, config);
@@ -295,15 +291,28 @@ int ttpci_budget_debiwrite(struct budget *budget, u32 config, int addr,
 	saa7146_write(saa, DEBI_AD, value);
 	saa7146_write(saa, MC2, (2 << 16) | 2);
 
-	if ((result = saa7146_wait_for_debi_done(saa, nobusyloop)) < 0) {
-		if (uselocks)
-			spin_unlock_irqrestore(&budget->debilock, flags);
-		return result;
-	}
+	result = saa7146_wait_for_debi_done(saa, nobusyloop);
+	return result < 0 ? result : 0;
+}
 
-	if (uselocks)
+int ttpci_budget_debiwrite(struct budget *budget, u32 config, int addr,
+			   int count, u32 value, int uselocks, int nobusyloop)
+{
+	if (count > 4 || count <= 0)
+		return 0;
+
+	if (uselocks) {
+		unsigned long flags;
+		int result;
+
+		spin_lock_irqsave(&budget->debilock, flags);
+		result = ttpci_budget_debiwrite_nolock(budget, config, addr,
+						count, value, nobusyloop);
 		spin_unlock_irqrestore(&budget->debilock, flags);
-	return 0;
+		return result;
+	}
+	return ttpci_budget_debiwrite_nolock(budget, config, addr,
+					     count, value, nobusyloop);
 }
 
 
-- 
2.1.3

