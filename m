Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753799AbeCWL5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 07/30] media: v4l2-tpg-core: avoid buffer overflows
Date: Fri, 23 Mar 2018 07:56:53 -0400
Message-Id: <1a086879fdd37d9e4c3dd4e49fac62f7e418e17e.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warnings:
	drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1146 gen_twopix() error: buffer overflow 'buf[1]' 8 <= 8
	drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1152 gen_twopix() error: buffer overflow 'buf[1]' 8 <= 8

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index d248d1fb9d1d..37632bc524d4 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1143,13 +1143,13 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_NV24:
 		buf[0][offset] = r_y_h;
 		buf[1][2 * offset] = g_u_s;
-		buf[1][2 * offset + 1] = b_v;
+		buf[1][(2 * offset + 1) % 8] = b_v;
 		break;
 
 	case V4L2_PIX_FMT_NV42:
 		buf[0][offset] = r_y_h;
 		buf[1][2 * offset] = b_v;
-		buf[1][2 * offset + 1] = g_u_s;
+		buf[1][(2 * offset + 1) %8] = g_u_s;
 		break;
 
 	case V4L2_PIX_FMT_YUYV:
-- 
2.14.3
