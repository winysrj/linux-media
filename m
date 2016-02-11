Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35550 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbcBKXlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:41:46 -0500
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
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 00/22] Sharing media resources across ALSA and au0828 drivers
Date: Thu, 11 Feb 2016 16:41:16 -0700
Message-Id: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates ALSA driver, and au0828 core
driver to use Managed Media controller API and Media
Controller API to share media resource (tuner).

This Patch v3 series is based on linux_media master.
This work addresses Mauro and Takashi's comments on
Patch v2 series.

Changes since Patch v2 series:
- Added documentation for uapi and new MC interfaces
  1. Ran make for documentation and Mauro's doc script.
     Thanks for sharing the script.
- Updated commit logs as needed for clarity.
- media: v4l-core add enable/disable source common interfaces
  Addressed comments - added static inlines in header file
- media: dvb-frontend invoke enable/disable_source handlers
  Moved the patch after enable/disable handlers and left
  pipe in dvb_frontend_private
- media: au0828 video remove au0828_enable_analog_tuner() and
  media: au0828 video change to use v4l_enable_media_source()
  1. Collapsed these two patches - it doesn't make sense to keep
     them separate. Also added FIXME as per Mauro's suggestion.
- media: au0828 change to use Managed Media Controller API
  1. Added comment explaining the need for using udev->product
     instead of dev->board.name
- media: au0828 add enable, disable source handlers
  1. Changed to handle S-Video and Composite inputs.
  2. Fixed a bug that lets Video in when ALSA holds the
     source.
  3. Added comments to one FIXME for s_input changes.
     Fix is in progress and will send it in a day or two
     combined with other issues found in au0828 video in
     the way it handles input. Doesn't impact this routine,
     changes are all in au0828-video.
- sound/usb: Use Media Controller API to share media resources
  1. Addressed comments from Mauro and Takashi about void pointer
     use.
  2. Fixed kbuildbot error when MEDIA_SUPPORT=m
- Dropped media: Ensure media device unregister is done only once
  Device removal worked without any changes to media unregister
  path. This work isn't necessary.

Shuah Khan (22):
  [media] Docbook: media-types.xml: Add ALSA Media Controller Intf types
  uapi/media.h: Declare interface types for ALSA
  [media] Docbook: media-types.xml: Add Audio Function Entities
  media: Add ALSA Media Controller function entities
  media: Media Controller register/unregister entity_notify API
  media: Media Controller enable/disable source handler API
  media: Media Controller export non locking __media_entity_setup_link()
  edia: Media Controller non-locking
    __media_entity_pipeline_start/stop()
  media: v4l-core add enable/disable source common interfaces
  media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
  media: au8522 change to create MC pad for ALSA Audio Out
  media: au0828 Use au8522_media_pads enum for pad defines
  media: Change v4l-core to check if source is free
  media: au0828 change to use Managed Media Controller API
  media: au0828 handle media_init and media_register window
  media: au0828 create tuner to decoder link in disabled state
  media: au0828 disable tuner to demod link
  media: au0828-core register entity_notify hook
  media: au0828 add enable, disable source handlers
  media: dvb-frontend invoke enable/disable_source handlers
  media: au0828 video change to use v4l_enable_media_source()
  sound/usb: Use Media Controller API to share media resources

 Documentation/DocBook/media/v4l/media-types.xml |  52 ++++
 drivers/media/dvb-core/dvb_frontend.c           | 135 ++--------
 drivers/media/dvb-frontends/au8522.h            |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c    |   1 +
 drivers/media/dvb-frontends/au8522_priv.h       |   8 -
 drivers/media/media-device.c                    |  42 +++
 drivers/media/media-entity.c                    |  51 +++-
 drivers/media/usb/au0828/au0828-core.c          | 325 ++++++++++++++++++++++--
 drivers/media/usb/au0828/au0828-video.c         | 102 +++-----
 drivers/media/usb/au0828/au0828.h               |   6 +
 drivers/media/v4l2-core/Makefile                |   1 +
 drivers/media/v4l2-core/v4l2-fh.c               |   2 +
 drivers/media/v4l2-core/v4l2-ioctl.c            |  30 +++
 drivers/media/v4l2-core/v4l2-mc.c               |  52 ++++
 drivers/media/v4l2-core/videobuf2-core.c        |   4 +
 include/media/media-device.h                    |  86 +++++++
 include/media/media-entity.h                    |  19 ++
 include/media/v4l2-dev.h                        |   1 +
 include/media/v4l2-mc.h                         |  65 +++++
 include/uapi/linux/media.h                      |  17 ++
 sound/usb/Kconfig                               |   4 +
 sound/usb/Makefile                              |   2 +
 sound/usb/card.c                                |  14 +
 sound/usb/card.h                                |   3 +
 sound/usb/media.c                               | 318 +++++++++++++++++++++++
 sound/usb/media.h                               |  72 ++++++
 sound/usb/mixer.h                               |   3 +
 sound/usb/pcm.c                                 |  28 +-
 sound/usb/quirks-table.h                        |   1 +
 sound/usb/stream.c                              |   2 +
 sound/usb/usbaudio.h                            |   6 +
 31 files changed, 1240 insertions(+), 220 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0

