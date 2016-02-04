Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:42802 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604AbcBDEEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 23:04:02 -0500
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
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v2 00/22] Sharing media resources across ALSA and au0828 drivers
Date: Wed,  3 Feb 2016 21:03:32 -0700
Message-Id: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates ALSA driver, and au0828 core
driver to use Managed Media controller API and Media
Controller API to share media resource (tuner).

This Patch v2 series is based on linux_media master.
This work addresses Mauro and Takashi's comments.

Composite or S-Video connector is the input case
is still under discussion and isn't addressed in
this series.

Patches 3 and 4 need documentation updates and will
be sent later this week.

Shuah Khan (22):
  uapi/media.h: Declare interface types for ALSA
  media: Add ALSA Media Controller function entities
  media: Media Controller register/unregister entity_notify API
  media: Media Controller enable/disable source handler API
  media: Media Controller export non locking __media_entity_setup_link()
  media: Media Controller non-locking
    __media_entity_pipeline_start/stop()
  media: v4l-core add enable/disable source common interfaces
  media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
  media: au8522 change to create MC pad for ALSA Audio Out
  media: Change v4l-core to check if source is free
  media: dvb-frontend invoke enable/disable_source handlers
  media: au0828 video remove au0828_enable_analog_tuner()
  media: au0828 video change to use v4l_enable_media_source()
  media: au0828 change to use Managed Media Controller API
  media: au0828 handle media_init and media_register window
  media: au0828 create tuner to decoder link in disabled state
  media: au0828 disable tuner to demod link
  media: au0828 Use au8522_media_pads enum for pad defines
  media: au0828-core register entity_notify hook
  media: au0828 add enable, disable source handlers
  sound/usb: Use Media Controller API to share media resources
  media: Ensure media device unregister is done only once

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++----------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  73 +++++-
 drivers/media/media-devnode.c                |  15 +-
 drivers/media/media-entity.c                 |  51 ++++-
 drivers/media/usb/au0828/au0828-core.c       | 272 +++++++++++++++++++++--
 drivers/media/usb/au0828/au0828-video.c      |  75 +------
 drivers/media/usb/au0828/au0828.h            |   4 +
 drivers/media/v4l2-core/Makefile             |   2 +-
 drivers/media/v4l2-core/v4l2-fh.c            |   2 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  30 +++
 drivers/media/v4l2-core/v4l2-mc.c            |  60 +++++
 drivers/media/v4l2-core/videobuf2-core.c     |   4 +
 include/media/media-device.h                 |  44 ++++
 include/media/media-devnode.h                |  17 ++
 include/media/media-entity.h                 |  12 +
 include/media/v4l2-dev.h                     |   1 +
 include/media/v4l2-mc.h                      |  52 +++++
 include/uapi/linux/media.h                   |  33 +++
 sound/usb/Kconfig                            |   4 +
 sound/usb/Makefile                           |   2 +
 sound/usb/card.c                             |  14 ++
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 319 +++++++++++++++++++++++++++
 sound/usb/media.h                            |  72 ++++++
 sound/usb/mixer.h                            |   1 +
 sound/usb/pcm.c                              |  28 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   3 +
 33 files changed, 1117 insertions(+), 236 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0

