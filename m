Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:58466 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752193AbdEJJ6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 05:58:16 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: <zhaoxuegang@suntec.net>,
        "Ezequiel Garcia" <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] TW686x: Fix OOPS on buffer alloc failure
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
Date: Wed, 10 May 2017 11:51:28 +0200
In-Reply-To: <m3h90thwjt.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
        "Wed, 10 May 2017 11:48:38 +0200")
Message-ID: <m3d1bhhwf3.fsf_-_@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa9..d637f47 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1190,6 +1190,13 @@ int tw686x_video_init(struct tw686x_dev *dev)
 			return err;
 	}
 
+	/* Initialize vc->dev and vc->ch for the error path first */
+	for (ch = 0; ch < max_channels(dev); ch++) {
+		struct tw686x_video_channel *vc = &dev->video_channels[ch];
+		vc->dev = dev;
+		vc->ch = ch;
+	}
+
 	for (ch = 0; ch < max_channels(dev); ch++) {
 		struct tw686x_video_channel *vc = &dev->video_channels[ch];
 		struct video_device *vdev;
@@ -1198,9 +1205,6 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		spin_lock_init(&vc->qlock);
 		INIT_LIST_HEAD(&vc->vidq_queued);
 
-		vc->dev = dev;
-		vc->ch = ch;
-
 		/* default settings */
 		err = tw686x_set_standard(vc, V4L2_STD_NTSC);
 		if (err)
