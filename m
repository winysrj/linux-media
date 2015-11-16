Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 01/16] [media] dvb: document dvb_frontend_sleep_until()
Date: Mon, 16 Nov 2015 08:20:58 -0200
Message-Id: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is used mainly at the DVB core, in order to provide
emulation for a legacy ioctl. The only current exception is
the stv0299 driver, with takes more than 8ms to switch voltage,
breaking the emulation for FE_DISHNETWORK_SEND_LEGACY_CMD.

Document that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |  9 +++++----
 drivers/media/dvb-core/dvb_frontend.h | 30 +++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c38ef1a72b4a..d764cffb2102 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -891,10 +891,11 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 }
 
 /*
- * Sleep until gettimeofday() > waketime + add_usec
- * This needs to be as precise as possible, but as the delay is
- * usually between 2ms and 32ms, it is done using a scheduled msleep
- * followed by usleep (normally a busy-wait loop) for the remainder
+ * Sleep for the amount of time given by add_usec parameter
+ *
+ * This needs to be as precise as possible, as it affects the detection of
+ * the dish tone command at the satellite subsystem. The precision is improved
+ * by using a scheduled msleep followed by udelay for the remainder.
  */
 void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec)
 {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 97661b2f247a..9f724f4571f3 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -404,6 +404,11 @@ struct dtv_frontend_properties;
  *			FE_ENABLE_HIGH_LNB_VOLTAGE ioctl (only Satellite).
  * @dishnetwork_send_legacy_command: callback function to implement the
  *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl (only Satellite).
+ *			Drivers should not use this, except when the DVB
+ * 			core emulation fails to provide proper support (e.g.
+ * 			if set_voltage() takes more than 8ms to work), and
+ * 			when backward compatibility with this legacy API is
+ * 			required.
  * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
  *			mux support instead.
  * @ts_bus_ctrl:	callback function used to take control of the TS bus.
@@ -693,6 +698,29 @@ extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
 extern int dvb_frontend_suspend(struct dvb_frontend *fe);
 extern int dvb_frontend_resume(struct dvb_frontend *fe);
 
-extern void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec);
+/**
+ * dvb_frontend_sleep_until() - Sleep for the amount of time given by
+ *                      add_usec parameter
+ *
+ * @waketime: pointer to a struct ktime_t
+ * @add_usec: time to sleep, in microseconds
+ *
+ * This function is used to measure the time required for the
+ * %FE_DISHNETWORK_SEND_LEGACY_CMD ioctl to work. It needs to be as precise
+ * as possible, as it affects the detection of the dish tone command at the
+ * satellite subsystem.
+ *
+ * Its used internally by the DVB frontend core, in order to emulate
+ * %FE_DISHNETWORK_SEND_LEGACY_CMD using the &dvb_frontend_ops.set_voltage()
+ * callback.
+ *
+ * NOTE: it should not be used at the drivers, as the emulation for the
+ * legacy callback is provided by the Kernel. The only situation where this
+ * should be at the drivers is when there are some bugs at the hardware that
+ * would prevent the core emulation to work. On such cases, the driver would
+ * be writing a &dvb_frontend_ops.dishnetwork_send_legacy_command() and
+ * calling this function directly.
+ */
+void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec);
 
 #endif
-- 
2.5.0

