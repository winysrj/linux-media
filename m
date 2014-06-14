Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbaFNQRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 12:17:38 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Auvitek au0828 fixups
Date: Sat, 14 Jun 2014 13:16:08 -0300
Message-Id: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testing auvitek au0828-based devices with xawtv caused lots of overruns,
as the period_bytes is set to a too low value, with causes troubles
when syncing the audio capture from au0828 card with the audio playback,
at the main audio card.

It turns that we need a period_bytes size that it is big enough to receive
data from two consecutive URB intervals.

While here, also add the missing USB IDs from other au0828-based devices.

Mauro Carvalho Chehab (3):
  sound: Add a quirk to enforce period_bytes
  sound: simplify au0828 quirk table
  sound: Update au0828 quirks table

 sound/usb/card.h         |   1 +
 sound/usb/pcm.c          |  34 ++++++++++
 sound/usb/quirks-table.h | 167 ++++++++++++-----------------------------------
 sound/usb/quirks.c       |  14 ++--
 sound/usb/stream.c       |   1 +
 sound/usb/usbaudio.h     |   3 +-
 6 files changed, 88 insertions(+), 132 deletions(-)

-- 
1.9.3

