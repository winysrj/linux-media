Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUSUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:14 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/8] Fix stream hangs with au0828
Date: Wed, 21 May 2014 15:19:54 -0300
Message-Id: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several conditions that make au0828 stream to hang. Those
were independently detected by me, Reynaldo and Trevor.

Trevor kindly provided a code that make this error visible: running
it ~10-15 times on a loop makes the au0828 to stop sending stream.
Once it stops, not even removing/reinserting the driver is enough to
restore its behavior. The device needs to be physically removed, or
a reset command should be sent via I2C.

On my research, this seems to be due to some hardware bug, caused
by (at least) two factors:
	- TS should be stopped before setting the frontend;
	- xc5000 cannot suspend, if userspace is in a loop of
	  open/stream/close.

This patch series address both issues.

While here, it also fixes most checkpatch issues at xc5000.

Reynaldo/Trevor,

Please test, and send your tested-by, if this fixes the issue.

Thanks,
Mauro

Changbing Xiong (1):
  [media] au0828: Cancel stream-restart operation if frontend is
    disconnected

Mauro Carvalho Chehab (7):
  [media] au0828: Improve debug messages for urb_completion
  [media] Reset au0828 streaming when a new frequency is set
  xc5000: get rid of positive error codes
  xc5000: Don't wrap msleep()
  xc5000: fix CamelCase
  xc5000: Don't use whitespace before tabs
  xc5000: delay tuner sleep to 5 seconds

 drivers/media/tuners/xc5000.c         | 302 ++++++++++++++++++----------------
 drivers/media/usb/au0828/au0828-dvb.c |  57 ++++++-
 drivers/media/usb/au0828/au0828.h     |   2 +
 3 files changed, 210 insertions(+), 151 deletions(-)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c

-- 
1.9.0

