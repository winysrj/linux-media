Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56622 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbaGRBFW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 21:05:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] airspy: print notice to point SDR API is not 100% stable yet
Date: Fri, 18 Jul 2014 04:05:12 +0300
Message-Id: <1405645513-25616-3-git-send-email-crope@iki.fi>
In-Reply-To: <1405645513-25616-1-git-send-email-crope@iki.fi>
References: <1405645513-25616-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print notice on driver load: "SDR API is still slightly
experimental and functionality changes may follow". It is just
remind possible used SDR API is very new and surprises may occur.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 5b3310f..6cf09ef 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -1086,7 +1086,9 @@ static int airspy_probe(struct usb_interface *intf,
 	}
 	dev_info(&s->udev->dev, "Registered as %s\n",
 			video_device_node_name(&s->vdev));
-
+	dev_notice(&s->udev->dev,
+			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
+			KBUILD_MODNAME);
 	return 0;
 
 err_free_controls:
-- 
1.9.3

