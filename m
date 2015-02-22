Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/10] siano: add media controller and use pr_foo()
Date: Sun, 22 Feb 2015 13:11:31 -0300
Message-Id: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch adds media controller support. It is a rebased
version of a previously sent patch, plus the logic to unregister
the media controller device.

The next 8 patches convert siano to pr_foo() and removes the
now obsolete sms_dbg parameter.

The last patch fixes an issue on initializing the media controller
entities that happens when the device is removed and re-inserted.

Mauro Carvalho Chehab (10):
  [media] siano: add support for the media controller at USB driver
  [media] siano: use pr_* print functions
  [media] siano: replace sms_warn() by pr_warn()
  [media] siano: replace sms_err by pr_err
  [media] siano: replace sms_log() by pr_debug()
  [media] siano: replace sms_debug() by pr_debug()
  [media] siano: get rid of sms_info()
  [media] siano: get rid of sms_dbg parameter
  [media] siano: print a message if DVB register succeeds
  [media] siano: register media controller earlier

 drivers/media/common/siano/sms-cards.c      |   8 +-
 drivers/media/common/siano/sms-cards.h      |   3 +-
 drivers/media/common/siano/smscoreapi.c     | 164 ++++++++++++++--------------
 drivers/media/common/siano/smscoreapi.h     |  32 ++----
 drivers/media/common/siano/smsdvb-debugfs.c |   2 +-
 drivers/media/common/siano/smsdvb-main.c    |  74 ++++++++-----
 drivers/media/common/siano/smsir.c          |  17 ++-
 drivers/media/mmc/siano/smssdio.c           |  12 +-
 drivers/media/usb/siano/smsusb.c            | 131 ++++++++++++++--------
 9 files changed, 239 insertions(+), 204 deletions(-)

-- 
2.1.0

