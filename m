Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45399 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbbJVBNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 21:13:12 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] Alsa_Au0828_mc_next_gen work for
 mchehab_experimental/mc_next_gen.v8.4
Message-ID: <56283820.9@osg.samsung.com>
Date: Wed, 21 Oct 2015 19:13:04 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Could you please pull these 23 patches into the
mchehab_experimental/mc_next_gen.v8.4 to enable
easier reviews and tests on this work.

thanks,
-- Shuah

The following changes since commit 3e78030c0f16918bd095d550ecad6d06884b00dc:

  [media] media-entity.c: get rid of var length arrays (2015-10-05
12:42:17 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux.git
tags/Alsa_Au0828_mc_next_gen

for you to fetch changes up to c24b36476a8eccb0e797729bf1555d3a615bc14d:

  media: au0828 create link between ALSA Mixer and decoder (2015-10-21
18:36:52 -0600)

----------------------------------------------------------------
Alsa_Au0828_mc_next_gen

This pull request contains 23 patches to update ALSA, and au0828
drivers to use Managed Media Controller API to share resources,
and add mixer and control interface media entities.

The branch is based on mchehab_experimental/mc_next_gen.v8.4

----------------------------------------------------------------
Shuah Khan (23):
      media: Media Controller register/unregister entity_notify API
      media: Add ALSA Media Controller function entities
      media: Media Controller enable/disable source handler API
      media: Media Controller fix to not let stream_count go negative
      media: Media Controller export non locking __media_entity_setup_link()
      media: Media Controller non-locking
__media_entity_pipeline_start/stop()
      media: v4l-core add v4l_enable/disable_media_tuner() helper functions
      media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
      media: au8522 change to create MC pad for ALSA Audio Out
      media: au0828 Use au8522_media_pads enum for pad defines
      media: au0828 fix au0828_create_media_graph() entity checks
      media: Change v4l-core to check for tuner availability
      media: dvb-frontend invoke enable/disable_source handlers
      media: au0828 video remove au0828_enable_analog_tuner()
      media: au0828 video change to use v4l_enable_media_tuner()
      media: au0828 change to use Managed Media Controller API
      media: au0828 change to register/unregister entity_notify hook
      media: au0828 implement enable_source and disable_source handlers
      media: dvb-core create tuner to demod pad link in disabled state
      sound/usb: Update ALSA driver to use Managed Media Controller API
      sound/usb: Fix media_stream_delete() to remove intf devnode
      sound/usb: Create media mixer function and control interface entities
      media: au0828 create link between ALSA Mixer and decoder

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++---------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-core/dvbdev.c              |   3 +-
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  43 ++++
 drivers/media/media-entity.c                 |  64 +++--
 drivers/media/usb/au0828/au0828-core.c       | 348
++++++++++++++++++++-------
 drivers/media/usb/au0828/au0828-video.c      |  75 +-----
 drivers/media/usb/au0828/au0828.h            |   9 +
 drivers/media/v4l2-core/v4l2-dev.c           |  27 +++
 drivers/media/v4l2-core/v4l2-fh.c            |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c     |   3 +
 include/media/media-device.h                 |  44 ++++
 include/media/media-entity.h                 |   3 +
 include/media/v4l2-dev.h                     |   4 +
 include/uapi/linux/media.h                   |   9 +-
 sound/usb/Makefile                           |  15 +-
 sound/usb/card.c                             |  10 +
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 291 ++++++++++++++++++++++
 sound/usb/media.h                            |  73 ++++++
 sound/usb/mixer.c                            |   1 +
 sound/usb/mixer.h                            |   1 +
 sound/usb/pcm.c                              |  29 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   9 +-
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   2 +
 31 files changed, 952 insertions(+), 304 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
