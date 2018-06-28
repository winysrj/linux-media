Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:38945 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752305AbeF1R3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 13:29:44 -0400
From: Brad Love <brad@nextdimension.cc>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2] em28xx: Fix dual transport stream operation
Date: Thu, 28 Jun 2018 12:29:09 -0500
Message-Id: <1530206949-16122-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1530206949-16122-1-git-send-email-brad@nextdimension.cc>
References: <1530206949-16122-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Addresses the following, which introduced a regression itself:

Commit 509f89652f83 ("media: em28xx: fix a regression with HVR-950")

The regression fix breaks dual transport stream support. Currently,
when a tuner starts streaming it sets alt mode on the USB interface.
The problem is, in a dual tuner model, both tuners share the same
USB interface, so when the second tuner becomes active and sets alt
mode on the interface it kills streaming on the other port.

This patch addresses the regression by only setting alt mode
on the USB interface during em28xx_start_streaming, if the
device is not a dual tuner model. This allows all older and
single tuner devices to explicitly set alt mode during stream
startup. Testers report both isoc and bulk DualHD models work
correctly with the alt mode set only once, in em28xx_dvb_init.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Since v1:
- Removed all locking and shared state
- Only set alt mode in start_streaming if not a dual tuner device

 drivers/media/usb/em28xx/em28xx-dvb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index b778d8a..a73faf1 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -218,7 +218,9 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
-	usb_set_interface(udev, dev->ifnum, dvb_alt);
+	if (!dev->board.has_dual_ts)
+		usb_set_interface(udev, dev->ifnum, dvb_alt);
+
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
-- 
2.7.4
