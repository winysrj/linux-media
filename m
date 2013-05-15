Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23008 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3EOV4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 17:56:21 -0400
Date: Wed, 15 May 2013 23:56:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] sony-btf-mpx: Drop needless newline in param
 description
Message-ID: <20130515235611.4271a684@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Module parameter descriptions need not be terminated with a newline.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/sony-btf-mpx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.10-rc1.orig/drivers/media/i2c/sony-btf-mpx.c	2013-05-13 15:27:46.176134998 +0200
+++ linux-3.10-rc1/drivers/media/i2c/sony-btf-mpx.c	2013-05-15 23:28:55.519803198 +0200
@@ -30,7 +30,7 @@ MODULE_LICENSE("GPL v2");
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "debug level 0=off(default) 1=on\n");
+MODULE_PARM_DESC(debug, "debug level 0=off(default) 1=on");
 
 /* #define MPX_DEBUG */
 


-- 
Jean Delvare
