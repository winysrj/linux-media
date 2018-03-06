Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44189 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753902AbeCFTPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:41 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/4] cx23885: change 887/888 default to 888
Date: Tue,  6 Mar 2018 13:15:35 -0600
Message-Id: <1520363737-25724-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
References: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Proper cx2388x chip type is detected in cx25840 probe, the clock
rate is untouched however in probe. The cx25840 only checks for
non default clock values for 888 and provides custom settings for
25MHz 888. This change ensures that cx23888 chips with default 50MHz
crystals will not get configured as if they have 25MHz crystals. A
cx23887 board will continue to be configured for 25Hz crystal as
there is no custom clock support included for it.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 8afddd6..2c76a02 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -839,10 +839,10 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	/* Configure the internal memory */
 	if (dev->pci->device == 0x8880) {
-		/* Could be 887 or 888, assume a default */
-		dev->bridge = CX23885_BRIDGE_887;
+		/* Could be 887 or 888, assume an 888 default */
+		dev->bridge = CX23885_BRIDGE_888;
 		/* Apply a sensible clock frequency for the PCIe bridge */
-		dev->clk_freq = 25000000;
+		dev->clk_freq = 50000000;
 		dev->sram_channels = cx23887_sram_channels;
 	} else
 	if (dev->pci->device == 0x8852) {
-- 
2.7.4
