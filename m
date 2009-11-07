Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbZKGVwQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:52:16 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:52:18 +0000
Message-ID: <1257630738.15927.433.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 37/75] saa7164: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/saa7164/saa7164-fw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-fw.c b/drivers/media/video/saa7164/saa7164-fw.c
index ee0af35..b411fa0 100644
--- a/drivers/media/video/saa7164/saa7164-fw.c
+++ b/drivers/media/video/saa7164/saa7164-fw.c
@@ -25,9 +25,11 @@
 
 #define SAA7164_REV2_FIRMWARE		"v4l-saa7164-1.0.2.fw"
 #define SAA7164_REV2_FIRMWARE_SIZE	3978608
+MODULE_FIRMWARE(SAA7164_REV2_FIRMWARE);
 
 #define SAA7164_REV3_FIRMWARE		"v4l-saa7164-1.0.3.fw"
 #define SAA7164_REV3_FIRMWARE_SIZE	3978608
+MODULE_FIRMWARE(SAA7164_REV3_FIRMWARE);
 
 struct fw_header {
 	u32	firmwaresize;
-- 
1.6.5.2



