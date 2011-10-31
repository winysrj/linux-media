Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JaQ0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:26:06 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:26:05 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 17/17] staging: as102: Remove conditional compilation based on kernel version
Date: Mon, 31 Oct 2011 17:24:55 +0100
Message-Id: <1320078295-3379-18-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove #if's related to kernel version and the code not applicable
to 3.2+ kernels.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_fe.c      |   74 +--------------------------
 drivers/staging/media/as102/as102_usb_drv.c |    4 --
 drivers/staging/media/as102/as102_usb_drv.h |    5 --
 3 files changed, 1 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 874c698..3550f90 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -31,68 +31,6 @@ static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
 					  struct dvb_frontend_parameters *src);
 
-static void as102_fe_release(struct dvb_frontend *fe)
-{
-	struct as102_dev_t *dev;
-
-	ENTER();
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return;
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return;
-
-	/* send abilis command: TURN_OFF */
-	as10x_cmd_turn_off(&dev->bus_adap);
-
-	mutex_unlock(&dev->bus_adap.lock);
-#endif
-
-	/* release frontend callback ops */
-	memset(&fe->ops, 0, sizeof(struct dvb_frontend_ops));
-
-	/* flush statistics */
-	memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-	dev->signal_strength = 0;
-	dev->ber = -1;
-
-	/* reset tuner private data */
-/* 	fe->tuner_priv = NULL; */
-
-	LEAVE();
-}
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
-static int as102_fe_init(struct dvb_frontend *fe)
-{
-	int ret = 0;
-	struct as102_dev_t *dev;
-
-	ENTER();
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	if (elna_enable)
-		ret = as10x_cmd_set_context(&dev->bus_adap, 1010, 0xC0);
-
-	/* send abilis command: TURN_ON */
-	ret = as10x_cmd_turn_on(&dev->bus_adap);
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	LEAVE();
-	return (ret < 0) ? -EINVAL : 0;
-}
-#endif
-
 static int as102_fe_set_frontend(struct dvb_frontend *fe,
 				 struct dvb_frontend_parameters *params)
 {
@@ -312,7 +250,6 @@ static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19))
 static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
 	struct as102_dev_t *dev;
@@ -341,7 +278,6 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 	LEAVE();
 	return ret;
 }
-#endif
 
 static struct dvb_frontend_ops as102_fe_ops = {
 	.info = {
@@ -366,19 +302,12 @@ static struct dvb_frontend_ops as102_fe_ops = {
 	.get_frontend		= as102_fe_get_frontend,
 	.get_tune_settings	= as102_fe_get_tune_settings,
 
-
 	.read_status		= as102_fe_read_status,
 	.read_snr		= as102_fe_read_snr,
 	.read_ber		= as102_fe_read_ber,
 	.read_signal_strength	= as102_fe_read_signal_strength,
 	.read_ucblocks		= as102_fe_read_ucblocks,
-
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19))
 	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
-#else
-	.release		= as102_fe_release,
-	.init			= as102_fe_init,
-#endif
 };
 
 int as102_dvb_unregister_fe(struct dvb_frontend *fe)
@@ -386,10 +315,9 @@ int as102_dvb_unregister_fe(struct dvb_frontend *fe)
 	/* unregister frontend */
 	dvb_unregister_frontend(fe);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19))
 	/* detach frontend */
 	dvb_frontend_detach(fe);
-#endif
+
 	return 0;
 }
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index ae1d38d..264be2d 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -205,11 +205,7 @@ static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
 	return err;
 }
 
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18))
-void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs)
-#else
 void as102_urb_stream_irq(struct urb *urb)
-#endif
 {
 	struct as102_dev_t *as102_dev = urb->context;
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index da34d32..fb1fc41 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -47,12 +47,7 @@
 #define NBOX_DVBT_DONGLE_USB_VID	0x0b89
 #define NBOX_DVBT_DONGLE_USB_PID	0x0007
 
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18))
-void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
-#else
 void as102_urb_stream_irq(struct urb *urb);
-#endif
-
 
 struct as10x_usb_token_cmd_t {
 	/* token cmd */
-- 
1.7.4.1

