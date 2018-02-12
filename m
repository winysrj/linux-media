Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:35577 "EHLO
        homiemail-a92.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932378AbeBLXoV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 18:44:21 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 3/4] cx23885: Set subdev host data to clk_freq pointer
Date: Mon, 12 Feb 2018 17:44:07 -0600
Message-Id: <1518479048-10192-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1518479048-10192-1-git-send-email-brad@nextdimension.cc>
References: <1518479048-10192-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently clk_freq is ignored entirely, because the cx235840 driver
configures the xtal at the chip defaults. This is an issue if a
board is produced with a non-default frequency crystal. If clk_freq
is not zero the cx25840 will attempt to use the setting provided,
or fall back to defaults otherwise.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index bd28f9c..45fd2e7 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -2346,6 +2346,10 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840) {
+			/* set host data for clk_freq configuration */
+			v4l2_set_subdev_hostdata(dev->sd_cx25840,
+						&dev->clk_freq);
+
 			dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
 			v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
 		}
-- 
2.7.4
