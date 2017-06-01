Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42385 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751029AbdFAU7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:05 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 00/27] Revised full patchset for PCM in-kernel copy support
Date: Thu,  1 Jun 2017 22:58:23 +0200
Message-Id: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is a full patchset of what I sent previously, containing the all
changes instead of the snippet.  The main purpose of this patchset is
to eliminate the remaining usages of set_fs().  They are basically
used for in-kernel PCM data transfer, and this patch provides the new
API functions and replaces the hackish set_fs() calls with them.

Unlike the first patchset with the unified copy_silence ops, this adds
a new copy_kernel ops instead.  At the same time, copy/silence are
changed to receive the position and size in bytes instead of frames.
This allows us to simplify the PCM core code.  As a result, a good
amount of code could be removed from pcm_lib.c.

The difference from the previous patchset is that this is a full
patchset, i.e. all relevant drivers have been covered, and also some
small issues have been addressed, in addition, the documentation
update is provided, too.

I'm Cc'ing the media and the USB people since it touches solo6x10 and
usb-gadget drivers.

The previous ACK was dropped as each patch was rewritten again.  Sorry
for the doubly patch-review labours.


thanks,

Takashi

===

Takashi Iwai (26):
  ALSA: pcm: Introduce copy_user, copy_kernel and fill_silence ops
  ALSA: dummy: Convert to new PCM copy ops
  ALSA: es1938: Convert to the new PCM copy ops
  ALSA: nm256: Convert to new PCM copy ops
  ALSA: korg1212: Convert to the new PCM ops
  ALSA: rme32: Convert to the new PCM copy ops
  ALSA: rme96: Convert to the new PCM ops
  ALSA: rme9652: Convert to the new PCM ops
  ALSA: hdsp: Convert to the new PCM ops
  ALSA: gus: Convert to the new PCM ops
  ALSA: sb: Convert to the new PCM ops
  ALSA: sh: Convert to the new PCM ops
  ASoC: blackfin: Convert to the new PCM ops
  [media] solo6x10: Convert to the new PCM ops
  ALSA: pcm: Drop the old copy and silence ops
  ALSA: pcm: Check PCM state by a common helper function
  ALSA: pcm: Shuffle codes
  ALSA: pcm: Call directly the common read/write helpers
  ALSA: pcm: More unification of PCM transfer codes
  ALSA: pcm: Unify read/write loop
  ALSA: pcm: Simplify snd_pcm_playback_silence()
  ALSA: pcm: Direct in-kernel read/write support
  usb: gadget: u_uac1: Kill set_fs() usage
  ALSA: pcm: Kill set_fs() in PCM OSS layer
  ALSA: pcm: Build OSS writev/readv helpers conditionally
  ALSA: doc: Update copy_user, copy_kernel and fill_silence PCM ops

 .../sound/kernel-api/writing-an-alsa-driver.rst    | 111 ++--
 drivers/media/pci/solo6x10/solo6x10-g723.c         |  32 +-
 drivers/usb/gadget/function/u_uac1.c               |   7 +-
 include/sound/pcm.h                                |  80 ++-
 sound/core/oss/io.c                                |   4 +-
 sound/core/oss/pcm_oss.c                           |  81 +--
 sound/core/oss/pcm_plugin.h                        |   6 +-
 sound/core/pcm_lib.c                               | 564 ++++++++-------------
 sound/drivers/dummy.c                              |  20 +-
 sound/isa/gus/gus_pcm.c                            |  97 ++--
 sound/isa/sb/emu8000_pcm.c                         | 190 ++++---
 sound/pci/es1938.c                                 |  33 +-
 sound/pci/korg1212/korg1212.c                      | 112 ++--
 sound/pci/nm256/nm256.c                            |  57 ++-
 sound/pci/rme32.c                                  |  65 ++-
 sound/pci/rme96.c                                  |  70 ++-
 sound/pci/rme9652/hdsp.c                           |  67 ++-
 sound/pci/rme9652/rme9652.c                        |  71 ++-
 sound/sh/sh_dac_audio.c                            |  54 +-
 sound/soc/blackfin/bf5xx-ac97-pcm.c                |  27 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |  36 +-
 sound/soc/soc-pcm.c                                |   5 +-
 22 files changed, 977 insertions(+), 812 deletions(-)

-- 
2.13.0
