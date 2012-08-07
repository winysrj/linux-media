Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2HGCrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:45 -0400
Received: by vcbfk26 with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:44 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 00/24] Various HVR-950q and xc5000 fixes
Date: Mon,  6 Aug 2012 22:46:50 -0400
Message-Id: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains fixes for a variety of problems found in the
HVR-950q as well as the xc5000 driver.

Details can be found in the individual patches, but it is worth mentioning
specifically that this addresses the MythTV problem causing BUG() to occur,
firmware loading is now significantly improved, and we now have a
redistributable version for the xc5000c firmware.

Devin Heitmueller (24):
  au8522: fix intermittent lockup of analog video decoder
  au8522: Fix off-by-one in SNR table for QAM256
  au8522: properly recover from the au8522 delivering misaligned TS
    streams
  au0828: Make the s_reg and g_reg advanced debug calls work against
    the bridge
  xc5000: properly show quality register values
  xc5000: add support for showing the SNR and gain in the debug output
  xc5000: properly report i2c write failures
  au0828: fix race condition that causes xc5000 to not bind for digital
  au0828: make sure video standard is setup in tuner-core
  au8522: fix regression in logging introduced by separation of modules
  xc5000: don't invoke auto calibration unless we really did reset
    tuner
  au0828: prevent i2c gate from being kept open while in analog mode
  au0828: fix case where STREAMOFF being called on stopped stream
    causes BUG()
  au0828: speed up i2c clock when doing xc5000 firmware load
  au0828: remove control buffer from send_control_msg
  au0828: tune retry interval for i2c interaction
  au0828: fix possible race condition in usage of dev->ctrlmsg
  xc5000: reset device if encountering PLL lock failure
  xc5000: add support for firmware load check and init status
  au0828: tweak workaround for i2c clock stretching bug
  xc5000: show debug version fields in decimal instead of hex
  au0828: fix a couple of missed edge cases for i2c gate with analog
  au0828: make xc5000 firmware speedup apply to the xc5000c as well
  xc5000: change filename to production/redistributable xc5000c
    firmware

 drivers/media/common/tuners/xc5000.c         |  161 +++++++++++++++++++++-----
 drivers/media/dvb/frontends/au8522_common.c  |   22 +++-
 drivers/media/dvb/frontends/au8522_decoder.c |   11 +-
 drivers/media/dvb/frontends/au8522_dig.c     |   98 ++++++++--------
 drivers/media/dvb/frontends/au8522_priv.h    |   29 ++++-
 drivers/media/video/au0828/au0828-cards.c    |    4 +-
 drivers/media/video/au0828/au0828-core.c     |   59 ++++------
 drivers/media/video/au0828/au0828-dvb.c      |   54 ++++++++-
 drivers/media/video/au0828/au0828-i2c.c      |   21 +++-
 drivers/media/video/au0828/au0828-reg.h      |    1 +
 drivers/media/video/au0828/au0828-video.c    |   76 +++++++++---
 drivers/media/video/au0828/au0828.h          |    2 +
 12 files changed, 379 insertions(+), 159 deletions(-)

