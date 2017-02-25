Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdBYNyX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 08:54:23 -0500
Date: Sat, 25 Feb 2017 10:54:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sean Young <sean@mess.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Ruslan Ruslichenko <rruslich@cisco.com>, LKP <lkp@01.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        kernel@stlinux.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
Subject: Re: [PATCH] [media] serial_ir: ensure we're ready to receive
 interrupts
Message-ID: <20170225105409.6a059861@vento.lan>
In-Reply-To: <20170225103437.58c5a199@vento.lan>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
        <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
        <20170225111424.GA7659@gofer.mess.org>
        <20170225112816.GA7981@gofer.mess.org>
        <20170225103437.58c5a199@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Feb 2017 10:34:37 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Sat, 25 Feb 2017 11:28:16 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > When the interrupt requested with devm_request_irq(), serial_ir.rcdev
> > is still null so will cause null deference if the irq handler is called
> > early on.
> > 
> > Also ensure that timeout_timer is setup.
> > 
> > Link: http://lkml.kernel.org/r/CA+55aFxsh2uF8gi5sN_guY3Z+tiLv7LpJYKBw+y8vqLzp+TsnQ@mail.gmail.com
> > 
> > Cc: <stable@vger.kernel.org> # 4.10
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/serial_ir.c | 243 +++++++++++++++++++++----------------------
> >  1 file changed, 118 insertions(+), 125 deletions(-)
> > 
> > diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
> > index 923fb22..22144b4 100644
> > --- a/drivers/media/rc/serial_ir.c
> > +++ b/drivers/media/rc/serial_ir.c
> > @@ -487,74 +487,6 @@ static void serial_ir_timeout(unsigned long arg)
> >  	ir_raw_event_handle(serial_ir.rcdev);
> >  }
> >  
> > -static int serial_ir_probe(struct platform_device *dev)
> > -{
> > -	int i, nlow, nhigh, result;
> 
> Hmm... why did you move this function to be after serial_ir_open()?
> 
> That messes with the diff without no good reason, making harder to
> identify what you changed here.

Ok, just reordered it. The diff now looks sane. Patch looks ok on
my eyes.

[PATCH v2] serial_ir: ensure we're ready to receive interrupts
From: Sean Young <sean@mess.org>

When the interrupt requested with devm_request_irq(), serial_ir.rcdev
is still null so will cause null deference if the irq handler is called
early on.

Also ensure that timeout_timer is setup.

Link: http://lkml.kernel.org/r/CA+55aFxsh2uF8gi5sN_guY3Z+tiLv7LpJYKBw+y8vqLzp+TsnQ@mail.gmail.com

[mchehab@s-opensource.com: moved serial_ir_probe() back to its original place]
Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 923fb2299553..4687c34c655a 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -489,8 +489,59 @@ static void serial_ir_timeout(unsigned long arg)
 
 static int serial_ir_probe(struct platform_device *dev)
 {
+	struct rc_dev *rcdev;
 	int i, nlow, nhigh, result;
 
+	rcdev = devm_rc_allocate_device(&dev->dev, RC_DRIVER_IR_RAW);
+	if (!rcdev)
+		return -ENOMEM;
+
+	if (hardware[type].send_pulse && hardware[type].send_space)
+		rcdev->tx_ir = serial_ir_tx;
+	if (hardware[type].set_send_carrier)
+		rcdev->s_tx_carrier = serial_ir_tx_carrier;
+	if (hardware[type].set_duty_cycle)
+		rcdev->s_tx_duty_cycle = serial_ir_tx_duty_cycle;
+
+	switch (type) {
+	case IR_HOMEBREW:
+		rcdev->input_name = "Serial IR type home-brew";
+		break;
+	case IR_IRDEO:
+		rcdev->input_name = "Serial IR type IRdeo";
+		break;
+	case IR_IRDEO_REMOTE:
+		rcdev->input_name = "Serial IR type IRdeo remote";
+		break;
+	case IR_ANIMAX:
+		rcdev->input_name = "Serial IR type AnimaX";
+		break;
+	case IR_IGOR:
+		rcdev->input_name = "Serial IR type IgorPlug";
+		break;
+	}
+
+	rcdev->input_phys = KBUILD_MODNAME "/input0";
+	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->open = serial_ir_open;
+	rcdev->close = serial_ir_close;
+	rcdev->dev.parent = &serial_ir.pdev->dev;
+	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->map_name = RC_MAP_RC6_MCE;
+	rcdev->min_timeout = 1;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
+	rcdev->rx_resolution = 250000;
+
+	serial_ir.rcdev = rcdev;
+
+	setup_timer(&serial_ir.timeout_timer, serial_ir_timeout,
+		    (unsigned long)&serial_ir);
+
 	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
 				  share_irq ? IRQF_SHARED : 0,
 				  KBUILD_MODNAME, &hardware);
@@ -516,9 +567,6 @@ static int serial_ir_probe(struct platform_device *dev)
 		return -EBUSY;
 	}
 
