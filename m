Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3748 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3CBXqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:46:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 19/20] solo6x10: small big-endian fix.
Date: Sun,  3 Mar 2013 00:45:35 +0100
Message-Id: <a50cb0941a4fe738d28391c25ff2f5bd90ece025.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/p2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 65911fa..1b5b129 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -261,7 +261,7 @@ void solo_p2m_error_isr(struct solo_dev *solo_dev, u32 status)
 	struct solo_p2m_dev *p2m_dev;
 	int i;
 
-	if (!(status & SOLO_PCI_ERR_P2M))
+	if (!(status & (SOLO_PCI_ERR_P2M | SOLO_PCI_ERR_P2M_DESC)))
 		return;
 
 	for (i = 0; i < SOLO_NR_P2M; i++) {
-- 
1.7.10.4

