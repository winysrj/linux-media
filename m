Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:43954 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756883AbdJPXKi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:10:38 -0400
Received: by mail-pg0-f54.google.com with SMTP id s75so7171279pgs.0
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 16:10:38 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:10:36 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: serial_ir: Convert timers to use timer_setup()
Message-ID: <20171016231036.GA99738@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/rc/serial_ir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 8b66926bc16a..8bf5637b3a69 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -470,7 +470,7 @@ static int hardware_init_port(void)
 	return 0;
 }
 
-static void serial_ir_timeout(unsigned long arg)
+static void serial_ir_timeout(struct timer_list *unused)
 {
 	DEFINE_IR_RAW_EVENT(ev);
 
@@ -540,8 +540,7 @@ static int serial_ir_probe(struct platform_device *dev)
 
 	serial_ir.rcdev = rcdev;
 
-	setup_timer(&serial_ir.timeout_timer, serial_ir_timeout,
-		    (unsigned long)&serial_ir);
+	timer_setup(&serial_ir.timeout_timer, serial_ir_timeout, 0);
 
 	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
 				  share_irq ? IRQF_SHARED : 0,
-- 
2.7.4


-- 
Kees Cook
Pixel Security
