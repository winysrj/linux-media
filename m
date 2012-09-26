Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31621 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab2IZNzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 09:55:20 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dvb-usb: print small buffers via %*ph
Date: Wed, 26 Sep 2012 16:55:14 +0300
Message-Id: <1348667714-5782-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/usb/dvb-usb/a800.c           |    2 +-
 drivers/media/usb/dvb-usb/cinergyT2-core.c |    3 +--
 drivers/media/usb/dvb-usb/dibusb-common.c  |    2 +-
 drivers/media/usb/dvb-usb/digitv.c         |    2 +-
 drivers/media/usb/dvb-usb/dtt200u.c        |    2 +-
 drivers/media/usb/dvb-usb/m920x.c          |    2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb/a800.c
index 8d7fef8..83684ed 100644
--- a/drivers/media/usb/dvb-usb/a800.c
+++ b/drivers/media/usb/dvb-usb/a800.c
@@ -93,7 +93,7 @@ static int a800_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	/* call the universal NEC remote processor, to find out the key's state and event */
 	dvb_usb_nec_rc_key_to_event(d,key,event,state);
 	if (key[0] != 0)
-		deb_rc("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
+		deb_rc("key: %*ph\n", 5, key);
 	ret = 0;
 out:
 	kfree(key);
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 0a98548..9fd1527 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -172,8 +172,7 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		if (*event != d->last_event)
 			st->rc_counter = 0;
 
-		deb_rc("key: %x %x %x %x %x\n",
-		       key[0], key[1], key[2], key[3], key[4]);
+		deb_rc("key: %*ph\n", 5, key);
 	}
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index a76bbb2..af0d432 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -473,7 +473,7 @@ int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
 	dvb_usb_nec_rc_key_to_event(d,key,event,state);
 	if (key[0] != 0)
-		deb_info("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
+		deb_info("key: %*ph\n", 5, key);
 	return 0;
 }
 EXPORT_SYMBOL(dibusb_rc_query);
diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
index ff34419..772bde3 100644
--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -253,7 +253,7 @@ static int digitv_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	}
 
 	if (key[0] != 0)
-		deb_rc("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
+		deb_rc("key: %*ph\n", 5, key);
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index 66f205c..c357fb3 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -84,7 +84,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
 	dvb_usb_nec_rc_key_to_event(d,key,event,state);
 	if (key[0] != 0)
-		deb_info("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
+		deb_info("key: %*ph\n", 5, key);
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 288af29..661bb75 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -358,7 +358,7 @@ static int m920x_firmware_download(struct usb_device *udev, const struct firmwar
 
 	if ((ret = m920x_read(udev, M9206_FILTER, 0x0, 0x8000, read, 4)) != 0)
 		goto done;
-	deb("%x %x %x %x\n", read[0], read[1], read[2], read[3]);
+	deb("%*ph\n", 4, read);
 
 	if ((ret = m920x_read(udev, M9206_FW, 0x0, 0x0, read, 1)) != 0)
 		goto done;
-- 
1.7.10.4

