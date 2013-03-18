Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4285 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3CRMck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/19] solo6x10: also stop DMA if the SOLO_PCI_ERR_P2M_DESC is raised.
Date: Mon, 18 Mar 2013 13:32:13 +0100
Message-Id: <1363609938-21735-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Otherwise the computer will hang.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/p2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 2292061..013f177 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -197,7 +197,7 @@ void solo_p2m_error_isr(struct solo_dev *solo_dev)
 	struct solo_p2m_dev *p2m_dev;
 	int i;
 
-	if (!(err & SOLO_PCI_ERR_P2M))
+	if (!(err & (SOLO_PCI_ERR_P2M | SOLO_PCI_ERR_P2M_DESC)))
 		return;
 
 	for (i = 0; i < SOLO_NR_P2M; i++) {
-- 
1.7.10.4

