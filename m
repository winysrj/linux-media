Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:59498 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbbJTXZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 19:25:21 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v2 0/3] Add mixer and control interface media entities
Date: Tue, 20 Oct 2015 17:25:13 -0600
Message-Id: <cover.1445380851.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch v2 series adds the following:

A fix to media_stream_delete() to remove intf devnode.

Add support for creating MEDIA_ENT_F_AUDIO_MIXER entity for
each mixer and a MEDIA_INTF_T_ALSA_CONTROL control interface
entity that links to mixer entities. MEDIA_INTF_T_ALSA_CONTROL
entity corresponds to the control device for the card.

Change au0828_create_media_graph() to create pad link
between MEDIA_ENT_F_AUDIO_MIXER entity and decoder's
AU8522_PAD_AUDIO_OUT. With mixer entity now linked to
decoder, change to link MEDIA_ENT_F_AUDIO_CAPTURE to
mixer's source pad

Changes since v1:
1. Included the fix to media_stream_delete() which was by mistake
   not included in the patch v1.
2. Fixed mixer to decoder link and mider to capture node links
   based on Mauro Chehapb's review comments on the media graph.

This patch series is dependent on an earlier patch series:

Update ALSA, and au0828 drivers to use Managed Media Controller API:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg92752.html

Please find the media graphs for ALSA work with mixer and control
interface nodes:

https://drive.google.com/folderview?id=0B0NIL0BQg-AlLWE3SzAxazBJWm8&usp=sharing

Shuah Khan (3):
  sound/usb: Fix media_stream_delete() to remove intf devnode
  sound/usb: Create media mixer function and control interface entities
  media: au0828 create link between ALSA Mixer and decoder

 drivers/media/usb/au0828/au0828-core.c | 17 +++++--
 drivers/media/usb/au0828/au0828.h      |  1 +
 sound/usb/card.c                       |  5 ++
 sound/usb/media.c                      | 90 ++++++++++++++++++++++++++++++++++
 sound/usb/media.h                      | 20 ++++++++
 sound/usb/mixer.h                      |  1 +
 sound/usb/usbaudio.h                   |  1 +
 7 files changed, 132 insertions(+), 3 deletions(-)

-- 
2.1.4

