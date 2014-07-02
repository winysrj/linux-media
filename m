Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaGBPwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 0/9] Some dib8000 fixes
Date: Wed,  2 Jul 2014 12:52:14 -0300
Message-Id: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix some issues with dib8000 driver.

Without them, the signal reception was poor with Mygica S870.

The patches were tested with both PixelView PV-D231(U)(RN)
(dib8076 based) and Mygica S870 (dib8096 based).

Mauro Carvalho Chehab (9):
  dib0700: better document struct init
  dib8000: Fix ADC OFF settings
  dib8000: Fix alignments at dib8000_tune()
  dib8000: remove a double call for dib8000_get_symbol_duration()
  dib8000: Adjust the dBm measure for Mygica S870
  dib8000: Restart sad during dib8000_reset
  dib8000: Fix the sleep time at the state machine
  dib0700: Optimize the AGC settings for dib8096gp
  dib8000: use jifies instead of current_kernel_time()

 drivers/media/dvb-frontends/dib8000.c        | 541 ++++++++++++++-------------
 drivers/media/dvb-frontends/dibx000_common.h |   2 +
 drivers/media/usb/dvb-usb/dib0700_devices.c  | 152 ++++----
 3 files changed, 359 insertions(+), 336 deletions(-)

-- 
1.9.3

