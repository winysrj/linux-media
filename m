Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41863 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2KSSnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:43:01 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 186/493] staging: lirc: remove use of __devinit
Date: Mon, 19 Nov 2012 13:22:15 -0500
Message-Id: <1353349642-3677-186-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
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
index 610230f..f600c67 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -583,7 +583,7 @@ static struct lirc_driver driver = {
 
 static struct platform_device *lirc_parallel_dev;
 
-static int __devinit lirc_parallel_probe(struct platform_device *dev)
+static int lirc_parallel_probe(struct platform_device *dev)
 {
 	return 0;
 }
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 002f325..e182da4 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -841,7 +841,7 @@ static int hardware_init_port(void)
 	return 0;
 }
 
-static int __devinit lirc_serial_probe(struct platform_device *dev)
+static int lirc_serial_probe(struct platform_device *dev)
 {
 	int i, nlow, nhigh, result;
 
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 420e3df..9c211e7 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -1218,7 +1218,7 @@ static int init_lirc_sir(void)
 	return 0;
 }
 
-static int __devinit lirc_sir_probe(struct platform_device *dev)
+static int lirc_sir_probe(struct platform_device *dev)
 {
 	return 0;
 }
-- 
1.8.0

