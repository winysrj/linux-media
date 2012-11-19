Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41503 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2KSSfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:17 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 481/493] staging: lirc: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:10 -0500
Message-Id: <1353349642-3677-481-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

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
index f600c67..ec14bc8 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -588,7 +588,7 @@ static int lirc_parallel_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit lirc_parallel_remove(struct platform_device *dev)
+static int lirc_parallel_remove(struct platform_device *dev)
 {
 	return 0;
 }
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index e182da4..71e3bf2 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -927,7 +927,7 @@ exit_free_irq:
 	return result;
 }
 
-static int __devexit lirc_serial_remove(struct platform_device *dev)
+static int lirc_serial_remove(struct platform_device *dev)
 {
 	free_irq(irq, (void *)&hardware);
 
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 9c211e7..a457998 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -1223,7 +1223,7 @@ static int lirc_sir_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit lirc_sir_remove(struct platform_device *dev)
+static int lirc_sir_remove(struct platform_device *dev)
 {
 	return 0;
 }
-- 
1.8.0

