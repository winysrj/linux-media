Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3498 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3CRMcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 15/19] solo6x10: small big-endian fix.
Date: Mon, 18 Mar 2013 13:32:14 +0100
Message-Id: <1363609938-21735-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/disp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index 3dcaad9..7007006 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -181,7 +181,7 @@ static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 	int ret = 0;
 
 	for (i = 0; i < sizeof(buf) >> 1; i++)
-		buf[i] = val;
+		buf[i] = cpu_to_le16(val);
 
 	for (i = 0; i < reg_size; i += sizeof(buf))
 		ret |= solo_p2m_dma(solo_dev, 1, buf,
-- 
1.7.10.4

