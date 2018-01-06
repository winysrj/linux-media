Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:43168 "EHLO
        homiemail-a82.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753372AbeAFAs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 19:48:26 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/4] New Hauppauge PCIe devices
Date: Fri,  5 Jan 2018 18:48:18 -0600
Message-Id: <1515199702-16083-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Included is support for the following four PCIe devices:
- Hauppauge ImpactVCBe - analog PAL/NTSC
- Hauppauge HVR1264K4 - ATSC/QAM + analog
- Hauppauge Starburst2 - DVB-C/S/T/T2 + analog
- Hauppauge digital only QuadHD models - ATSC/QAM|DVB-C/T/T2

Brad Love (4):
  cx23885: Enable new Hauppauge PCIe ImpactVCBe variant
  cx23885: Add support for Hauppauge PCIe HVR1265 K4
  cx23885: Add support for Hauppauge PCIe Starburst2
  cx23885: Add support for new Hauppauge QuadHD (885)

 drivers/media/pci/cx23885/cx23885-cards.c | 86 ++++++++++++++++++++++++++-----
 drivers/media/pci/cx23885/cx23885-core.c  |  8 +++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 70 ++++++++++++++++++++++---
 drivers/media/pci/cx23885/cx23885-input.c |  3 ++
 drivers/media/pci/cx23885/cx23885-video.c |  5 +-
 drivers/media/pci/cx23885/cx23885.h       |  4 ++
 6 files changed, 155 insertions(+), 21 deletions(-)

-- 
2.7.4
