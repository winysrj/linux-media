Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:53271 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758366AbbIVR17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:27:59 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 00/21] Update ALSA, and au0828 drivers to use Managed Media Controller API
Date: Tue, 22 Sep 2015 11:19:19 -0600
Message-Id: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates ALSA driver, and au0828 core driver to
use Managed Media controller API to share tuner. Please note that
Managed Media Controller API and DVB and V4L2 drivers updates to
use Media Controller API have been added in a prior patch series.

Media Controller API is enhanced with two new interfaces to
register and unregister entity_notify hooks to allow drivers
to take appropriate actions when as new entities get added to
the shared media device.

Tested exclusion between digital, analog, and audio to ensure
when tuner has an active link to DVB FE, analog, and audio will
detect and honor the tuner busy conditions and vice versa.

Changes since v2:
http://www.spinics.net/lists/linux-media/msg91926.html

1. An important change in this patch series is made to ALSA
   to check for resources and hold in snd_usb_hw_params(),
   and release from snd_usb_hw_free(). This change fixed the
   lockdep warnings seen when resources were held in
   TRIGGER_START and released from TRIGGER_STOP which could
   run in IRQ context. I acknowledge Clemens Ladisch for
   suggesting the correct places to hold/free resources to
   avoid IRQ path complications.
2. With the above change, the patch series is simpler without
   the need to change the graph_mutex into a spinlock.
3. I split the patches up differently for easy reviews - no code
   bloat from v2.
4. A second important change is now the Bridge driver (au0828)
   owns and drives the graph creation as well as enabling and
   disabling tuner. It also keeps state information to avoid
   graph walks in enable_source and disable_source handler.
   I acknowledge Hans Verkuil for his suggestions and ideas
   for this change.

History:
This patch series has been updated to address comments from
3 previous versions of this series. Links to v3 version
for reference are:

https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89491.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg89492.html
https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89493.html

Shuah Khan (21):
  Revert "[media] media: media controller entity framework enhancements
    for ALSA"
  media: Media Controller register/unregister entity_notify API
  media: Add ALSA Media Controller devnodes
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
  media: media: dvb-frontend fix enable_source error legs
  sound/usb: Update ALSA driver to use Managed Media Controller API

 drivers/media/dvb-core/dvb_frontend.c        | 142 ++-----------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  46 +++-
 drivers/media/media-entity.c                 |  64 ++++--
 drivers/media/usb/au0828/au0828-core.c       | 305 ++++++++++++++++++++++-----
 drivers/media/usb/au0828/au0828-video.c      |  76 ++-----
 drivers/media/usb/au0828/au0828.h            |   8 +
 drivers/media/v4l2-core/v4l2-dev.c           |  27 +++
 drivers/media/v4l2-core/v4l2-fh.c            |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c     |   3 +
 include/media/media-device.h                 |  41 ++++
 include/media/media-entity.h                 |   7 +-
 include/media/v4l2-dev.h                     |   4 +
 include/uapi/linux/media.h                   |   5 +
 sound/usb/Makefile                           |  15 +-
 sound/usb/card.c                             |   5 +
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 178 ++++++++++++++++
 sound/usb/media.h                            |  51 +++++
 sound/usb/pcm.c                              |  29 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   9 +-
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   1 +
 28 files changed, 790 insertions(+), 280 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.1.4

