Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36353 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdBYL2t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:28:49 -0500
Date: Sat, 25 Feb 2017 11:28:16 +0000
From: Sean Young <sean@mess.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel test robot <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
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
Subject: [PATCH] [media] serial_ir: ensure we're ready to receive interrupts
Message-ID: <20170225112816.GA7981@gofer.mess.org>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
 <20170225111424.GA7659@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225111424.GA7659@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the interrupt requested with devm_request_irq(), serial_ir.rcdev
is still null so will cause null deference if the irq handler is called
early on.

Also ensure that timeout_timer is setup.

Link: http://lkml.kernel.org/r/CA+55aFxsh2uF8gi5sN_guY3Z+tiLv7LpJYKBw+y8vqLzp+TsnQ@mail.gmail.com

Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/serial_ir.c | 243 +++++++++++++++++++++----------------------
 1 file changed, 118 insertions(+), 125 deletions(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 923fb22..22144b4 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -487,74 +487,6 @@ static void serial_ir_timeout(unsigned long arg)
 	ir_raw_event_handle(serial_ir.rcdev);
 }
 
-static int serial_ir_probe(struct platform_device *dev)
-{
-	int i, nlow, nhigh, result;
-
-	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
-				  share_irq ? IRQF_SHARED : 0,
-				  KBUILD_MODNAME, &hardware);
-	if (result < 0) {
-		if (result == -EBUSY)
-			dev_err(&dev->dev, "IRQ %d busy\n", irq);
-		else if (result == -EINVAL)
-			dev_err(&dev->dev, "Bad irq number or handler\n");
-		return result;
-	}
-
-	/* Reserve io region. */
-	if ((iommap &&
-	     (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
-				      KBUILD_MODNAME) == NULL)) ||
-	     (!iommap && (devm_request_region(&dev->dev, io, 8,
-			  KBUILD_MODNAME) == NULL))) {
-		dev_err(&dev->dev, "port %04x already in use\n", io);
-		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
-		dev_warn(&dev->dev,
-			 "or compile the serial port driver as module and\n");
-		dev_warn(&dev->dev, "make sure this module is loaded first\n");
-		return -EBUSY;
-	}
-
-	setup_timer(&serial_ir.timeout_timer, serial_ir_timeout,
-		    (unsigned long)&serial_ir);
-
-	result = hardware_init_port();
-	if (result < 0)
-		return result;
-
-	/* Initialize pulse/space widths */
-	init_timing_params(50, 38000);
-
-	/* If pin is high, then this must be an active low receiver. */
-	if (sense == -1) {
-		/* wait 1/2 sec for the power supply */
-		msleep(500);
-
-		/*
-		 * probe 9 times every 0.04s, collect "votes" for
-		 * active high/low
-		 */
-		nlow = 0;
-		nhigh = 0;
-		for (i = 0; i < 9; i++) {
-			if (sinp(UART_MSR) & hardware[type].signal_pin)
-				nlow++;
-			else
-				nhigh++;
-			msleep(40);
-		}
-		sense = nlow >= nhigh ? 1 : 0;
-		dev_info(&dev->dev, "auto-detected active %s receiver\n",
-			 sense ? "low" : "high");
-	} else
-		dev_info(&dev->dev, "Manually using active %s receiver\n",
-			 sense ? "low" : "high");
-
-	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
-	return 0;
-}
-
 static int serial_ir_open(struct rc_dev *rcdev)
 {
 	unsigned long flags;
@@ -679,6 +611,123 @@ static int serial_ir_resume(struct platform_device *dev)
 	return 0;
 }
 
