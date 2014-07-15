Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbaGOBJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/18] msi2500: print notice to point SDR API is not 100% stable yet
Date: Tue, 15 Jul 2014 04:09:17 +0300
Message-Id: <1405386561-30450-14-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SDR API is very new and surprises may occur. Due to that print
notice to remind possible users.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 6ed121b..a66a07f 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1487,6 +1487,9 @@ static int msi3101_probe(struct usb_interface *intf,
 	}
 	dev_info(&s->udev->dev, "Registered as %s\n",
 			video_device_node_name(&s->vdev));
+	dev_notice(&s->udev->dev,
+			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
+			KBUILD_MODNAME);
 
 	return 0;
 
-- 
1.9.3

