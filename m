Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1GMU5q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 16:57:46 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6DKvk2Z004577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 16:57:46 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] rc-rc6-mce: minor keymap updates
Date: Wed, 13 Jul 2011 16:57:42 -0400
Message-Id: <1310590662-10466-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Microsoft's Windows Media Center specification and requirements doc from
2011.03.18 now refers to the former Power Toggle button as the Sleep
Toggle, and recommends using a new moon sleep icon for it. Its the same
key, but its apparently always been meant to put the system to sleep,
not power it off. Adjust accordingly. While we're here, lets also remove
the duplicate KEY_PLAYPAUSE entry.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/keymaps/rc-rc6-mce.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 01b69bc..c3907e2 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -29,7 +29,7 @@ static struct rc_map_table rc6_mce[] = {
 
 	{ 0x800f040a, KEY_DELETE },
 	{ 0x800f040b, KEY_ENTER },
-	{ 0x800f040c, KEY_POWER },		/* PC Power */
+	{ 0x800f040c, KEY_SLEEP },		/* Formerly PC Power */
 	{ 0x800f040d, KEY_MEDIA },		/* Windows MCE button */
 	{ 0x800f040e, KEY_MUTE },
 	{ 0x800f040f, KEY_INFO },
@@ -44,7 +44,6 @@ static struct rc_map_table rc6_mce[] = {
 	{ 0x800f0416, KEY_PLAY },
 	{ 0x800f0417, KEY_RECORD },
 	{ 0x800f0418, KEY_PAUSE },
-	{ 0x800f046e, KEY_PLAYPAUSE },
 	{ 0x800f0419, KEY_STOP },
 	{ 0x800f041a, KEY_NEXT },
 	{ 0x800f041b, KEY_PREVIOUS },
-- 
1.7.1

