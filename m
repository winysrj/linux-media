Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbcBKNIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 08:08:49 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx-cards: fix compilation breakage caused by cs 622f9260802e
Date: Thu, 11 Feb 2016 11:07:24 -0200
Message-Id: <87749d1653e4cf3af1c009e9b16c476957382325.1455196043.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 622f9260802e ("tvp5150: move input definition header to
dt-bindings") broke compilation of em28xx, as it moved one header
file used there.

Fix it by pointing to the newer file location.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ba442c967415..06a09b4e4a83 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -32,7 +32,7 @@
 #include <media/tuner.h>
 #include <media/drv-intf/msp3400.h>
 #include <media/i2c/saa7115.h>
-#include <media/i2c/tvp5150.h>
+#include <dt-bindings/media/tvp5150.h>
 #include <media/i2c/tvaudio.h>
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
-- 
2.5.0