-	setup_timer(&serial_ir.timeout_timer, serial_ir_timeout,
-		    (unsigned long)&serial_ir);
-
 	result = hardware_init_port();
 	if (result < 0)
 		return result;
@@ -552,7 +600,8 @@ static int serial_ir_probe(struct platform_device *dev)
 			 sense ? "low" : "high");
 
 	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
-	return 0;
+
+	return devm_rc_register_device(&dev->dev, rcdev);
 }
 
 static int serial_ir_open(struct rc_dev *rcdev)
@@ -723,7 +772,6 @@ static void serial_ir_exit(void)
 
 static int __init serial_ir_init_module(void)
 {
-	struct rc_dev *rcdev;
 	int result;
 
 	switch (type) {
@@ -754,63 +802,9 @@ static int __init serial_ir_init_module(void)
 		sense = !!sense;
 
 	result = serial_ir_init();
-	if (result)
-		return result;
-
-	rcdev = devm_rc_allocate_device(&serial_ir.pdev->dev, RC_DRIVER_IR_RAW);
-	if (!rcdev) {
-		result = -ENOMEM;
-		goto serial_cleanup;
-	}
-
-	if (hardware[type].send_pulse && hardware[type].send_space)
-		rcdev->tx_ir = serial_ir_tx;
-	if (hardware[type].set_send_carrier)
-		rcdev->s_tx_carrier = serial_ir_tx_carrier;
-	if (hardware[type].set_duty_cycle)
-		rcdev->s_tx_duty_cycle = serial_ir_tx_duty_cycle;
-
-	switch (type) {
-	case IR_HOMEBREW:
-		rcdev->input_name = "Serial IR type home-brew";
-		break;
-	case IR_IRDEO:
-		rcdev->input_name = "Serial IR type IRdeo";
-		break;
-	case IR_IRDEO_REMOTE:
-		rcdev->input_name = "Serial IR type IRdeo remote";
-		break;
-	case IR_ANIMAX:
-		rcdev->input_name = "Serial IR type AnimaX";
-		break;
-	case IR_IGOR:
-		rcdev->input_name = "Serial IR type IgorPlug";
-		break;
-	}
-
-	rcdev->input_phys = KBUILD_MODNAME "/input0";
-	rcdev->input_id.bustype = BUS_HOST;
-	rcdev->input_id.vendor = 0x0001;
-	rcdev->input_id.product = 0x0001;
-	rcdev->input_id.version = 0x0100;
-	rcdev->open = serial_ir_open;
-	rcdev->close = serial_ir_close;
-	rcdev->dev.parent = &serial_ir.pdev->dev;
-	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	rcdev->driver_name = KBUILD_MODNAME;
-	rcdev->map_name = RC_MAP_RC6_MCE;
-	rcdev->min_timeout = 1;
-	rcdev->timeout = IR_DEFAULT_TIMEOUT;
-	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
-	rcdev->rx_resolution = 250000;
-
-	serial_ir.rcdev = rcdev;
-
-	result = rc_register_device(rcdev);
-
 	if (!result)
 		return 0;
-serial_cleanup:
+
 	serial_ir_exit();
 	return result;
 }
@@ -818,7 +812,6 @@ static int __init serial_ir_init_module(void)
 static void __exit serial_ir_exit_module(void)
 {
 	del_timer_sync(&serial_ir.timeout_timer);
-	rc_unregister_device(serial_ir.rcdev);
 	serial_ir_exit();
 }
 
