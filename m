Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44128 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753807AbeCFTPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:06 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/8] FIXME: Assorted of missed bits from merge
Date: Tue,  6 Mar 2018 13:14:54 -0600
Message-Id: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Here are the assorted bits and bobs that wound up missing
due to the patchwork snafu.

One new patch is:
- cx231xx: Set mfe_shared if second frontend found

Due to your suggestion in regards to the shared tuner logic.
I put the check in what seems like a sensical spot.

Brad Love (8):
  lgdt3306a: remove symbol count mismatch fix
  em28xx: Change hex to lower case
  cx231xx: Use frontend i2c adapter with tuner
  cx23885: Add tuner type and analog inputs to 1265
  cx231xx: Set mfe_shared if second frontend found
  cx231xx: Use constant instead of hard code for max
  cx231xx: Add second i2c demod to Hauppauge 975
  cx23885: Fix gpio on Hauppauge QuadHD PCIe cards

 drivers/media/dvb-frontends/lgdt3306a.c   | 10 ++----
 drivers/media/pci/cx23885/cx23885-cards.c | 20 +++++++++--
 drivers/media/usb/cx231xx/cx231xx-cards.c |  1 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 60 ++++++++++++++++++++++++++++---
 drivers/media/usb/em28xx/em28xx-core.c    |  2 +-
 5 files changed, 77 insertions(+), 16 deletions(-)

-- 
2.7.4
