Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57603 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2ENVBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 17:01:34 -0400
Received: by weyu7 with SMTP id u7so2069074wey.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 14:01:33 -0700 (PDT)
Message-ID: <1337029277.6384.2.camel@router7789>
Subject: [PATCH] rc-it913x=v2 Incorrect assigned KEY_1
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 14 May 2012 22:01:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct incorrect scancode for KEY_1

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/rc/keymaps/rc-it913x-v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/keymaps/rc-it913x-v2.c b/drivers/media/rc/keymaps/rc-it913x-v2.c
index 28e376e..bd42a30 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v2.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v2.c
@@ -40,7 +40,7 @@ static struct rc_map_table it913x_v2_rc[] = {
 	/* Type 2 */
 	/* keys stereo, snapshot unassigned */
 	{ 0x866b00, KEY_0 },
-	{ 0x866b1b, KEY_1 },
+	{ 0x866b01, KEY_1 },
 	{ 0x866b02, KEY_2 },
 	{ 0x866b03, KEY_3 },
 	{ 0x866b04, KEY_4 },
-- 
1.7.9.5