+static int serial_ir_probe(struct platform_device *dev)
+{
+	struct rc_dev *rcdev;
+	int i, nlow, nhigh, result;
+
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
+	result = devm_request_irq(&dev->dev, irq, serial_ir_irq_handler,
+				  share_irq ? IRQF_SHARED : 0,
+				  KBUILD_MODNAME, &hardware);
+	if (result < 0) {
+		if (result == -EBUSY)
+			dev_err(&dev->dev, "IRQ %d busy\n", irq);
+		else if (result == -EINVAL)
+			dev_err(&dev->dev, "Bad irq number or handler\n");
+		return result;
+	}
+
+	/* Reserve io region. */
+	if ((iommap &&
+	     (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
+				      KBUILD_MODNAME) == NULL)) ||
+	     (!iommap && (devm_request_region(&dev->dev, io, 8,
+			  KBUILD_MODNAME) == NULL))) {
+		dev_err(&dev->dev, "port %04x already in use\n", io);
+		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
+		dev_warn(&dev->dev,
+			 "or compile the serial port driver as module and\n");
+		dev_warn(&dev->dev, "make sure this module is loaded first\n");
+		return -EBUSY;
+	}
+
+	result = hardware_init_port();
+	if (result < 0)
+		return result;
+
+	/* Initialize pulse/space widths */
+	init_timing_params(50, 38000);
+
+	/* If pin is high, then this must be an active low receiver. */
+	if (sense == -1) {
+		/* wait 1/2 sec for the power supply */
+		msleep(500);
+
+		/*
+		 * probe 9 times every 0.04s, collect "votes" for
+		 * active high/low
+		 */
+		nlow = 0;
+		nhigh = 0;
+		for (i = 0; i < 9; i++) {
+			if (sinp(UART_MSR) & hardware[type].signal_pin)
+				nlow++;
+			else
+				nhigh++;
+			msleep(40);
+		}
+		sense = nlow >= nhigh ? 1 : 0;
+		dev_info(&dev->dev, "auto-detected active %s receiver\n",
+			 sense ? "low" : "high");
+	} else
+		dev_info(&dev->dev, "Manually using active %s receiver\n",
+			 sense ? "low" : "high");
+
+	dev_dbg(&dev->dev, "Interrupt %d, port %04x obtained\n", irq, io);
+
+	return devm_rc_register_device(&dev->dev, rcdev);
+}
+
 static struct platform_driver serial_ir_driver = {
 	.probe		= serial_ir_probe,
 	.suspend	= serial_ir_suspend,
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
 
-- 
2.9.3

On Sat, Feb 25, 2017 at 11:14:25AM +0000, Sean Young wrote:
> On Fri, Feb 24, 2017 at 11:15:51AM -0800, Linus Torvalds wrote:
> > Added more relevant people. I've debugged the immediate problem below,
> > but I think there's another problem that actually triggered this.
> > 
> > On Fri, Feb 24, 2017 at 10:28 AM, kernel test robot
> > <fengguang.wu@intel.com> wrote:
> > >
> > > 0day kernel testing robot got the below dmesg and the first bad commit is
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > >
> > > commit ff58d005cd10fcd372787cceac547e11cf706ff6
> > > Merge: 5ab3566 9eeb0ed
> > >
> > >     Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
> > [...]
> > > [    4.664940] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0
> > > [    4.666322] BUG: unable to handle kernel NULL pointer dereference at 0000039c
> > > [    4.666675] IP: serial_ir_irq_handler+0x189/0x410
> > 
> > This merge being fingered ends up being a subtle interaction with other changes.
> > 
> > Those "other changes" are (again) the interrupt retrigger code that
> > was reverted for 4.10, and then we tried to merge them again this
> > merge window.
> > 
> > Because the immediate cause is:
> > 
> > > [    4.666675] EIP: serial_ir_irq_handler+0x189/0x410
> > > [    4.666675] Call Trace:
> > > [    4.666675]  <IRQ>
> > > [    4.666675]  __handle_irq_event_percpu+0x57/0x100
> > > [    4.666675]  handle_irq_event_percpu+0x1d/0x50
> > > [    4.666675]  handle_irq_event+0x32/0x60
> > > [    4.666675]  handle_edge_irq+0xa5/0x120
> > > [    4.666675]  handle_irq+0x9d/0xd0
> > > [    4.666675]  </IRQ>
> > > [    4.666675]  do_IRQ+0x5f/0x130
> > > [    4.666675]  common_interrupt+0x33/0x38
> > > [    4.666675] EIP: hardware_init_port+0x3f/0x190
> > > [    4.666675] EFLAGS: 00200246 CPU: 0
> > > [    4.666675] EAX: c718990f EBX: 00000000 ECX: 00000000 EDX: 000003f9
> > > [    4.666675] ESI: 000003f9 EDI: 000003f8 EBP: c0065d98 ESP: c0065d84
> > > [    4.666675]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > > [    4.666675]  serial_ir_probe+0xbb/0x300
> > > [    4.666675]  platform_drv_probe+0x48/0xb0
> > ...
> > 
> > ie an interrupt came in immediately after the request_irq(), before
> > all the data was properly set up, which then causes the interrupt
> > handler to take a fault because it tries to access some field that
> > hasn't even been set up yet.
> 
> Oh dear. I've pointed out others making the same mistake when doing code
> reviews, clearly I need review my own code better.
> 
> > 
> > The code line is helpful, the faulting instruction is
> > 
> >       mov    0x39c(%rax),%eax   <--- fault
> >       call ..
> >       mov    someglobalvar,%edx
> > 
> > which together with the supplied config file makes me able to match it
> > up with the assembly generation around it:
> > 
> >         inb %dx, %al    # tmp254, value
> >         andb    $1, %al #, tmp255
> >         testb   %al, %al        # tmp255
> >         je      .L233   #,
> >   .L215:
> >         movl    serial_ir+8, %eax       # serial_ir.rcdev, serial_ir.rcdev
> >         xorl    %edx, %edx      # _66->timeout
> >         movl    924(%eax), %eax # _66->timeout, _66->timeout
> >         call    nsecs_to_jiffies        #
> >         movl    jiffies, %edx   # jiffies, jiffies.33_70
> >         addl    %eax, %edx      # _69, tmp259
> >         movl    $serial_ir+16, %eax     #,
> >         call    mod_timer       #
> >         movl    serial_ir+8, %eax       # serial_ir.rcdev,
> >         call    ir_raw_event_handle     #
> >         movl    $1, %eax        #, <retval>
> > 
> > so it's that "serial_ir.rcdev->timeout" access that faults. So this is
> > the faulting source code:
> > 
> > drivers/media/rc/serial_ir.c: 402
> > 
> >         mod_timer(&serial_ir.timeout_timer,
> >                   jiffies + nsecs_to_jiffies(serial_ir.rcdev->timeout));
> > 
> >         ir_raw_event_handle(serial_ir.rcdev);
> > 
> >         return IRQ_HANDLED;
> > 
> > and serial_ir.rcdev is NULL when ti tries to look up the timeout.
> 
> ir_raw_event_handle() call will also go bang if passed a null pointer, so
> this problem existed before (since v4.10).
> 
> Thanks for debugging this, I'll send a patch as a reply to this email.
> 
> 
> Sean
