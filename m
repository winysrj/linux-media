Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51428 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752297AbeCCUvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/11] em28xx: coding style improvements
Date: Sat,  3 Mar 2018 17:51:01 -0300
Message-Id: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As there are significant changes on em28xx-cards and em28xx-dvb,
take some time to solve coding style issues there.

This series contain only "cosmetic" changes, although there is
a non-trivial change at em28xx-cards, making its probe function
easier to read.

Anyway, no behavior changes should be noticed after this
patch series.

Mauro Carvalho Chehab (11):
  em28xx: Add SPDX license tags where needed
  em28xx.h: Fix most coding style issues
  media: em28xx-reg.h: Fix coding style issues
  media: em28xx-audio: fix coding style issues
  media: em28xx-camera: fix coding style issues
  media: em28xx-cards: fix most coding style issues
  media:: rework the em28xx probing code
  media: em28xx-core: fix most coding style issues
  media: em28xx-i2c: fix most coding style issues
  media: em28xx-input: fix most coding style issues
  media: em28xx-video: fix most coding style issues

 drivers/media/usb/em28xx/em28xx-audio.c  | 116 +++---
 drivers/media/usb/em28xx/em28xx-camera.c |  49 ++-
 drivers/media/usb/em28xx/em28xx-cards.c  | 594 +++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-core.c   | 128 ++++---
 drivers/media/usb/em28xx/em28xx-dvb.c    |  46 +--
 drivers/media/usb/em28xx/em28xx-i2c.c    | 131 +++----
 drivers/media/usb/em28xx/em28xx-input.c  | 163 +++++----
 drivers/media/usb/em28xx/em28xx-reg.h    |  50 +--
 drivers/media/usb/em28xx/em28xx-v4l.h    |  27 +-
 drivers/media/usb/em28xx/em28xx-vbi.c    |  39 +-
 drivers/media/usb/em28xx/em28xx-video.c  | 329 +++++++++--------
 drivers/media/usb/em28xx/em28xx.h        | 338 ++++++++++--------
 12 files changed, 1096 insertions(+), 914 deletions(-)

-- 
2.14.3
