Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55280 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752237AbeCYVkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 17:40:35 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.17] v4l2-tpg-core.c: add space after %
Message-ID: <4a3e30aa-e7eb-150b-fd94-a63f96ec81c2@xs4all.nl>
Date: Sun, 25 Mar 2018 23:40:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I know, it's a measly space, but I can't stand it since the
V4L2_PIX_FMT_NV24 case before this case does it right.

So add the space in order to restore blessed symmetry and
consistency and to make the world whole again...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 37632bc524d4..9b64f4f354bf 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1149,7 +1149,7 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_NV42:
 		buf[0][offset] = r_y_h;
 		buf[1][2 * offset] = b_v;
-		buf[1][(2 * offset + 1) %8] = g_u_s;
+		buf[1][(2 * offset + 1) % 8] = g_u_s;
 		break;

 	case V4L2_PIX_FMT_YUYV:
