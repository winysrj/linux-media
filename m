Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51555 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2GAUPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:44 -0400
Received: by qaas11 with SMTP id s11so1561997qaa.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:43 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 0/6] Various cx23885 analog fixes
Date: Sun,  1 Jul 2012 16:15:08 -0400
Message-Id: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains fixes for various cx23885 boards, as well as
introducing support for analog for the HVR-1250 and 1255.

Devin Heitmueller (6):
  cx25840: fix regression in HVR-1800 analog support
  cx25840: fix regression in HVR-1800 analog support hue/saturation
    controls
  cx25840: fix regression in HVR-1800 analog audio
  cx25840: fix vsrc/hsrc usage on cx23888 designs
  cx23885: make analog support work for HVR_1250 (cx23885 variant)
  cx23885: add support for HVR-1255 analog (cx23888 variant)

 drivers/media/video/cx23885/cx23885-cards.c |   87 ++++++++++++++++++++++++---
 drivers/media/video/cx23885/cx23885-dvb.c   |    6 ++
 drivers/media/video/cx23885/cx23885-video.c |    9 +++-
 drivers/media/video/cx23885/cx23885.h       |    1 +
 drivers/media/video/cx25840/cx25840-core.c  |   76 +++++++++++++++++------
 5 files changed, 149 insertions(+), 30 deletions(-)

