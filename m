Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbcB0Kv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/7] [media] ati_remote: Put timeouts at the accel array
Date: Sat, 27 Feb 2016 07:51:12 -0300
Message-Id: <8e4e699bf515c23f013594653b91990ebef59c62.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having the timeouts hardcoded, and getting only the
accel value from the array, put everything in the same place.

That simplifies the logic and also cleans several smatch errors:
	include/linux/jiffies.h:359:41: error: strange non-value function or array
	include/linux/jiffies.h:361:42: error: strange non-value function or array
(one per time_after/time_before line)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/ati_remote.c | 47 +++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a35631891cc0..3f61d77d4147 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -443,6 +443,21 @@ static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd,
 	return retval;
 }
 
+struct accel_times {
+	const char	value;
+	unsigned int	msecs;
+};
+
+static const struct accel_times accel[] = {
+	{  1,  125 },
+	{  2,  250 },
+	{  4,  500 },
+	{  6, 1000 },
+	{  9, 1500 },
+	{ 13, 2000 },
+	{ 20,    0 },
+};
+
 /*
  * ati_remote_compute_accel
  *
@@ -454,30 +469,22 @@ static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd,
  */
 static int ati_remote_compute_accel(struct ati_remote *ati_remote)
 {
-	static const char accel[] = { 1, 2, 4, 6, 9, 13, 20 };
-	unsigned long now = jiffies;
-	int acc;
+	unsigned long now = jiffies, reset_time;
+	int i;
 
-	if (time_after(now, ati_remote->old_jiffies + msecs_to_jiffies(250))) {
-		acc = 1;
+	reset_time = msecs_to_jiffies(250);
+
+	if (time_after(now, ati_remote->old_jiffies + reset_time)) {
 		ati_remote->acc_jiffies = now;
+		return 1;
 	}
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(125)))
-		acc = accel[0];
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(250)))
-		acc = accel[1];
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(500)))
-		acc = accel[2];
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(1000)))
-		acc = accel[3];
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(1500)))
-		acc = accel[4];
-	else if (time_before(now, ati_remote->acc_jiffies + msecs_to_jiffies(2000)))
-		acc = accel[5];
-	else
-		acc = accel[6];
+	for (i = 0; i < ARRAY_SIZE(accel) - 1; i++) {
+		unsigned long timeout = msecs_to_jiffies(accel[i].msecs);
 
-	return acc;
+		if (time_before(now, ati_remote->acc_jiffies + timeout))
+			return accel[i].value;
+	}
+	return accel[i].value;
 }
 
 /*
-- 
2.5.0

