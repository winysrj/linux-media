Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaGDRPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 00/14] Fix ISDB-T tuning issues
Date: Fri,  4 Jul 2014 14:15:26 -0300
Message-Id: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing two dvb devices:
	- Mygica S870 (dib8096 based);
	- Pixelview PV-D231U (RN-F)

I noticed several bugs:
- It doesn't lock on any layer with Interleave > 2;
- It doesn't lock in mode 2 (4 K FFT);
- ADC OFF settings is wrong, with causes wrong ADC
  adjustments and cause locking issues;
- the ADC gain table was not right;
- There are some troubles when used with CONFIG_HZ = 1000.

This patch series addresses the above bugs. While here, it also
improves some debug messages and ad a few other improvements.

For the patches that change the sleep time, I opted to be
conservative, e. g. to reproduce the worse case (e. g.
CONFIG_HZ = 100), so enforcing that the minimal state machine
delays to be 10ms. That assures that no regression will be
introduced, and that machines configured with HZ equal to
250, 300 or 1000 will work just like the ones configured with
HZ equal to 100.

Please notice that the Windows driver for Mygica S870 does a
different setup than what's there at the Linux driver. While
I have a patch changing it, I opted to remove it from this patch
series, as I didn't notice any improvements with the patch here.
Such patch is already in patchwork:
	https://patchwork.linuxtv.org/patch/24586/
and we might resurrect it latter if needed.

Mauro Carvalho Chehab (14):
  dib8000: Fix handling of interleave bigger than 2
  dib8000: Fix ADC OFF settings
  dib8000: Fix alignments at dib8000_tune()
  dib8000: Fix: add missing 4K mode
  dib8000: remove a double call for dib8000_get_symbol_duration()
  dib8000: In auto-search, try first with partial reception enabled
  dib8000: Restart sad during dib8000_reset
  dib0700: better document struct init
  dib8000: Fix the sleep time at the state machine
  dib0090: Fix the sleep time at the state machine
  dib8000: use jifies instead of current_kernel_time()
  dib8000: Update the ADC gain table
  dib8000: improve debug messages
  dib8000: improve the message that reports per-layer locks

 drivers/media/dvb-frontends/dib0090.c       |  15 +-
 drivers/media/dvb-frontends/dib8000.c       | 645 +++++++++++++++-------------
 drivers/media/usb/dvb-usb/dib0700_devices.c | 148 ++++---
 3 files changed, 436 insertions(+), 372 deletions(-)

-- 
1.9.3

