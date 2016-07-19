Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:42521 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbcGSLZb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 07:25:31 -0400
From: Wei Yongjun <weiyj_lk@163.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Aayush Gupta <aayustark007@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH -next] [media] staging: media: lirc: add missing platform_device_del() on error in lirc_parallel_init()
Date: Tue, 19 Jul 2016 11:24:42 +0000
Message-Id: <1468927482-32392-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing platform_device_del() before return from
lirc_parallel_init() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/lirc/lirc_parallel.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index 3906ac6..878fdea 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -650,7 +650,7 @@ static int __init lirc_parallel_init(void)
 	if (!pport) {
 		pr_notice("no port at %x found\n", io);
 		result = -ENXIO;
-		goto exit_device_put;
+		goto exit_device_del;
 	}
 	ppdevice = parport_register_device(pport, LIRC_DRIVER_NAME,
 					   pf, kf, lirc_lirc_irq_handler, 0,
@@ -659,7 +659,7 @@ static int __init lirc_parallel_init(void)
 	if (!ppdevice) {
 		pr_notice("parport_register_device() failed\n");
 		result = -ENXIO;
-		goto exit_device_put;
+		goto exit_device_del;
 	}
 	if (parport_claim(ppdevice) != 0)
 		goto skip_init;
@@ -678,7 +678,7 @@ static int __init lirc_parallel_init(void)
 		parport_release(pport);
 		parport_unregister_device(ppdevice);
 		result = -EIO;
-		goto exit_device_put;
+		goto exit_device_del;
 	}
 
 #endif
@@ -695,11 +695,13 @@ static int __init lirc_parallel_init(void)
 		pr_notice("register_chrdev() failed\n");
 		parport_unregister_device(ppdevice);
 		result = -EIO;
-		goto exit_device_put;
+		goto exit_device_del;
 	}
 	pr_info("installed using port 0x%04x irq %d\n", io, irq);
 	return 0;
 
+exit_device_del:
+	platform_device_del(lirc_parallel_dev);
 exit_device_put:
 	platform_device_put(lirc_parallel_dev);
 exit_driver_unregister:




