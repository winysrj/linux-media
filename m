Return-path: <mchehab@gaivota>
Received: from rcsinet10.oracle.com ([148.87.113.121]:49590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0L3SZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 13:25:35 -0500
Date: Thu, 30 Dec 2010 10:23:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] staging: se401 depends on USB
Message-Id: <20101230102341.a83e441f.randy.dunlap@oracle.com>
In-Reply-To: <20101230125819.351debfc.sfr@canb.auug.org.au>
References: <20101230125819.351debfc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors by adding "depends on USB":

ERROR: "usb_register_driver" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_control_msg" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_kill_urb" [drivers/staging/se401/se401.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/se401/se401.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/se401/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101230.orig/drivers/staging/se401/Kconfig
+++ linux-next-20101230/drivers/staging/se401/Kconfig
@@ -1,6 +1,6 @@
 config USB_SE401
 	tristate "USB SE401 Camera support (DEPRECATED)"
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && USB
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port. See <file:Documentation/video4linux/se401.txt>
