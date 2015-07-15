Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:49004 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbbGOAeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:34:18 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	crope@iki.fi, sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, dan.carpenter@oracle.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, daniel@zonque.org,
	vladcatoi@gmail.com, misterpib@gmail.com, damien@zamaudio.com,
	pmatilai@laiskiainen.org, takamichiho@gmail.com,
	normalperson@yhbt.net, bugzilla.frnkcg@spamgourmet.com,
	joe@oampo.co.uk, calcprogrammer1@gmail.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 0/7] Update ALSA, and au0828 drivers to use Managed Media Controller API 
Date: Tue, 14 Jul 2015 18:33:58 -0600
Message-Id: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s patch series updates ALSA driver, and au0828 core driver to
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

This patch series has been updated to address comments from
3 previous versions of this series. Link to v3 below for
reference.

https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89491.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg89492.html
https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89493.html

Open Issues:

ALSA has makes media_entity_pipeline_start() call in irq
path. I am seeing warnings that the graph_mutex is unsafe
irq lock. Media Controller API updates to start/stop pipeline
to be irq safe might be necessary. Maybe there are other MC
interfaces that need to be irq safe, but I haven't seen any
problems with my testing.

So as per options, graph_mutex could be changed to a spinlock.
It looks like drivers hold this lock and it isn't abstracted to
MC API. Unfortunate, this would require changes to drivers that
directly hold the lock for graph walks if this mutex is changed
to spinlock. This issue needs to be resolved.

Note: This series includes a revert to a patch that added media
controller entity framework enhancements that implemented entity
ops for entity_notify functionality. Entity ops for entity_notify
doesn't handle and cover entity create ordering variations that
could occur during boot. entity_notify list has been moved to media
device level which makes the entity_notify calls to work correctly.

Shuah Khan (7):
  Revert "[media] media: media controller entity framework enhancements
    for ALSA"
  media: Media Controller register/unregister entity_notify API
  media: Add ALSA Media Controller devnodes
  media: change dvb-frontend to honor MC tuner enable error
  media: au8522 change to create MC pad for ALSA Audio Out
  media: au0828 change to use Managed Media Controller API
  sound/usb: Update ALSA driver to use Managed Media Controller API

 drivers/media/dvb-core/dvb_frontend.c        |   5 +-
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  46 ++++-
 drivers/media/usb/au0828/au0828-core.c       | 132 ++++++++------
 drivers/media/usb/au0828/au0828.h            |   5 +
 include/media/media-device.h                 |  23 +++
 include/media/media-entity.h                 |   4 -
 include/uapi/linux/media.h                   |   5 +
 sound/usb/Makefile                           |  15 +-
 sound/usb/card.c                             |   5 +
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 260 +++++++++++++++++++++++++++
 sound/usb/media.h                            |  52 ++++++
 sound/usb/pcm.c                              |  15 +-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   9 +-
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   1 +
 20 files changed, 523 insertions(+), 75 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.1.4

