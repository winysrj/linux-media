Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44164 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753868AbeCFTPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:09 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 8/8] cx23885: Fix gpio on Hauppauge QuadHD PCIe cards
Date: Tue,  6 Mar 2018 13:15:02 -0600
Message-Id: <1520363702-25536-9-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bug fix for gpios

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 5a64098..41f5669 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1828,8 +1828,6 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		cx23885_gpio_set(dev, GPIO_2);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
-	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
-	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
 		/*
 		 * HVR5525 GPIO Details:
@@ -1861,7 +1859,9 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		 */
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885:
 		/*
 		 * GPIO-08 TER1_RESN
-- 
2.7.4
