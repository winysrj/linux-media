Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46437 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbeELLYg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 07:24:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id a12-v6so7659100wrn.13
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 04:24:36 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH v3 0/3] IOCTLs in ddbridge
Date: Sat, 12 May 2018 13:24:29 +0200
Message-Id: <20180512112432.30887-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Third iteration of the IOCTL patches for ddbridge, split into multiple
patches:

Patch 1 just adds the reservation/information of the used IOCTLs into
ioctl-numbers.txt in the Docs dir. Doc, s390 and LKML are Cc'ed on
this patch.

Patch 2 adds the header which defines the IOCTLs in include/uapi/ so
userspace applications can directly reuse the IOCTL definitions by
including this file.

Patch 3 (re)implements the IOCTL handling into ddbridge. This is
basically code that was there since literally forever, but had to be
removed along with the initial ddbridge-0.9.x bump.

The whole functionality gets more important these days since ie. the
new MaxSX8 cards may require updating from time to time since these
cards implement the demod/tuner communication in their FPGA (which
normally I2C drivers exist for). Also, the CineS2v7 and derivatives
received some important updates and the possibility to receive higher
bitrate transponders these days, so users should be able to update
their cards.

Changes since the last versions:
- Docs, headers and code split apart and sent out separately to
  the subsystems.
- Only the two absolutely necessary IOCTLs (DDB_FLASHIO and DDB_ID)
  are implemented for now.

Daniel Scheller (3):
  Documentation: ioctl-number: add ddbridge IOCTLs
  [media] ddbridge: uAPI header for IOCTL definitions and related data
    structs
  [media] ddbridge: implement IOCTL handling

 Documentation/ioctl/ioctl-number.txt        |   1 +
 MAINTAINERS                                 |   1 +
 drivers/media/pci/ddbridge/Makefile         |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +----------------
 drivers/media/pci/ddbridge/ddbridge-ioctl.c | 179 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++++
 include/uapi/linux/ddbridge-ioctl.h         |  61 ++++++++++
 7 files changed, 278 insertions(+), 110 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.h
 create mode 100644 include/uapi/linux/ddbridge-ioctl.h

-- 
2.16.1
