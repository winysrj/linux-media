Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:55496 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbcCUNap (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:30:45 -0400
Subject: [PATCH 6/6] drivers/media/dvb-usb-dvb: postpone kfree(mdev)
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 14:30:44 +0100
Message-ID: <145856704399.21117.3101229059196500883.stgit@woodpecker.blarg.de>
In-Reply-To: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes use-after-free bug which occurs when I disconnect my DVB-S
received while VDR is running.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 9ddfcab..7859479 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -95,6 +95,12 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return dvb_usb_ctrl_feed(dvbdmxfeed, 0);
 }
 
+static void dvb_usb_media_device_release(struct media_device *mdev)
+{
+	media_device_cleanup(mdev);
+	kfree(mdev);
+}
+
 static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -113,6 +119,7 @@ static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 	strcpy(mdev->bus_info, udev->devpath);
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
+	mdev->release = dvb_usb_media_device_release;
 
 	media_device_init(mdev);
 
@@ -138,10 +145,11 @@ static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 	if (!adap->dvb_adap.mdev)
 		return;
 
-	media_device_unregister(adap->dvb_adap.mdev);
-	media_device_cleanup(adap->dvb_adap.mdev);
-	kfree(adap->dvb_adap.mdev);
+	struct media_device *mdev = adap->dvb_adap.mdev;
 	adap->dvb_adap.mdev = NULL;
+	media_device_unregister(mdev);
+	/* media_device_cleanup() and kfree() will be called by the
+	   callback function dvb_usb_media_device_release() */
 #endif
 }
 

