Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43545 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeAEAFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:19 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id DF1958ED96
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:18 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/9] Hauppauge em28xx/lgdt3306a soloHD/DualHD support
Date: Thu,  4 Jan 2018 18:04:10 -0600
Message-Id: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brief description of patches:
- Enable the second TS port on em28xx devices via board property
- Enables bulk transfer at max multiplier for em28xx TS1 and TS2
- Changes USB bulk transfer size to match em28xx bulk multiplier
- Increase em28xx arbitrary board limit to max dvb devices
- Add missing Hauppauge bulk model PID's
- Add missing Hauppauge SoloHD PID
- Fix i2c device related usb unplug frontend oops
- Add QAM_AUTO to frontend and an option to enforce a modulation
- Frontend streaming stability optimization

Brad Love (9):
  em28xx: Hauppauge DualHD second tuner functionality
  em28xx: Bulk transfer implementation fix
  em28xx: USB bulk packet size fix
  em28xx: Increase max em28xx boards to max dvb adapters
  em28xx: Add Hauppauge SoloHD/DualHD bulk models
  em28xx: Enable Hauppauge SoloHD rebranded 292e SE
  lgdt3306a: Set fe ops.release to NULL if probed
  lgdt3306a: QAM streaming improvement
  lgdt3306a: Add QAM AUTO support

 drivers/media/dvb-frontends/lgdt3306a.c |  65 ++++++++++++--
 drivers/media/usb/em28xx/em28xx-cards.c | 150 ++++++++++++++++++++++++++++++--
 drivers/media/usb/em28xx/em28xx-core.c  |  54 ++++++++++--
 drivers/media/usb/em28xx/em28xx-dvb.c   |  33 +++++--
 drivers/media/usb/em28xx/em28xx.h       |  16 +++-
 5 files changed, 285 insertions(+), 33 deletions(-)

-- 
2.7.4
