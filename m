Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34616 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940290AbdDSXOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:03 -0400
Received: by mail-qk0-f179.google.com with SMTP id y63so2957283qkd.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:02 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 00/12] minor cleanups for HVR-950q
Date: Wed, 19 Apr 2017 19:13:43 -0400
Message-Id: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of mostly minor cleanups/fixes for the HVR-950q
driver.  We'll get this stuff merged since it's non-controversial,
and then we can argue about the more invasive patches to follow.

Devin Heitmueller (12):
  au8522: don't attempt to configure unsupported VBI slicer
  au8522: don't touch i2c master registers on au8522
  au8522: rework setup of audio routing
  au8522: remove note about VBI not being implemented
  au8522: remove leading bit for register writes
  au8522 Remove 0x4 bit for register reads
  au8522: fix lock detection to be more reliable.
  Add USB quirk for HVR-950q to avoid intermittent device resets
  xc5000: Don't spin waiting for analog lock
  au8522: Set the initial modulation
  Fix breakage in "make menuconfig" for media_build
  au0828: Add timer to restart TS stream if no data arrives on bulk
    endpoint

 drivers/media/dvb-frontends/au8522_common.c  |   1 +
 drivers/media/dvb-frontends/au8522_decoder.c |  74 +++------
 drivers/media/dvb-frontends/au8522_dig.c     | 215 +++++++++++++--------------
 drivers/media/rc/Kconfig                     |   8 +-
 drivers/media/tuners/xc5000.c                |  26 +---
 drivers/media/usb/au0828/au0828-dvb.c        |  30 ++++
 drivers/media/usb/au0828/au0828.h            |   2 +
 drivers/usb/core/quirks.c                    |   4 +
 8 files changed, 168 insertions(+), 192 deletions(-)

-- 
1.9.1
