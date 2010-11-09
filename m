Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0KIVmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 16:42:39 -0500
Date: Tue, 9 Nov 2010 16:42:37 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH 3/3 v2] IR: add tv power scancode to rc6 mce keymap
Message-ID: <20101109214237.GG11073@redhat.com>
References: <20101109213921.GD11073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109213921.GD11073@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

And clean up some stray spaces.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/keymaps/rc-rc6-mce.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/keymaps/rc-rc6-mce.c b/drivers/media/IR/keymaps/rc-rc6-mce.c
index 1b7adab..6da955d 100644
--- a/drivers/media/IR/keymaps/rc-rc6-mce.c
+++ b/drivers/media/IR/keymaps/rc-rc6-mce.c
@@ -26,8 +26,8 @@ static struct ir_scancode rc6_mce[] = {
 
 	{ 0x800f040a, KEY_DELETE },
 	{ 0x800f040b, KEY_ENTER },
-	{ 0x800f040c, KEY_POWER },
-	{ 0x800f040d, KEY_PROG1 }, 		/* Windows MCE button */
+	{ 0x800f040c, KEY_POWER },		/* PC Power */
+	{ 0x800f040d, KEY_PROG1 },		/* Windows MCE button */
 	{ 0x800f040e, KEY_MUTE },
 	{ 0x800f040f, KEY_INFO },
 
@@ -56,31 +56,32 @@ static struct ir_scancode rc6_mce[] = {
 	{ 0x800f0422, KEY_OK },
 	{ 0x800f0423, KEY_EXIT },
 	{ 0x800f0424, KEY_DVD },
-	{ 0x800f0425, KEY_TUNER }, 		/* LiveTV */
-	{ 0x800f0426, KEY_EPG }, 		/* Guide */
-	{ 0x800f0427, KEY_ZOOM }, 		/* Aspect */
+	{ 0x800f0425, KEY_TUNER },		/* LiveTV */
+	{ 0x800f0426, KEY_EPG },		/* Guide */
+	{ 0x800f0427, KEY_ZOOM },		/* Aspect */
 
 	{ 0x800f043a, KEY_BRIGHTNESSUP },
 
 	{ 0x800f0446, KEY_TV },
-	{ 0x800f0447, KEY_AUDIO }, 		/* My Music */
-	{ 0x800f0448, KEY_PVR }, 		/* RecordedTV */
+	{ 0x800f0447, KEY_AUDIO },		/* My Music */
+	{ 0x800f0448, KEY_PVR },		/* RecordedTV */
 	{ 0x800f0449, KEY_CAMERA },
 	{ 0x800f044a, KEY_VIDEO },
 	{ 0x800f044c, KEY_LANGUAGE },
 	{ 0x800f044d, KEY_TITLE },
-	{ 0x800f044e, KEY_PRINT }, 	/* Print - HP OEM version of remote */
+	{ 0x800f044e, KEY_PRINT },	/* Print - HP OEM version of remote */
 
 	{ 0x800f0450, KEY_RADIO },
 
-	{ 0x800f045a, KEY_SUBTITLE }, 		/* Caption/Teletext */
+	{ 0x800f045a, KEY_SUBTITLE },		/* Caption/Teletext */
 	{ 0x800f045b, KEY_RED },
 	{ 0x800f045c, KEY_GREEN },
 	{ 0x800f045d, KEY_YELLOW },
 	{ 0x800f045e, KEY_BLUE },
 
+	{ 0x800f0465, KEY_POWER2 },	/* TV Power */
 	{ 0x800f046e, KEY_PLAYPAUSE },
-	{ 0x800f046f, KEY_MEDIA }, 	/* Start media application (NEW) */
+	{ 0x800f046f, KEY_MEDIA },	/* Start media application (NEW) */
 
 	{ 0x800f0480, KEY_BRIGHTNESSDOWN },
 	{ 0x800f0481, KEY_PLAYPAUSE },
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

