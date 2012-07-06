Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2GFNyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 09:54:13 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q66DsDrU002343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 6 Jul 2012 09:54:13 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] rc/Kconfig: Move a LIRC sub-option to the right place
Date: Fri,  6 Jul 2012 10:54:10 -0300
Message-Id: <1341582850-25811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR to LIRC option were at the wrong sub-menu. Move it to the right
place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/Kconfig |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 2478b06..908ef70 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -23,6 +23,17 @@ config LIRC
 	   LIRC daemon handles protocol decoding for IR reception and
 	   encoding for IR transmitting (aka "blasting").
 
+config IR_LIRC_CODEC
+	tristate "Enable IR to LIRC bridge"
+	depends on RC_CORE
+	depends on LIRC
+	default y
+
+	---help---
+	   Enable this option to pass raw IR to and from userspace via
+	   the LIRC interface.
+
+
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
@@ -113,16 +124,6 @@ menuconfig RC_DEVICES
 
 if RC_DEVICES
 
-config IR_LIRC_CODEC
-	tristate "Enable IR to LIRC bridge"
-	depends on RC_CORE
-	depends on LIRC
-	default y
-
-	---help---
-	   Enable this option to pass raw IR to and from userspace via
-	   the LIRC interface.
-
 config RC_ATI_REMOTE
 	tristate "ATI / X10 based USB RF remote controls"
 	depends on USB_ARCH_HAS_HCD
-- 
1.7.10.4

