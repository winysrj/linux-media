Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:35777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932542AbeFPTEY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 15:04:24 -0400
MIME-Version: 1.0
Message-ID: <trinity-cafeb225-0ac3-4459-8801-092eb770afe0-1529175862331@3c-app-gmx-bs34>
From: "Robert Schlabbach" <Robert.Schlabbach@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: em28xx: explicitly disable TS packet filter
Content-Type: text/plain; charset=UTF-8
Date: Sat, 16 Jun 2018 21:04:22 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver never touched the EM2874 register bits that control
the transport stream packet filters, leaving them at whatever default
the firmware has set. E.g. the Pinnacle 290e disables them by default,
while the Hauppauge WinTV dualHD enables discarding NULL packets by
default.

However, some applications require NULL packets, e.g. to determine the
load in DOCSIS segments, so discarding NULL packets is undesired for
such applications.

This patch simply extends the bit mask when starting or stopping the
transport stream packet capture, so that the filter bits are cleared.
It has been verified that this makes the Hauppauge WinTV dualHD pass
an unfiltered DVB-C stream including NULL packets, which it didn't
before.

Signed-off-by: Robert Schlabbach <Robert.Schlabbach@gmx.net>
---
 drivers/media/usb/em28xx/em28xx-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index f70845e..45b2477 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -655,12 +655,12 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 			rc = em28xx_write_reg_bits(dev,
 						   EM2874_R5F_TS_ENABLE,
 						   start ? EM2874_TS1_CAPTURE_ENABLE : 0x00,
-						   EM2874_TS1_CAPTURE_ENABLE);
+						   EM2874_TS1_CAPTURE_ENABLE | EM2874_TS1_FILTER_ENABLE | EM2874_TS1_NULL_DISCARD);
 		else
 			rc = em28xx_write_reg_bits(dev,
 						   EM2874_R5F_TS_ENABLE,
 						   start ? EM2874_TS2_CAPTURE_ENABLE : 0x00,
-						   EM2874_TS2_CAPTURE_ENABLE);
+						   EM2874_TS2_CAPTURE_ENABLE | EM2874_TS2_FILTER_ENABLE | EM2874_TS2_NULL_DISCARD);
 	} else {
 		/* FIXME: which is the best order? */
 		/* video registers are sampled by VREF */
-- 
2.7.4
