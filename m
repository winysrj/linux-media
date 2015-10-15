Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:48610 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbbJOUu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 16:50:58 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 0/2] Add mixer and control interface media entities
Date: Thu, 15 Oct 2015 14:50:51 -0600
Message-Id: <cover.1444941680.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the following:

Add support for creating MEDIA_ENT_F_AUDIO_MIXER entity for
each mixer and a MEDIA_INTF_T_ALSA_CONTROL control interface
entity that links to mixer entities. MEDIA_INTF_T_ALSA_CONTROL
entity corresponds to the control device for the card.

Change au0828_create_media_graph() to create pad link between
MEDIA_ENT_F_AUDIO_MIXER entity and decoder's AU8522_PAD_AUDIO_OUT.

This patch series is dependent on an earlier patch series:

Update ALSA, and au0828 drivers to use Managed Media Controller API:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg92752.html

Please find the media graph with mixer and control interface nodes:
https://drive.google.com/folderview?id=0B0NIL0BQg-Alb3JFb2diMXRoQlU&usp=sharing
New file:
graph_mixer.png

Shuah Khan (2):
  sound/usb: Create media mixer function and control interface entities
  media: au0828 create link between ALSA Mixer and decoder

 drivers/media/usb/au0828/au0828-core.c | 12 +++++
 drivers/media/usb/au0828/au0828.h      |  1 +
 sound/usb/card.c                       |  5 ++
 sound/usb/media.c                      | 85 ++++++++++++++++++++++++++++++++++
 sound/usb/media.h                      |  4 ++
 sound/usb/mixer.h                      |  1 +
 sound/usb/usbaudio.h                   |  1 +
 7 files changed, 109 insertions(+)

-- 
2.1.4

