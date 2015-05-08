Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:41975 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbbEHTbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 15:31:38 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, vladcatoi@gmail.com,
	damien@zamaudio.com, chris.j.arges@canonical.com,
	takamichiho@gmail.com, misterpib@gmail.com, daniel@zonque.org,
	pmatilai@laiskiainen.org, jussi@sonarnerd.net,
	normalperson@yhbt.net, fisch602@gmail.com, joe@oampo.co.uk
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 0/2] Update ALSA driver to use media controller API
Date: Fri,  8 May 2015 13:31:29 -0600
Message-Id: <cover.1431110739.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates ALSA driver to use media controller
API to share tuner with DVB and V4L2 drivers that control AU0828
media device. Two new interfaces are added to media controller
API to enable creating media device as a device resource. This
allows creating media device as a device resource on the main
struct device that is common to all drivers that control a single
media hardware and share resources on it. Drivers then can find
the common media device to register entities and manage links,
and pipelines.

Tested with and without CONFIG_MEDIA_CONTROLLER enabled.
Tested tuner entity doesn't exist case as au0828 v4l2
driver is the one that will create the tuner when it gets
updated to use media controller API.

Please note that au0828 updates media controller are necessary
before the resource sharing can work across ALSA and au0828
dvb and v4l2 drivers. This work is in progress and another
developer is working on it.

Shuah Khan (2):
  media: new media controller API for device resource support
  sound/usb: Update ALSA driver to use media controller API

 drivers/media/media-device.c | 33 +++++++++++++++++++++++++
 include/media/media-device.h |  2 ++
 sound/usb/card.c             |  5 ++++
 sound/usb/card.h             | 12 +++++++++
 sound/usb/pcm.c              | 23 +++++++++++++++++-
 sound/usb/quirks-table.h     |  1 +
 sound/usb/quirks.c           | 58 +++++++++++++++++++++++++++++++++++++++++++-
 sound/usb/quirks.h           |  6 +++++
 sound/usb/stream.c           | 40 ++++++++++++++++++++++++++++++
 sound/usb/usbaudio.h         |  1 +
 10 files changed, 179 insertions(+), 2 deletions(-)

-- 
2.1.4

