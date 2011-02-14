Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1BNVNn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:13:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELDhLL014706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:13:43 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGD012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:13:42 -0500
Date: Mon, 14 Feb 2011 19:03:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/14] [media] cx88: Don't allow opening a device while it
 is not ready
Message-ID: <20110214190320.288e9b34@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After registering the cdev, it would be possible do have an open on it.
In a matter of fact, some versions of udev do this. So, move registration
to the end and protect it with a mutex.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index e2fc455..f814886 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1882,6 +1882,15 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 		request_module("ir-kbd-i2c");
 	}
 
+	/* Sets device info at pci_dev */
+	pci_set_drvdata(pci_dev, dev);
+
+	/* initial device configuration */
+	mutex_lock(&core->lock);
+	cx88_set_tvnorm(core, core->tvnorm);
+	init_controls(core);
+	cx88_video_mux(core, 0);
+
 	/* register v4l devices */
 	dev->video_dev = cx88_vdev_init(core,dev->pci,
 					&cx8800_video_template,"video");
@@ -1923,16 +1932,6 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 		       core->name, video_device_node_name(dev->radio_dev));
 	}
 
-	/* everything worked */
-	pci_set_drvdata(pci_dev,dev);
-
-	/* initial device configuration */
-	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,core->tvnorm);
-	init_controls(core);
-	cx88_video_mux(core,0);
-	mutex_unlock(&core->lock);
-
 	/* start tvaudio thread */
 	if (core->board.tuner_type != TUNER_ABSENT) {
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
@@ -1942,11 +1941,14 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 			       core->name, err);
 		}
 	}
+	mutex_unlock(&core->lock);
+
 	return 0;
 
 fail_unreg:
 	cx8800_unregister_video(dev);
 	free_irq(pci_dev->irq, dev);
+	mutex_unlock(&core->lock);
 fail_core:
 	cx88_core_put(core,dev->pci);
 fail_free:
-- 
1.7.1


