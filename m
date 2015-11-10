Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:52301 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbbKJUq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 15:46:56 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v3 0/6] Add mixer and control interface media entities
Date: Tue, 10 Nov 2015 13:40:43 -0700
Message-Id: <cover.1447183999.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch v3 series adds the following:

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

In addition, this patch series consists of fixes to compile
warnings found by kbuild bot, and an additional fix in media
stream cleanup path.

Changes since v2:

1. Addressed Takashi's comments on the following ALSA patch:
   sound/usb: Create media mixer function and control interface
   entities
2. Include patches to fix compile warnings found by kbuild bot,
   and an additional fix in media stream cleanup path.
3. No changes to patches 1 and 3.
4. Changed patches: 2
5. New patches: 4,5, and 6

Changes since v1:
1. Included the fix to media_stream_delete() which was by mistake
   not included in the patch v1.
2. Fixed mixer to decoder link and mixer to capture node links
   based on Mauro Chehab's review comments on the media graph.

This patch series is dependent on an earlier patch series-es:

Patch series v2:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg93084.html

Patch series v1:
Update ALSA, and au0828 drivers to use Managed Media Controller API:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg92752.html

Please find the media graphs for ALSA work with mixer and control
interface nodes: (these are generated using mc_next_gen_test tool.

https://drive.google.com/folderview?id=0B0NIL0BQg-AlLWE3SzAxazBJWm8&usp=sharing

v4l2-utils patch adds mixer node support mc_next_gen_test tool:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg93086.html

Shuah Khan (6):
  sound/usb: Fix media_stream_delete() to remove intf devnode
  sound/usb: Create media mixer function and control interface entities
  media: au0828 create link between ALSA Mixer and decoder
  sound/usb: Fix media_stream_init() and media_stream_delete() error
    paths
  media: Fix compile warning when CONFIG_MEDIA_CONTROLLER_DVB is
    disabled
  media: au0828-core fix ignoring return value errors

 drivers/media/dvb-core/dvb_frontend.c  |   2 +-
 drivers/media/usb/au0828/au0828-core.c |  38 +++++++++---
 drivers/media/usb/au0828/au0828.h      |   1 +
 sound/usb/card.c                       |   5 ++
 sound/usb/media.c                      | 102 ++++++++++++++++++++++++++++++++-
 sound/usb/media.h                      |  20 +++++++
 sound/usb/mixer.h                      |   1 +
 sound/usb/usbaudio.h                   |   1 +
 8 files changed, 158 insertions(+), 12 deletions(-)

-- 
2.5.0

