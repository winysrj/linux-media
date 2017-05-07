Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755693AbdEGWFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:05:07 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 0/7] Add block read/write to en50221 CAM functions
Date: Sun,  7 May 2017 22:51:46 +0200
Message-Id: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

These patch series implement a block read/write interface to the en50221
CAM control functions. The origin of this patches can be found in the
Digital Devices Git on https://github.com/DigitalDevices/dddvb maintained
by Ralph Metzler <rjkm@metzlerbros.de>

The relevant changes concerning dvb-core/dvb_ca_en50221.c/.h and
cxd2099/cxd2099.c/.h have been extracted from the mentioned repository by
Daniel Scheller <d.scheller@gmx.net> and committed to his branch on
https://github.com/herrnst/dddvb-linux-kernel/tree/mediatree/master-cxd2099

I split the patch set is smaller pieces for easier review, compiled each
step, fixed code style issues in cxd2099/cxd2099.c/.h (checkpatch.pl) and
tested the resulting driver on my hardware with the DD DuoFlex CI (single)
card.

Please note, that the block read/write functionality is already implemented
in the currently existing cxd2099/cxd2099.c/.h driver, but deactivated. The
existing code in this driver is also not functional and has been updated by
the working implementation from the Digital Devices Git.

Additionally to the block read/write functions, I merged also two patches
in the en50221 CAM control state machine, which were existing in the
Digital Devices Git. This are the first two patches of this series.

There is another patch series coming soon "Fix coding style in en50221 CAM
functions" which fixes nearly all the style issues in
dvb-core/dvb_ca_en50221.c/.h, based on this patch series. So please be
patient, if any of the dvb_ca_en50221.c/.h might be not 100% checkpatch.pl
compliant. I tried to keep the original patch code from DD as much as
possible.

Apologizes if anything regarding the patch submission is/went wrong, as
this is my first time contribution of a patch set.


Jasmin Jessich (7):
  [media] dvb-core/dvb_ca_en50221.c: State UNINITIALISED instead of INVALID
  [media] dvb-core/dvb_ca_en50221.c: Increase timeout for link init
  [media] dvb-core/dvb_ca_en50221.c: Add block read/write functions
  [staging] cxd2099/cxd2099.c/.h: Fixed buffer mode
  [media] ddbridge/ddbridge-core.c: Set maximum cxd2099 block size to 512
  [staging] cxd2099/cxd2099.c: Removed useless printing in cxd2099 driver
  [staging] cxd2099/cxd2099.c: Activate cxd2099 buffer mode

 drivers/media/dvb-core/dvb_ca_en50221.c    | 121 ++++++++-------
 drivers/media/dvb-core/dvb_ca_en50221.h    |   7 +
 drivers/media/pci/ddbridge/ddbridge-core.c |   1 +
 drivers/staging/media/cxd2099/cxd2099.c    | 237 ++++++++++++++---------------
 drivers/staging/media/cxd2099/cxd2099.h    |   6 +-
 5 files changed, 196 insertions(+), 176 deletions(-)

-- 
2.7.4
