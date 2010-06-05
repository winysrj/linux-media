Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab0FEAVY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:24 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LOiK012574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:24 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7l015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:23 -0400
Date: Fri, 4 Jun 2010 21:21:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/6] tm6000: Fix compilation breakages
Message-ID: <20100604212108.4e1f233e@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A previous patch seemed to break compilation of the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 mode change 100644 => 100755 Documentation/video4linux/extract_xc3028.pl

diff --git a/Documentation/video4linux/extract_xc3028.pl b/Documentation/video4linux/extract_xc3028.pl
old mode 100644
new mode 100755
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 4a8c659..50756e5 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -683,7 +683,6 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	tm6000_add_into_devlist(dev);
 	tm6000_init_extension(dev);
 
-	}
 	mutex_unlock(&dev->lock);
 	return 0;
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 2fbf4f6..1f2765c 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -295,7 +295,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x20);
 		else	/* Enable Hfilter and disable TS Drop err */
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x80);
-		}
 
 		tm6000_set_reg(dev, TM6010_REQ07_RC3_HSTART1, 0x88);
 		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_WAKEUP_SEL, 0x23);
@@ -401,7 +400,7 @@ int tm6000_init_digital_mode(struct tm6000_core *dev)
 
 	return 0;
 }
-EXPORT_SYMBOL(tm6000_init_digial_mode);
+EXPORT_SYMBOL(tm6000_init_digital_mode);
 
 struct reg_init {
 	u8 req;
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 3ccc466..5ee1aff 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -38,7 +38,7 @@ MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
 			"{{Trident, tm6000},"
 			"{{Trident, tm6010}");
 
-static int debug
+static int debug;
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug message");
@@ -191,7 +191,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 		dvb->streams = 1;
 /*		mutex_init(&tm6000_dev->streming_mutex); */
 		tm6000_start_stream(dev);
-	} else {
+	} else
 		++(dvb->streams);
 	mutex_unlock(&dvb->mutex);
 
@@ -227,7 +227,7 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 	if (dev->caps.has_zl10353) {
 		struct zl10353_config config = {
-				     demod_address = dev->demod_addr,
+				     .demod_address = dev->demod_addr,
 				     .no_tuner = 1,
 				     .parallel_ts = 1,
 				     .if2 = 45700,
@@ -390,7 +390,7 @@ static int dvb_init(struct tm6000_core *dev)
 	int rc;
 
 	if (!dev)
-		retrun 0;
+		return 0;
 
 	if (!dev->caps.has_dvb)
 		return 0;
@@ -427,7 +427,7 @@ static int dvb_fini(struct tm6000_core *dev)
 		dev->dvb = NULL;
 	}
 
-	retrun 0;
+	return 0;
 }
 
 static struct tm6000_ops dvb_ops = {
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 4b65094..18d1e51 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -269,9 +269,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
 
-int tm6000_dvb_register(struct tm6000_core *dev);
-void tm6000_dvb_unregister(struct tm6000_core *dev);
-
 int tm6000_v4l2_register(struct tm6000_core *dev);
 int tm6000_v4l2_unregister(struct tm6000_core *dev);
 int tm6000_v4l2_exit(void);
-- 
1.7.1


