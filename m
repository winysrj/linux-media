Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/8] au0828: fix analog streaming and add PAL-M support
Date: Sun,  8 Jun 2014 13:54:50 -0300
Message-Id: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch series fixes a very nasty bug on au0828: if usb_set_interface
is called more than once to set alternate 5, the URBs are shutdown.
This is likely due to a hardware bug.

It also adds support for PAL-M. So, now, both NTSC-M and PAL-M are
working (both tested).

It also does a few cleanups.

After the patches, both xawtv and qv4l2 are working fine, with
either PAL-M or NTSC-M.

I may eventually add support for PAL-BG when I have some spare time.

PS.: At least here, there's still an unrelated issue with xawtv:
it keeps suffering from underrun errors. Fixing it would likely
require to add some quirks at usb-snd-audio, for it to select
a better latency interval.

Mauro Carvalho Chehab (8):
  au8522: move input_mode out one level
  au8522: be sure that the setup will happen at streamon time
  au8522: be sure that we'll setup audio routing at the right time
  au8522: cleanup s-video settings at setup_decoder_defaults()
  au8522: Fix demod analog mode setting
  au0828/au8522: Add PAL-M support
  au0828: Only alt setting logic when needed
  au0828: don't hardcode height/width

 drivers/media/dvb-frontends/au8522_decoder.c | 180 ++++++++++++++++++---------
 drivers/media/dvb-frontends/au8522_priv.h    |   2 +
 drivers/media/usb/au0828/au0828-video.c      |  60 +++++----
 3 files changed, 157 insertions(+), 85 deletions(-)

-- 
1.9.3

