Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AUE0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:26:51 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0L4QoXG019934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 23:26:50 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] rc/mce: add mappings for missing keys
Date: Thu, 20 Jan 2011 23:26:45 -0500
Message-Id: <1295584005-20905-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Per http://mediacenterguides.com/book/export/html/31 and investigation
by Erin, we were missing these last three mappings to complete the mce
key table. Lets remedy that.

Reported-by: Erin Simonds <fisslefink@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/keymaps/rc-rc6-mce.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 3bf3337..2f5dc06 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -3,6 +3,9 @@
  *
  * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
  *
+ * See http://mediacenterguides.com/book/export/html/31 for details on
+ * key mappings.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -60,6 +63,9 @@ static struct rc_map_table rc6_mce[] = {
 	{ 0x800f0426, KEY_EPG },		/* Guide */
 	{ 0x800f0427, KEY_ZOOM },		/* Aspect */
 
+	{ 0x800f0432, KEY_MODE },		/* Visualization */
+	{ 0x800f0433, KEY_PRESENTATION },	/* Slide Show */
+	{ 0x800f0434, KEY_EJECTCD },
 	{ 0x800f043a, KEY_BRIGHTNESSUP },
 
 	{ 0x800f0446, KEY_TV },
-- 
1.7.3.4

