Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1CPUYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:37 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOaTP021250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/6] imon: add more panel scancode mappings
Date: Wed, 16 Mar 2011 16:24:27 -0400
Message-Id: <1300307071-19665-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index e7dc6b4..f714e1a 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -277,12 +277,21 @@ static const struct {
 	u64 hw_code;
 	u32 keycode;
 } imon_panel_key_table[] = {
-	{ 0x000000000f00ffeell, KEY_PROG1 }, /* Go */
+	{ 0x000000000f00ffeell, KEY_MEDIA }, /* Go */
+	{ 0x000000001200ffeell, KEY_UP },
+	{ 0x000000001300ffeell, KEY_DOWN },
+	{ 0x000000001400ffeell, KEY_LEFT },
+	{ 0x000000001500ffeell, KEY_RIGHT },
+	{ 0x000000001600ffeell, KEY_ENTER },
+	{ 0x000000001700ffeell, KEY_ESC },
 	{ 0x000000001f00ffeell, KEY_AUDIO },
 	{ 0x000000002000ffeell, KEY_VIDEO },
 	{ 0x000000002100ffeell, KEY_CAMERA },
 	{ 0x000000002700ffeell, KEY_DVD },
 	{ 0x000000002300ffeell, KEY_TV },
+	{ 0x000000002b00ffeell, KEY_EXIT },
+	{ 0x000000002c00ffeell, KEY_SELECT },
+	{ 0x000000002d00ffeell, KEY_MENU },
 	{ 0x000000000500ffeell, KEY_PREVIOUS },
 	{ 0x000000000700ffeell, KEY_REWIND },
 	{ 0x000000000400ffeell, KEY_STOP },
-- 
1.7.1

