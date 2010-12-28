Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:20884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0L1Opj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 09:45:39 -0500
Message-ID: <4D19F809.3010409@redhat.com>
Date: Tue, 28 Dec 2010 12:45:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/8] Fix V4L/DVB/RC warnings
References: <e95cvd7ycvmoq6jolupfigs0.1293494109547@email.android.com>	 <4D195584.6020409@redhat.com> <1293545649.2728.28.camel@morgan.silverblock.net>
In-Reply-To: <1293545649.2728.28.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 28-12-2010 12:14, Andy Walls escreveu:
> On Tue, 2010-12-28 at 01:12 -0200, Mauro Carvalho Chehab wrote:
>> Em 27-12-2010 21:55, Andy Walls escreveu:
>>> I have hardware for lirc_zilog.  I can look later this week.
>>
>> That would be great!
> 
> It shouldn't be hard to fix up the lirc_zilog.c use of adap->id but it
> may require a change to the hdpvr driver as well.
> 
> As I was looking, I noticed this commit is incomplete:
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=07cc65d4f4a21a104269ff7e4e7be42bd26d7acb
> 
> The "goto" was missed in the conditional compilation for the HD-PVR:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/staging/lirc/lirc_zilog.c;h=f0076eb025f1a0e9d412080caab87f627dda4970#l844
> 
> You might want to revert the trivial commit that removed the "done:"
> label.  When I clean up the dependence on adap->id, I may need the
> "done:" label back again.
> 
> 
Argh! this is not a very nice code at all...

I think that the proper way is to apply the enclosed patch. After having it
fixed, the dont_wait parameter can be passed to the driver via platform_data.
So, we should add a field at struct IR for it.

Cheers,
Mauro

lirc_zilog: Fix the TX logic for hd-pvr

The dont_wait parameter should be passed to the driver via platform_data, in order
to allow removing the usage of the legacy i2c_adapter.id field.

So, we should add a field at struct IR for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 52be6de..8486b66 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -88,6 +88,7 @@ struct IR {
 	struct i2c_client c_tx;
 	int need_boot;
 	int have_tx;
+	bool dont_wait;
 };
 
 /* Minor -> data mapping */
@@ -841,46 +842,43 @@ static int send_code(struct IR *ir, unsigned int code, unsigned int key)
 		return ret < 0 ? ret : -EFAULT;
 	}
 
-#ifdef I2C_HW_B_HDPVR
 	/*
 	 * The sleep bits aren't necessary on the HD PVR, and in fact, the
 	 * last i2c_master_recv always fails with a -5, so for now, we're
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
-	if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
-		goto done;
-#endif
-
-	/*
-	 * This bit NAKs until the device is ready, so we retry it
-	 * sleeping a bit each time.  This seems to be what the windows
-	 * driver does, approximately.
-	 * Try for up to 1s.
-	 */
-	for (i = 0; i < 20; ++i) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout((50 * HZ + 999) / 1000);
-		ret = i2c_master_send(&ir->c_tx, buf, 1);
-		if (ret == 1)
-			break;
-		dprintk("NAK expected: i2c_master_send "
-			"failed with %d (try %d)\n", ret, i+1);
-	}
-	if (ret != 1) {
-		zilog_error("IR TX chip never got ready: last i2c_master_send "
-			    "failed with %d\n", ret);
-		return ret < 0 ? ret : -EFAULT;
-	}
+	if (!ir->dont_wait) {
+		/*
+		 * This bit NAKs until the device is ready, so we retry it
+		 * sleeping a bit each time.  This seems to be what the
+		 *  windows driver does, approximately.
+		 * Try for up to 1s.
+		 */
+		for (i = 0; i < 20; ++i) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout((50 * HZ + 999) / 1000);
+			ret = i2c_master_send(&ir->c_tx, buf, 1);
+			if (ret == 1)
+				break;
+			dprintk("NAK expected: i2c_master_send "
+				"failed with %d (try %d)\n", ret, i+1);
+		}
+		if (ret != 1) {
+			zilog_error("IR TX chip never got ready: last i2c_master_send "
+				    "failed with %d\n", ret);
+			return ret < 0 ? ret : -EFAULT;
+		}
 
-	/* Seems to be an 'ok' response */
-	i = i2c_master_recv(&ir->c_tx, buf, 1);
-	if (i != 1) {
-		zilog_error("i2c_master_recv failed with %d\n", ret);
-		return -EFAULT;
-	}
-	if (buf[0] != 0x80) {
-		zilog_error("unexpected IR TX response #2: %02x\n", buf[0]);
-		return -EFAULT;
+		/* Seems to be an 'ok' response */
+		i = i2c_master_recv(&ir->c_tx, buf, 1);
+		if (i != 1) {
+			zilog_error("i2c_master_recv failed with %d\n", ret);
+			return -EFAULT;
+		}
+		if (buf[0] != 0x80) {
+			zilog_error("unexpected IR TX response #2: %02x\n", buf[0]);
+			return -EFAULT;
+		}
 	}
 
 	/* Oh good, it worked */
@@ -1278,6 +1276,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		strlcpy(ir->c_tx.name, ZILOG_HAUPPAUGE_IR_TX_NAME,
 			I2C_NAME_SIZE);
 		ir->have_tx = 1;
+
+#ifdef I2C_HW_B_HDPVR
+		if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
+			ir->dont_wait = true;
+#endif
 	}
 
 	/* set lirc_dev stuff */
