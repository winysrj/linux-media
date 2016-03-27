Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35994 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbcC0HKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2016 03:10:44 -0400
Subject: [PATCH 16/31] media: saa7115: use parity functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: "zhaoxiu.zeng" <zhaoxiu.zeng@gmail.com>
Message-ID: <56F78758.5050307@gmail.com>
Date: Sun, 27 Mar 2016 15:10:16 +0800
MIME-Version: 1.0
In-Reply-To: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
---
 drivers/media/i2c/saa7115.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index d2a1ce2..4c22df8 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -672,15 +672,6 @@ static const unsigned char saa7115_init_misc[] = {
 	0x00, 0x00
 };
 
-static int saa711x_odd_parity(u8 c)
-{
-	c ^= (c >> 4);
-	c ^= (c >> 2);
-	c ^= (c >> 1);
-
-	return c & 1;
-}
-
 static int saa711x_decode_vps(u8 *dst, u8 *p)
 {
 	static const u8 biphase_tbl[] = {
@@ -733,7 +724,6 @@ static int saa711x_decode_wss(u8 *p)
 	static const int wss_bits[8] = {
 		0, 0, 0, 1, 0, 1, 1, 1
 	};
-	unsigned char parity;
 	int wss = 0;
 	int i;
 
@@ -745,11 +735,8 @@ static int saa711x_decode_wss(u8 *p)
 			return -1;
 		wss |= b2 << i;
 	}
-	parity = wss & 15;
-	parity ^= parity >> 2;
-	parity ^= parity >> 1;
 
-	if (!(parity & 1))
+	if (!parity4(wss))
 		return -1;
 
 	return wss;
@@ -1235,7 +1222,7 @@ static int saa711x_decode_vbi_line(struct v4l2_subdev *sd, struct v4l2_decode_vb
 		vbi->type = V4L2_SLICED_TELETEXT_B;
 		break;
 	case 4:
-		if (!saa711x_odd_parity(p[0]) || !saa711x_odd_parity(p[1]))
+		if (!parity8(p[0]) || !parity8(p[1]))
 			return 0;
 		vbi->type = V4L2_SLICED_CAPTION_525;
 		break;
-- 
2.5.5

