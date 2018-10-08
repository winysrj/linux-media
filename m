Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54374 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbeJICVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 22:21:44 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix kernel oops when enabling HFLIP and OSD
Message-ID: <407e067b-47be-e8da-848d-edb6c04f5c1c@xs4all.nl>
Date: Mon, 8 Oct 2018 21:08:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the OSD is on (i.e. vivid displays text on top of the test pattern), and
you enable hflip, then the driver crashes.

The cause turned out to be a division of a negative number by an unsigned value.
You expect that -8 / 2 would be -4, but in reality it is 2147483644 :-(

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index f3d9c1140ffa..e76f87dc4368 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1773,7 +1773,7 @@ typedef struct { u16 __; u8 _; } __packed x24;
 				pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
 			} \
 	\
-			pos += (tpg->hflip ? -8 : 8) / hdiv;	\
+			pos += (tpg->hflip ? -8 : 8) / (int)hdiv;	\
 		}	\
 	}	\
 } while (0)
