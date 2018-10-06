Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35235 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbeJGC0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2018 22:26:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id w5-v6so16720543wrt.2
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2018 12:22:15 -0700 (PDT)
From: Dafna Hirschfeld <dafna3@gmail.com>
To: isely@pobox.com, mchehab@kernel.org, helen.koike@collabora.com,
        hverkuil@xs4all.nl
Cc: outreachy-kernel@googlegroups.com, dafna3@gmail.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH vicodec] media: pvrusb2: replace `printk` with `pr_*`
Date: Sat,  6 Oct 2018 22:21:38 +0300
Message-Id: <20181006192138.11349-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace calls to `printk` with the appropriate `pr_*`
macro.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |  8 ++++----
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 14 ++++++--------
 drivers/media/usb/pvrusb2/pvrusb2-main.c     |  4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c     |  4 ++--
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index a8519da0020b..7702285c1519 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3293,12 +3293,12 @@ void pvr2_hdw_trigger_module_log(struct pvr2_hdw *hdw)
 	int nr = pvr2_hdw_get_unit_number(hdw);
 	LOCK_TAKE(hdw->big_lock);
 	do {
-		printk(KERN_INFO "pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
+		pr_info("pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, core, log_status);
 		pvr2_trace(PVR2_TRACE_INFO,"cx2341x config:");
 		cx2341x_log_status(&hdw->enc_ctl_state, "pvrusb2");
 		pvr2_hdw_state_log_state(hdw);
-		printk(KERN_INFO "pvrusb2: ==================  END STATUS CARD #%d  ==================\n", nr);
+		pr_info("pvrusb2: ==================  END STATUS CARD #%d  ==================\n", nr);
 	} while (0);
 	LOCK_GIVE(hdw->big_lock);
 }
@@ -4851,7 +4851,7 @@ static void pvr2_hdw_state_log_state(struct pvr2_hdw *hdw)
 	for (idx = 0; ; idx++) {
 		ccnt = pvr2_hdw_report_unlocked(hdw,idx,buf,sizeof(buf));
 		if (!ccnt) break;
-		printk(KERN_INFO "%s %.*s\n",hdw->name,ccnt,buf);
+		pr_info("%s %.*s\n", hdw->name, ccnt, buf);
 	}
 	ccnt = pvr2_hdw_report_clients(hdw, buf, sizeof(buf));
 	if (ccnt >= sizeof(buf))
@@ -4863,7 +4863,7 @@ static void pvr2_hdw_state_log_state(struct pvr2_hdw *hdw)
 		while ((lcnt + ucnt < ccnt) && (buf[lcnt + ucnt] != '\n')) {
 			lcnt++;
 		}
-		printk(KERN_INFO "%s %.*s\n", hdw->name, lcnt, buf + ucnt);
+		pr_info("%s %.*s\n", hdw->name, lcnt, buf + ucnt);
 		ucnt += lcnt + 1;
 	}
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index ec7d32759e39..06c7e875fa0f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -478,8 +478,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 		unsigned int idx,offs,cnt;
 		for (idx = 0; idx < num; idx++) {
 			cnt = msgs[idx].len;
-			printk(KERN_INFO
-			       "pvrusb2 i2c xfer %u/%u: addr=0x%x len=%d %s",
+			pr_info("pvrusb2 i2c xfer %u/%u: addr=0x%x len=%d %s",
 			       idx+1,num,
 			       msgs[idx].addr,
 			       cnt,
@@ -501,8 +500,7 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 			printk(KERN_CONT "\n");
 		}
 		if (!num) {
-			printk(KERN_INFO
-			       "pvrusb2 i2c xfer null transfer result=%d\n",
+			pr_info("pvrusb2 i2c xfer null transfer result=%d\n",
 			       ret);
 		}
 	}
@@ -542,14 +540,14 @@ static int do_i2c_probe(struct pvr2_hdw *hdw, int addr)
 static void do_i2c_scan(struct pvr2_hdw *hdw)
 {
 	int i;
-	printk(KERN_INFO "%s: i2c scan beginning\n", hdw->name);
+	pr_info("%s: i2c scan beginning\n", hdw->name);
 	for (i = 0; i < 128; i++) {
 		if (do_i2c_probe(hdw, i)) {
-			printk(KERN_INFO "%s: i2c scan: found device @ 0x%x\n",
+			pr_info("%s: i2c scan: found device @ 0x%x\n",
 			       hdw->name, i);
 		}
 	}
-	printk(KERN_INFO "%s: i2c scan done.\n", hdw->name);
+	pr_info("%s: i2c scan done.\n", hdw->name);
 }
 
 static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
@@ -612,7 +610,7 @@ void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
 
 	/* However, deal with various special cases for 24xxx hardware. */
 	if (ir_mode[hdw->unit_number] == 0) {
-		printk(KERN_INFO "%s: IR disabled\n",hdw->name);
+		pr_info("%s: IR disabled\n", hdw->name);
 		hdw->i2c_func[0x18] = i2c_black_hole;
 	} else if (ir_mode[hdw->unit_number] == 1) {
 		if (hdw->ir_scheme_active == PVR2_IR_SCHEME_24XXX) {
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-main.c b/drivers/media/usb/pvrusb2/pvrusb2-main.c
index cbe2c3a22458..23672dd352f5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-main.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-main.c
@@ -132,10 +132,10 @@ static int __init pvr_init(void)
 	ret = usb_register(&pvr_driver);
 
 	if (ret == 0)
-		printk(KERN_INFO "pvrusb2: " DRIVER_VERSION ":"
+		pr_info("pvrusb2: " DRIVER_VERSION ":"
 		       DRIVER_DESC "\n");
 	if (pvrusb2_debug)
-		printk(KERN_INFO "pvrusb2: Debug mask is %d (0x%x)\n",
+		pr_info("pvrusb2: Debug mask is %d (0x%x)\n",
 		       pvrusb2_debug,pvrusb2_debug);
 
 	pvr2_trace(PVR2_TRACE_INIT,"pvr_init complete");
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index cea232a3302d..97a93ed4bcda 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -869,7 +869,7 @@ static void pvr2_v4l2_dev_destroy(struct pvr2_v4l2_dev *dip)
 	   are gone. */
 	video_unregister_device(&dip->devbase);
 
-	printk(KERN_INFO "%s\n", msg);
+	pr_info("%s\n", msg);
 
 }
 
@@ -1260,7 +1260,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 			": Failed to register pvrusb2 v4l device\n");
 	}
 
-	printk(KERN_INFO "pvrusb2: registered device %s [%s]\n",
+	pr_info("pvrusb2: registered device %s [%s]\n",
 	       video_device_node_name(&dip->devbase),
 	       pvr2_config_get_name(dip->config));
 
-- 
2.17.1
