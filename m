Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33805 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbcC0HGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2016 03:06:33 -0400
Subject: [PATCH 15/31] media: use parity8 in vivid-vbi-gen.c
References: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: "zhaoxiu.zeng" <zhaoxiu.zeng@gmail.com>
Message-ID: <56F7865A.1060206@gmail.com>
Date: Sun, 27 Mar 2016 15:06:02 +0800
MIME-Version: 1.0
In-Reply-To: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
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
2.5.5

