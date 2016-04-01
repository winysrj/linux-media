Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33850 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbcDAWik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 18:38:40 -0400
Received: by mail-qg0-f47.google.com with SMTP id n34so100161711qge.1
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 15:38:40 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 0/7] media: tw686x: Improvements
Date: Fri,  1 Apr 2016 19:38:20 -0300
Message-Id: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset contains two groups of improvements:

 * Add support for frame (zero-copy) DMA mode,
   and also scatter-gather DMA mode.

 * Audio improvements: prevent hw param changes,
   and allow period size configuration.

The DMA modes are selected at module insertion time,
through a module parameter called dma_mode.

While it should be theoretically possible to switch this at
runtime, I believe the complexity involved does not worth the
benefit: users will be interested in some specific use case,
and thus will set the DMA mode right from the start.

Note that in scatter-gather mode, only V4L2_FIELD_SEQ_TB
is possible. As far as I can see, in this DMA mode, the
device delivers a sequential top-bottom field frame,
and cannot deliver separate top/bottom frames.

The only sane thing we can do is limit the DMA length
and get a top (or bottom field), but I doubt that's
useful for anyone.

Then again, any additional support can be done as follow
up patches. For instance, the current series does not add
support for the "FIELD" mode provided by the device.

The reason for this is that it looked quite complex, and
required a lot of changes. I'd really like to avoid adding
any complexity until we have some users demanding it.

Series based on v4.6-rc1, plus patch "media: Support
Intersil/Techwell TW686x-based video capture cards"
(https://patchwork.linuxtv.org/patch/33546/)

Ezequiel Garcia (7):
  tw686x: Specify that the DMA is 32 bits
  tw686x: Introduce an interface to support multiple DMA modes
  tw686x: Add support for DMA contiguous interlaced frame mode
  tw686x: Add support for DMA scatter-gather mode
  tw686x: audio: Implement non-memcpy capture
  tw686x: audio: Allow to configure the period size
  tw686x: audio: Prevent hw param changes while busy

 drivers/media/pci/tw686x/Kconfig        |   2 +
 drivers/media/pci/tw686x/tw686x-audio.c |  92 ++++--
 drivers/media/pci/tw686x/tw686x-core.c  |  56 +++-
 drivers/media/pci/tw686x/tw686x-regs.h  |   9 +
 drivers/media/pci/tw686x/tw686x-video.c | 493 +++++++++++++++++++++++++-------
 drivers/media/pci/tw686x/tw686x.h       |  41 ++-
 6 files changed, 545 insertions(+), 148 deletions(-)

-- 
2.7.0

