Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38125 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753488AbdEUUJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:09:59 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 00/16] ALSA: Convert to new copy_silence PCM ops
Date: Sun, 21 May 2017 22:09:34 +0200
Message-Id: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is a part of the previous RFC patchset, and it's preliminary for
eliminating set_fs() usages in the rest ALSA codes.  This patchset
itself converts the existing copy and silence PCM ops to a new single
copy_silence ops.  The new callback takes in_kernel flag for allowing
in-kernel buffer copy, so that the PCM drivers can pass the buffer in
kernel-space later directly without set_fs() hackery.

The latest codes are found in topic/kill-set_fs branch of sound git
tree.

The media people are Cc'ed for solo6x10 changes.


Takashi

===

Takashi Iwai (16):
  ALSA: pcm: Introduce copy_silence PCM ops
  ALSA: Update document about copy_silence PCM ops
  ALSA: dummy: Convert to copy_silence ops
  ALSA: es1938: Convert to copy_silence ops
  ALSA: korg1212: Convert to copy_silence ops
  ALSA: nm256: Convert to copy_silence ops
  ALSA: rme32: Convert to copy_silence ops
  ALSA: rme96: Convert to copy_silence ops
  ALSA: rme9652: Convert to copy_silence ops
  ALSA: hdsp: Convert to copy_silence ops
  ALSA: gus: Convert to copy_silence ops
  ALSA: sb: Convert to copy_silence ops
  ALSA: sh: Convert to copy_silence ops
  ASoC: blackfin: Convert to copy_silence ops
  [media] solo6x10: Convert to copy_silence ops
  ALSA: pcm: Drop the old copy and silence ops

 .../sound/kernel-api/writing-an-alsa-driver.rst    | 110 ++++++++++--------
 drivers/media/pci/solo6x10/solo6x10-g723.c         |  13 ++-
 include/sound/pcm.h                                |   8 +-
 sound/core/pcm_lib.c                               |  68 ++++++-----
 sound/drivers/dummy.c                              |  13 +--
 sound/isa/gus/gus_pcm.c                            |  43 ++-----
 sound/isa/sb/emu8000_pcm.c                         |  99 +++++-----------
 sound/pci/es1938.c                                 |  11 +-
 sound/pci/korg1212/korg1212.c                      | 128 ++++++---------------
 sound/pci/nm256/nm256.c                            |  35 +++---
 sound/pci/rme32.c                                  |  49 ++++----
 sound/pci/rme96.c                                  |  52 ++++-----
 sound/pci/rme9652/hdsp.c                           |  44 ++++---
 sound/pci/rme9652/rme9652.c                        |  46 ++++----
 sound/sh/sh_dac_audio.c                            |  40 ++-----
 sound/soc/blackfin/bf5xx-ac97-pcm.c                |   6 +-
 sound/soc/blackfin/bf5xx-ac97.c                    |  18 ++-
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |  46 +++-----
 sound/soc/soc-pcm.c                                |   3 +-
 19 files changed, 340 insertions(+), 492 deletions(-)

-- 
2.13.0
