Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaHJCOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 22:14:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Another series of PM fixes for au0828
Date: Sat,  9 Aug 2014 23:14:19 -0300
Message-Id: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are still a few bugs that can happen when suspending and
a video stream is active. This patch series fix them. After
that, resume works fine, even it suspend happened while
streaming.

There is one remaining issue though: xc5000 firmware doesn't
load after resume.

What happens (on both analog and digital) is:

[  143.071323] xc5000: xc5000_suspend()
[  143.071324] xc5000: xc5000_tuner_reset()
[  143.099992] au0828: Suspend
[  143.099992] au0828: Stopping RC
[  143.101694] au0828: stopping V4L2
[  143.101695] au0828: stopping V4L2 active URBs
[  144.988637] au0828: Resume
[  145.342026] au0828: Restarting RC
[  145.343296] au0828: restarting V4L2
[  145.464413] xc5000: xc5000_is_firmware_loaded() returns True id = 0xffff
[  145.464414] xc5000: xc_set_signal_source(1) Source = CABLE
[  146.370861] xc5000: xc_set_signal_source(1) failed

I suspect that it has to do with a wrong value for the I2C
gateway. The proper fix is likely to convert au0828 to use
the I2C mux support, and remove the old i2c_gate_ctrl
approach. However, such patch would require more work, to
avoid breaking other drivers.

Mauro Carvalho Chehab (3):
  au0828: fix checks if dvb is initialized
  au0828: Fix DVB resume when streaming
  xc5000: be sure that the firmware is there before set params

 drivers/media/tuners/xc5000.c         | 10 +++++-----
 drivers/media/usb/au0828/au0828-dvb.c | 24 ++++++++++++++----------
 drivers/media/usb/au0828/au0828.h     |  4 ++--
 3 files changed, 21 insertions(+), 17 deletions(-)

-- 
1.9.3

