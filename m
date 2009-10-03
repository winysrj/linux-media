Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:4200 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbZJCPBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 11:01:34 -0400
Received: from [192.168.1.4] (athloroad.xperim.be [192.168.1.4])
	(authenticated bits=0)
	by via.xperim.be (8.14.2/8.14.2/Debian-2build1) with ESMTP id n93EvGDm013783
	for <linux-media@vger.kernel.org>; Sat, 3 Oct 2009 16:57:17 +0200
Message-ID: <4AC7664B.3090404@computer.org>
Date: Sat, 03 Oct 2009 16:57:15 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/video/em28xx: memset region size error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 2082ccb34a1ef5f67ec0618ed05d2f15c67d1da0 Mon Sep 17 00:00:00 2001
From: Jan Ceuleers <jan.ceuleers@computer.org>
Date: Sat, 3 Oct 2009 16:51:31 +0200
Subject: [PATCH] drivers/media/video/em28xx: memset region size error

The size of the region to be memset() should be the size
of the target rather than the size of the pointer to it.

Compile-tested only.

Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
---
 drivers/media/video/em28xx/em28xx-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index bdb249b..dd4f19b 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2234,7 +2234,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	if (disable_ir)
 		return;
 
-	memset(&dev->info, 0, sizeof(&dev->info));
+	memset(&dev->info, 0, sizeof(dev->info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
 	strlcpy(dev->info.type, "ir_video", I2C_NAME_SIZE);
 
-- 
1.5.4.3
