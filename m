Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41424 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab0L2Cpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 21:45:45 -0500
Subject: [PATCH 2/3] ir-kbd-i2c: Add HD PVR IR Rx support to ir-kbd-i2c
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1293587067.3098.10.camel@localhost>
References: <1293587067.3098.10.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 20:47:46 -0500
Message-ID: <1293587266.3098.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Add HD PVR IR Rx support to ir-kbd-i2c

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

---
 drivers/media/video/ir-kbd-i2c.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index dd54c3d..c87b6bc 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -449,6 +449,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	{ "ir_video", 0 },
 	/* IR device specific entries should be added here */
 	{ "ir_rx_z8f0811_haup", 0 },
+	{ "ir_rx_z8f0811_hdpvr", 0 },
 	{ }
 };
 
-- 
1.7.2.1



