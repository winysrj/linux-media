Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3957 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1HYOIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/12] mantis: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:33 +0200
Message-Id: <1aaa08d7c38286c8b0cd9d54befee3df1c9100e1.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/dvb/mantis/hopper_cards.c: In function 'hopper_irq_handler':
v4l-dvb-git/drivers/media/dvb/mantis/hopper_cards.c:68:37: warning: variable 'mstat' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/dvb/mantis/mantis_cards.c: In function 'mantis_irq_handler':
v4l-dvb-git/drivers/media/dvb/mantis/mantis_cards.c:76:37: warning: variable 'mstat' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/mantis/hopper_cards.c |    4 ++--
 drivers/media/dvb/mantis/mantis_cards.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 1402062..8bbeebc 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -65,7 +65,7 @@ static int devs;
 
 static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0, mstat = 0;
+	u32 stat = 0, mask = 0, lstat = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -80,7 +80,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	mstat = lstat = stat & ~MANTIS_INT_RISCSTAT;
+	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index 05cbb9d..e6c8368 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -73,7 +73,7 @@ static char *label[10] = {
 
 static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0, mstat = 0;
+	u32 stat = 0, mask = 0, lstat = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -88,7 +88,7 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	mstat = lstat = stat & ~MANTIS_INT_RISCSTAT;
+	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
-- 
1.7.5.4

