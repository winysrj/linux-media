Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:43171 "EHLO
        homiemail-a82.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753442AbeAFAs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 19:48:26 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/4] cx23885: Enable new Hauppauge PCIe ImpactVCBe variant
Date: Fri,  5 Jan 2018 18:48:19 -0600
Message-Id: <1515199702-16083-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515199702-16083-1-git-send-email-brad@nextdimension.cc>
References: <1515199702-16083-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ID of new card revision to driver list

Analog PAL/NTSC capture.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 3622521..c4b3123 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1028,6 +1028,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subdevice = 0x7133,
 		.card      = CX23885_BOARD_HAUPPAUGE_IMPACTVCBE,
 	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0x7137,
+		.card      = CX23885_BOARD_HAUPPAUGE_IMPACTVCBE,
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb98,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2,
-- 
2.7.4
