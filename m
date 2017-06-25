Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44754 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 0/7] Add block read/write to en50221 CAM functions
Date: Sun, 25 Jun 2017 23:37:04 +0200
Message-Id: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

This is now the V2 version of the patch series with preserved author and
little checkpatch fixes. I also combined some patches which needs to be
applied at once to.

Changes from v1 to v2:
 - Preserved authorship of original author.
 - All patches tested with checkpatch.pl (no errors).
 - Patch "Set maximum cxd2099 block size to 512" is now part of patch
   "Fixed buffer mode", because this needs to be applied together.
 - Patch "Removed useless printing in cxd2099 driver" is now split into a
   part which is already upstream and an additional one.
 - Rebased to media_tree/master.
 
These patch series implement a block read/write interface to the en50221
CAM control functions. The origin of this patches can be found in the
Digital Devices Git on https://github.com/DigitalDevices/dddvb maintained
by Ralph Metzler <rjkm@metzlerbros.de> .
 
The relevant changes concerning dvb-core/dvb_ca_en50221.c/.h and
cxd2099/cxd2099.c/.h have been extracted from the mentioned repository by
Daniel Scheller <d.scheller@gmx.net> and committed to his branch on
https://github.com/herrnst/dddvb-linux-kernel/tree/mediatree/master-cxd2099
 
I split the patch set in smaller pieces for easier review, fixed code style
issues in cxd2099/cxd2099.c/.h and dvb_ca_en50221.c (checkpatch.pl) and
tested the resulting driver on my hardware with the DD DuoFlex CI (single)
card. I tested if the CAM communication is working with VDR:
 vdr: [2414] CAM 1: module ready
 vdr: [2414] CAM 1: AlphaCrypt, 01, 4A20, 4A20
 vdr: [2414] CAM 1: system ids: 0D95 0648 1702 1722 1762 4A20 0500 0B00
                                0100 1833 1834 0D05 0D22
 vdr: [2414] CAM 1: replies to QUERY - multi channel decryption (MCD)
                    possible
 vdr: [2414] CAM 1: supports multi transponder decryption (MTD)
 vdr: [2414] CAM 1: activating MTD support
 vdr: [2405] CAM 1: ready, master (AlphaCrypt)

Please note, that the block read/write functionality is already implemented
in the currently existing cxd2099/cxd2099.c/.h driver, but deactivated. The
existing code in this driver is also not functional and has been updated by
the working implementation from the Digital Devices Git.
 
Additionally to the block read/write functions, I merged also two patches
in the en50221 CAM control state machine, which were existing in the
Digital Devices Git. This are the first two patches of this series.
 
There is another patch series coming "Fix coding style in en50221 CAM
functions" which fixes some of the style issues in
dvb-core/dvb_ca_en50221.c/.h, based on this patch series. I will send this
after this series has been accepted.

Jasmin Jessich (2):
  [staging] cxd2099/cxd2099.c: Removed printing in write_block
  [staging] cxd2099/cxd2099.c: Activate cxd2099 buffer mode

Ralph Metzler (5):
  [media] dvb-core/dvb_ca_en50221.c: State UNINITIALISED instead of
    INVALID
  [media] dvb-core/dvb_ca_en50221.c: Increase timeout for link init
  [media] dvb-core/dvb_ca_en50221.c: Add block read/write functions
  [staging] cxd2099/cxd2099.c/.h: Fixed buffer mode
  [staging] cxd2099/cxd2099.c: Removed useless printing in cxd2099
    driver

 drivers/media/dvb-core/dvb_ca_en50221.c    | 143 +++++++++++++++----------
 drivers/media/dvb-core/dvb_ca_en50221.h    |   7 ++
 drivers/media/pci/ddbridge/ddbridge-core.c |   1 +
 drivers/staging/media/cxd2099/cxd2099.c    | 165 ++++++++++++++++++++---------
 drivers/staging/media/cxd2099/cxd2099.h    |   6 +-
 5 files changed, 217 insertions(+), 105 deletions(-)

-- 
2.7.4
