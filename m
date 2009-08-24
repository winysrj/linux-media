Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:42038 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHXEQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 00:16:35 -0400
Date: Sun, 23 Aug 2009 20:41:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	akpm <akpm@linux-foundation.org>,
	Brian Johnson <brijohn@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] gspca: fix sn9c20x build errors
Message-Id: <20090823204104.6043aebe.randy.dunlap@oracle.com>
In-Reply-To: <200908231417.49207.toralf.foerster@gmx.de>
References: <200908231417.49207.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gscpa sn9c20x build errors:
ERROR: "input_event" [drivers/media/video/gspca/gspca_sn9c20x.ko] undefined!
ERROR: "input_register_device" [drivers/media/video/gspca/gspca_sn9c20x.ko] undefined!
ERROR: "input_free_device" [drivers/media/video/gspca/gspca_sn9c20x.ko] undefined!
ERROR: "input_unregister_device" [drivers/media/video/gspca/gspca_sn9c20x.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/video/gspca/gspca_sn9c20x.ko] undefined!

Reported-by: Toralf Förster <toralf.foerster@gmx.de
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/gspca/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.31-rc7-git1.orig/drivers/media/video/gspca/Kconfig
+++ linux-2.6.31-rc7-git1/drivers/media/video/gspca/Kconfig
@@ -114,7 +114,7 @@ config USB_GSPCA_SN9C20X
 
 config USB_GSPCA_SN9C20X_EVDEV
        bool "Enable evdev support"
-       depends on USB_GSPCA_SN9C20X
+       depends on USB_GSPCA_SN9C20X && INPUT
        ---help---
 	 Say Y here in order to enable evdev support for sn9c20x webcam button.
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
