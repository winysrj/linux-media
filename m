Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:40139 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbcAUSJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 13:09:55 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-api@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH REBASE 4.5 00/31] Sharing media resources across ALSA and au0828 drivers 
Date: Thu, 21 Jan 2016 11:09:46 -0700
Message-Id: <cover.1453336830.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please note that I am sending just the 4 patches that
changed during series rebase to Linux 4.5. The rebase
was pain free. media_device_init() type change required
changes to patches 18 and 26. I re-tested the series
and everything looks good.

[PATCH 16/31] media: au0828 video remove au0828_enable_analog_tuner()
[PATCH 18/31] media: au0828 change to use Managed Media Controller API
[PATCH 22/31] media: dvb-core create tuner to demod pad link in disabled state
[PATCH v3 26/31] sound/usb: Update ALSA driver to use Managed Media Controller API

Links:
PATCH Series that contains all 31 patches:
https://lkml.org/lkml/2016/1/6/668

ALSA patches went through reviews and links
to PATCH V3 (ALSA):
https://lkml.org/lkml/2016/1/18/556
https://lkml.org/lkml/2016/1/18/557
https://lkml.org/lkml/2016/1/18/558

Compile warns patches:
https://lkml.org/lkml/2016/1/19/520
https://lkml.org/lkml/2016/1/19/518
https://lkml.org/lkml/2016/1/19/519

Mauro and Takashi:
Please let me know if you would rather see the entire
patch series generated for 4.5-rc1 and sent out in a
complete series instead of just the rebased patches.

Mauro Carvalho Chehab (1):
  uapi/media.h: Declare interface types for ALSA

Shuah Khan (30):
  media: Add ALSA Media Controller function entities
  media: Media Controller register/unregister entity_notify API
  media: Media Controller enable/disable source handler API
  media: Media Controller fix to not let stream_count go negative
  media: Media Controller export non locking __media_entity_setup_link()
  media: Media Controller non-locking
    __media_entity_pipeline_start/stop()
  media: v4l-core add v4l_enable/disable_media_tuner() helper functions
  media: v4l2-core add v4l_vb2q_enable_media_tuner() helper
  media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
  media: au8522 change to create MC pad for ALSA Audio Out
  media: au0828 Use au8522_media_pads enum for pad defines
  media: au0828 fix au0828_create_media_graph() entity checks
  media: Change v4l-core to check for tuner availability
  media: dvb-frontend invoke enable/disable_source handlers
  media: au0828 video remove au0828_enable_analog_tuner()
  media: au0828 video change to use v4l_enable_media_tuner()
  media: au0828 change to use Managed Media Controller API
  media: au0828 handle media_init and media_register window
  media: au0828 change to register/unregister entity_notify hook
  media: au0828 create tuner to decoder link in deactivated state
  media: dvb-core create tuner to demod pad link in disabled state
  media: au0828 implement enable_source and disable_source handlers
  media: au0828 fix null pointer reference in
    au0828_create_media_graph()
  media: au0828 fix to not call media_device_unregister_entity_notify()
  sound/usb: Update ALSA driver to use Managed Media Controller API
  sound/usb: Create media mixer function and control interface entities
  media: au0828 create link between ALSA Mixer and decoder
  media: track media device unregister in progress
  sound/usb: Check media device unregister progress state
  media: au0828 change to check media device unregister progress state

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++---------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-core/dvbdev.c              |   4 +-
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  66 +++++-
 drivers/media/media-entity.c                 |  65 +++--
 drivers/media/usb/au0828/au0828-core.c       | 340 +++++++++++++++++++++++----
 drivers/media/usb/au0828/au0828-video.c      |  75 +-----
 drivers/media/usb/au0828/au0828.h            |   9 +
 drivers/media/v4l2-core/v4l2-dev.c           |  48 ++++
 drivers/media/v4l2-core/v4l2-fh.c            |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c     |   4 +
 include/media/media-device.h                 |  61 +++++
 include/media/media-entity.h                 |  12 +
 include/media/v4l2-dev.h                     |   5 +
 include/uapi/linux/media.h                   |  17 +-
 sound/usb/Kconfig                            |   4 +
 sound/usb/Makefile                           |   2 +
 sound/usb/card.c                             |  16 ++
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 299 +++++++++++++++++++++++
 sound/usb/media.h                            |  76 ++++++
 sound/usb/mixer.h                            |   1 +
 sound/usb/pcm.c                              |  28 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   5 +
 sound/usb/stream.c                           |   1 +
 sound/usb/usbaudio.h                         |   2 +
 31 files changed, 1070 insertions(+), 261 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0

