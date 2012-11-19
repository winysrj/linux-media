Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41686 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2KSSiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:08 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 104/493] staging: lirc: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:20:53 -0500
Message-Id: <1353349642-3677-104-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
Cc: devel@driverdev.osuosl.org 
---
 drivers/staging/media/lirc/lirc_parallel.c | 2 +-
 drivers/staging/media/lirc/lirc_serial.c   | 2 +-
 drivers/staging/media/lirc/lirc_sir.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index dd2bca7..610230f 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -606,7 +606,7 @@ static int lirc_parallel_resume(struct platform_device *dev)
 
 static struct platform_driver lirc_parallel_driver = {
 	.probe	= lirc_parallel_probe,
-	.remove	= __devexit_p(lirc_parallel_remove),
+	.remove	= lirc_parallel_remove,
 	.suspend	= lirc_parallel_suspend,
 	.resume	= lirc_parallel_resume,
 	.driver	= {
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 97ef670..002f325 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1148,7 +1148,7 @@ static int lirc_serial_resume(struct platform_device *dev)
 
 static struct platform_driver lirc_serial_driver = {
 	.probe		= lirc_serial_probe,
-	.remove		= __devexit_p(lirc_serial_remove),
+	.remove		= lirc_serial_remove,
 	.suspend	= lirc_serial_suspend,
 	.resume		= lirc_serial_resume,
 	.driver		= {
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 4afc3b4..420e3df 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -1230,7 +1230,7 @@ static int __devexit lirc_sir_remove(struct platform_device *dev)
 
 static struct platform_driver lirc_sir_driver = {
 	.probe		= lirc_sir_probe,
-	.remove		= __devexit_p(lirc_sir_remove),
+	.remove		= lirc_sir_remove,
 	.driver		= {
 		.name	= "lirc_sir",
 		.owner	= THIS_MODULE,
-- 
1.8.0

