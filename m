Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47461 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbeKIBtE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 20:49:04 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-tpg: array index could become negative
Message-ID: <6636d5b0-b0b6-aa50-d246-8405931127fd@xs4all.nl>
Date: Thu, 8 Nov 2018 17:12:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

text[s] is a signed char, so using that as index into the font8x16 array
can result in negative indices. Cast it to u8 to be safe.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: syzbot+ccf0a61ed12f2a7313ee@syzkaller.appspotmail.com
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index fa483b95bc5a..d9a590ae7545 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1769,7 +1769,7 @@ typedef struct { u16 __; u8 _; } __packed x24;
 		unsigned s;	\
 	\
 		for (s = 0; s < len; s++) {	\
-			u8 chr = font8x16[text[s] * 16 + line];	\
+			u8 chr = font8x16[(u8)text[s] * 16 + line];	\
 	\
 			if (hdiv == 2 && tpg->hflip) { \
 				pos[3] = (chr & (0x01 << 6) ? fg : bg);	\
