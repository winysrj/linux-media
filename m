Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbHKTR4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 15:17:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] c8sectpfe: don't go past channel_data array
Date: Tue, 11 Aug 2015 16:16:18 -0300
Message-Id: <1439320578-13951-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:365 find_channel() error: buffer overflow 'fei->channel_data' 8 <= 63

It seems that a cut-and-paste type of error occurred here:
the channel_data array size is C8SECTPFE_MAX_TSIN_CHAN, and not
C8SECTPFE_MAXCHANNEL.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 3a9109356e67..955d8daf055f 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -361,7 +361,7 @@ static struct channel_info *find_channel(struct c8sectpfei *fei, int tsin_num)
 {
 	int i;
 
-	for (i = 0; i < C8SECTPFE_MAXCHANNEL; i++) {
+	for (i = 0; i < C8SECTPFE_MAX_TSIN_CHAN; i++) {
 		if (!fei->channel_data[i])
 			continue;
 
-- 
2.4.3

