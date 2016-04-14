Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:40758 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbcDNDZf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 23:25:35 -0400
From: zengzhaoxiu@163.com
To: linux-kernel@vger.kernel.org
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH V3 13/29] media: use parity8 in vivid-vbi-gen.c
Date: Thu, 14 Apr 2016 11:09:37 +0800
Message-Id: <1460603377-5126-1-git-send-email-zengzhaoxiu@163.com>
In-Reply-To: <1460601525-3822-1-git-send-email-zengzhaoxiu@163.com>
References: <1460601525-3822-1-git-send-email-zengzhaoxiu@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 drivers/media/platform/vivid/vivid-vbi-gen.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
index a2159de..d5ba0fc 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -175,14 +175,9 @@ static const u8 vivid_cc_sequence2[30] = {
 	0x14, 0x2f,	/* End of Caption */
 };
 
-static u8 calc_parity(u8 val)
+static inline u8 calc_parity(u8 val)
 {
-	unsigned i;
-	unsigned tot = 0;
-
-	for (i = 0; i < 7; i++)
-		tot += (val & (1 << i)) ? 1 : 0;
-	return val | ((tot & 1) ? 0 : 0x80);
+	return (!parity8(val) << 7) | val;
 }
 
 static void vivid_vbi_gen_set_time_of_day(u8 *packet)
-- 
2.5.0


