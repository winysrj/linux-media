Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35563 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1DVJVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 05:21:05 -0400
Received: by wya21 with SMTP id 21so325122wya.19
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2011 02:21:04 -0700 (PDT)
Subject: [PATCH 2/2] DM04/QQBOX v1.86 PID filtering changes
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:20:57 +0100
Message-ID: <1303464057.2525.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Improve PID filtering and program register 20 correctly.
 Make sure stream_on message is sent if streaming is off, otherwise
 PIDs are not registered.
 Move mutex outside lme2510_enable_pid.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   37 ++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index aa9a6ff..ab94a62 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -127,6 +127,7 @@ struct lme2510_state {
 	u8 i2c_tuner_gate_r;
 	u8 i2c_tuner_addr;
 	u8 stream_on;
+	u8 pid_size;
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
@@ -224,29 +225,28 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
 	static u8 pid_buff[] = LME_ZERO_PID;
 	static u8 rbuf[1];
 	u8 pid_no = index * 2;
+	u8 pid_len = pid_no + 2;
 	int ret = 0;
 	deb_info(1, "PID Setting Pid %04x", pid_out);
 
+	if (st->pid_size == 0)
+		ret |= lme2510_stream_restart(d);
+
 	pid_buff[2] = pid_no;
 	pid_buff[3] = (u8)pid_out & 0xff;
 	pid_buff[4] = pid_no + 1;
 	pid_buff[5] = (u8)(pid_out >> 8);
 
-	/* wait for i2c mutex */
-	ret = mutex_lock_interruptible(&d->i2c_mutex);
-	if (ret < 0) {
-		ret = -EAGAIN;
-		return ret;
-	}
+	if (pid_len > st->pid_size)
+		st->pid_size = pid_len;
+	pid_buff[7] = 0x80 + st->pid_size;
 
 	ret |= lme2510_usb_talk(d, pid_buff ,
 		sizeof(pid_buff) , rbuf, sizeof(rbuf));
 
-	if (st->stream_on & 1)
+	if (st->stream_on)
 		ret |= lme2510_stream_restart(d);
 
-	mutex_unlock(&d->i2c_mutex);
-
 	return ret;
 }
 
@@ -362,18 +362,23 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 
 static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
+	struct lme2510_state *st = adap->dev->priv;
 	static u8 clear_pid_reg[] = LME_CLEAR_PID;
 	static u8 rbuf[1];
-	int ret = 0;
+	int ret;
 
 	deb_info(1, "PID Clearing Filter");
 
 	ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
+	if (ret < 0)
+		return -EAGAIN;
 
 	if (!onoff)
 		ret |= lme2510_usb_talk(adap->dev, clear_pid_reg,
 			sizeof(clear_pid_reg), rbuf, sizeof(rbuf));
 
+	st->pid_size = 0;
+
 	mutex_unlock(&adap->dev->i2c_mutex);
 
 	return 0;
@@ -388,8 +393,14 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 		pid, index, onoff);
 
 	if (onoff)
-		if (!pid_filter)
-			ret = lme2510_enable_pid(adap->dev, index, pid);
+		if (!pid_filter) {
+			ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
+			if (ret < 0)
+				return -EAGAIN;
+			ret |= lme2510_enable_pid(adap->dev, index, pid);
+			mutex_unlock(&adap->dev->i2c_mutex);
+	}
+
 
 	return ret;
 }
@@ -1303,5 +1314,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.85");
+MODULE_VERSION("1.86");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

