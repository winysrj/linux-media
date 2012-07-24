Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3414 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2GXVRr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 17:17:47 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dean Anderson <linux-dev@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: Add MODULE_FIRMWARE statement
Date: Tue, 24 Jul 2012 14:52:27 -0600
Message-Id: <1343163147-94118-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dean Anderson <linux-dev@sensoray.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/s2255drv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 01c2179..95007dd 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -2686,3 +2686,4 @@ MODULE_DESCRIPTION("Sensoray 2255 Video for Linux driver");
 MODULE_AUTHOR("Dean Anderson (Sensoray Company Inc.)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(S2255_VERSION);
+MODULE_FIRMWARE(FIRMWARE_FILE_NAME);
-- 
1.7.9.5

