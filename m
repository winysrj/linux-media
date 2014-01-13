Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/7] [media] lirc_parallel: avoid name conflict on mn10300 arch
Date: Mon, 13 Jan 2014 16:32:37 -0200
Message-Id: <1389637958-3884-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "irq_handler" name is already defined there on a header
file:

/devel/v4l/temp/drivers/staging/media/lirc/lirc_parallel.c:223:13: error: conflicting types for ‘irq_handler’
 static void irq_handler(void *blah)
             ^
In file included from /devel/v4l/temp/arch/mn10300/include/asm/reset-regs.h:16:0,
                 from /devel/v4l/temp/arch/mn10300/include/asm/irq.h:18,
                 from /devel/v4l/temp/include/linux/irq.h:24,
                 from /devel/v4l/temp/arch/mn10300/include/asm/hardirq.h:16,
                 from /devel/v4l/temp/include/linux/preempt_mask.h:5,
                 from /devel/v4l/temp/include/linux/sched.h:25,
                 from /devel/v4l/temp/include/linux/utsname.h:5,
                 from /devel/v4l/temp/arch/mn10300/include/asm/elf.h:15,
                 from /devel/v4l/temp/include/linux/elf.h:4,
                 from /devel/v4l/temp/include/linux/module.h:14,
                 from /devel/v4l/temp/drivers/staging/media/lirc/lirc_parallel.c:29:
/devel/v4l/temp/arch/mn10300/include/asm/exceptions.h:107:24: note: previous declaration of ‘irq_handler’ was here
 extern asmlinkage void irq_handler(void);

/devel/v4l/patchwork/drivers/staging/media/lirc/lirc_serial.c:653:20: error: conflicting types for ‘irq_handler’
 static irqreturn_t irq_handler(int i, void *blah)
                    ^
In file included from /devel/v4l/patchwork/arch/mn10300/include/asm/reset-regs.h:16:0,
                 from /devel/v4l/patchwork/arch/mn10300/include/asm/irq.h:18,
                 from /devel/v4l/patchwork/include/linux/irq.h:24,
                 from /devel/v4l/patchwork/arch/mn10300/include/asm/hardirq.h:16,
                 from /devel/v4l/patchwork/include/linux/preempt_mask.h:5,
                 from /devel/v4l/patchwork/include/linux/sched.h:25,
                 from /devel/v4l/patchwork/include/linux/utsname.h:5,
                 from /devel/v4l/patchwork/arch/mn10300/include/asm/elf.h:15,
                 from /devel/v4l/patchwork/include/linux/elf.h:4,
                 from /devel/v4l/patchwork/include/linux/module.h:14,
                 from /devel/v4l/patchwork/drivers/staging/media/lirc/lirc_serial.c:53:
/devel/v4l/patchwork/arch/mn10300/include/asm/exceptions.h:107:24: note: previous declaration of ‘irq_handler’ was here
 extern asmlinkage void irq_handler(void);

So, rename it, to avoid namespace conflicts.

This patch fixes building media drivers with allyesconfig/almodconfig on
mn10300 arch.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/lirc/lirc_parallel.c | 4 ++--
 drivers/staging/media/lirc/lirc_serial.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index 41d110f8bc02..0b589892351a 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -220,7 +220,7 @@ static void rbuf_write(int signal)
 	wptr = nwptr;
 }
 
-static void irq_handler(void *blah)
+static void lirc_lirc_irq_handler(void *blah)
 {
 	struct timeval tv;
 	static struct timeval lasttv;
@@ -659,7 +659,7 @@ static int __init lirc_parallel_init(void)
 		goto exit_device_put;
 	}
 	ppdevice = parport_register_device(pport, LIRC_DRIVER_NAME,
-					   pf, kf, irq_handler, 0, NULL);
+					   pf, kf, lirc_lirc_irq_handler, 0, NULL);
 	parport_put_port(pport);
 	if (ppdevice == NULL) {
 		pr_notice("parport_register_device() failed\n");
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 2e3a98575d47..0be1f468771b 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -650,7 +650,7 @@ static void frbwrite(int l)
 	rbwrite(l);
 }
 
-static irqreturn_t irq_handler(int i, void *blah)
+static irqreturn_t lirc_irq_handler(int i, void *blah)
 {
 	struct timeval tv;
 	int counter, dcd;
@@ -852,7 +852,7 @@ static int lirc_serial_probe(struct platform_device *dev)
 		return result;
 #endif
 
-	result = request_irq(irq, irq_handler,
+	result = request_irq(irq, lirc_irq_handler,
 			     (share_irq ? IRQF_SHARED : 0),
 			     LIRC_DRIVER_NAME, (void *)&hardware);
 	if (result < 0) {
-- 
1.8.3.1

