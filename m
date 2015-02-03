Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59021 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965534AbbBCQYF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 11:24:05 -0500
Message-ID: <54D0F5FF.7060305@users.sourceforge.net>
Date: Tue, 03 Feb 2015 17:23:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] [media] DVB: Less function calls in dvb_ca_en50221_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54D0F4F3.1040405@users.sourceforge.net>
In-Reply-To: <54D0F4F3.1040405@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 3 Feb 2015 16:47:48 +0100

The functions "dvb_unregister_device" and "kfree" could still be called
by the dvb_ca_en50221_init() function in the case that a previous resource
allocation failed.

* Corresponding details could be improved by adjustments for jump targets.

* Let us delete also an unnecessary check for the variable "ca" there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b999689..9842fd1 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1676,14 +1676,14 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	/* initialise the system data */
 	if ((ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL)) == NULL) {
 		ret = -ENOMEM;
-		goto error;
+		goto exit;
 	}
 	ca->pub = pubca;
 	ca->flags = flags;
 	ca->slot_count = slot_count;
 	if ((ca->slot_info = kcalloc(slot_count, sizeof(struct dvb_ca_slot), GFP_KERNEL)) == NULL) {
 		ret = -ENOMEM;
-		goto error;
+		goto free_ca;
 	}
 	init_waitqueue_head(&ca->wait_queue);
 	ca->open = 0;
@@ -1694,7 +1694,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	/* register the DVB device */
 	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA);
 	if (ret)
-		goto error;
+		goto free_slot_info;
 
 	/* now initialise each slot */
 	for (i = 0; i < slot_count; i++) {
@@ -1709,7 +1709,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 
 	if (signal_pending(current)) {
 		ret = -EINTR;
-		goto error;
+		goto unregister_device;
 	}
 	mb();
 
@@ -1720,16 +1720,17 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		ret = PTR_ERR(ca->thread);
 		printk("dvb_ca_init: failed to start kernel_thread (%d)\n",
 			ret);
-		goto error;
+		goto unregister_device;
 	}
 	return 0;
 
-error:
-	if (ca != NULL) {
-		dvb_unregister_device(ca->dvbdev);
-		kfree(ca->slot_info);
-		kfree(ca);
-	}
+unregister_device:
+	dvb_unregister_device(ca->dvbdev);
+free_slot_info:
+	kfree(ca->slot_info);
+free_ca:
+	kfree(ca);
+exit:
 	pubca->private = NULL;
 	return ret;
 }
-- 
2.2.2

