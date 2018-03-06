Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44181 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbeCFTPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:40 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/4] [resend] cx25840: Add non-default crystal frequency support
Date: Tue,  6 Mar 2018 13:15:33 -0600
Message-Id: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge produced a revision of ImpactVCBe using an 888,
with a 25MHz crystal, instead of using the default third
overtone 50Mhz crystal. Custom configuration of the cx25840
is required to load the firmware and properly decode video.

This patch set add an extra clocking option to the cx25840 driver.
If a cx2388x board is produced using non-default crystal, then
clk_freq can be set in the board profile and then used by the
cx25840 to set up the PLL's. To pass frequency, the cx23885 driver
sets the cx25840 v4l subdev host data to a pointer to clk_freq.

The only additional clock rate included is cx23888 with 25MHz crystal.

Brad Love (4):
  cx25840: Use subdev host data for PLL override
  cx23885: change 887/888 default to 888
  cx23885: Set subdev host data to clk_freq pointer
  cx23885: Override 888 ImpactVCBe crystal frequency

 drivers/media/i2c/cx25840/cx25840-core.c  | 28 ++++++++++++++++++++++------
 drivers/media/pci/cx23885/cx23885-cards.c |  4 ++++
 drivers/media/pci/cx23885/cx23885-core.c  | 16 +++++++++++++---
 3 files changed, 39 insertions(+), 9 deletions(-)

-- 
2.7.4
