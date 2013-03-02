Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3727 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3CBXp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 20/20] solo6x10: also stop DMA if the SOLO_PCI_ERR_P2M_DESC is raised.
Date: Sun,  3 Mar 2013 00:45:36 +0100
Message-Id: <7cbef81c5bd2ac97a064ba7a77e7cea2f490d977.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Otherwise the computer will hang.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/disp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index b91a6e2..224aa46 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -149,7 +149,7 @@ static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 	int ret = 0;
 
 	for (i = 0; i < sizeof(buf) >> 1; i++)
-		buf[i] = val;
+		buf[i] = cpu_to_le16(val);
 
 	for (i = 0; i < reg_size; i += sizeof(buf))
 		ret |= solo_p2m_dma(solo_dev, SOLO_P2M_DMA_ID_VIN, 1, buf,
-- 
1.7.10.4

