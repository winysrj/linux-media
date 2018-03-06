Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44147 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753043AbeCFTPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:07 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/8] cx23885: Add tuner type and analog inputs to 1265
Date: Tue,  6 Mar 2018 13:14:58 -0600
Message-Id: <1520363702-25536-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Missing composite and s-video inputs

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 831b066..5a64098 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -788,8 +788,24 @@ struct cx23885_board cx23885_boards[] = {
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1265_K4] = {
 		.name		= "Hauppauge WinTV-HVR-1265(161111)",
+		.porta          = CX23885_ANALOG_VIDEO,
 		.portc		= CX23885_MPEG_DVB,
+		.tuner_type     = TUNER_ABSENT,
 		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN8_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
 	},
 	[CX23885_BOARD_HAUPPAUGE_STARBURST2] = {
 		.name		= "Hauppauge WinTV-Starburst2",
-- 
2.7.4
