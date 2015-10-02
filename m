Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:51997 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbbJBWHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:39 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 00/20] Update ALSA, and au0828 drivers to use Managed Media Controller API
Date: Fri,  2 Oct 2015 16:07:12 -0600
Message-Id: <cover.1443822799.git.shuahkh@osg.samsung.com>
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

Please find the graphs generated using mc_nextgen_test tool at
various points during testing at:

https://drive.google.com/folderview?id=0B0NIL0BQg-Alb3JFb2diMXRoQlU&usp=sharing

This patch series is the port of the same work that was done in
the following patch series to use Media Controller Next Gen API.

Patch v3 - Media Controller API:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg92572.html

References and History:

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
Shuah Khan (20):
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

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++---------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-core/dvbdev.c              |   3 +-
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  43 ++++
 drivers/media/media-entity.c                 |  64 +++--
 drivers/media/usb/au0828/au0828-core.c       | 337 ++++++++++++++++++++-------
 drivers/media/usb/au0828/au0828-video.c      |  75 +-----
 drivers/media/usb/au0828/au0828.h            |   8 +
 drivers/media/v4l2-core/v4l2-dev.c           |  27 +++
 drivers/media/v4l2-core/v4l2-fh.c            |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c     |   3 +
 include/media/media-device.h                 |  44 ++++
 include/media/media-entity.h                 |   3 +
 include/media/v4l2-dev.h                     |   4 +
 include/uapi/linux/media.h                   |   9 +-
 sound/usb/Makefile                           |  15 +-
 sound/usb/card.c                             |   5 +
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 201 ++++++++++++++++
 sound/usb/media.h                            |  53 +++++
 sound/usb/mixer.c                            |   1 +
 sound/usb/pcm.c                              |  29 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   9 +-
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   1 +
 30 files changed, 823 insertions(+), 304 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.1.4

