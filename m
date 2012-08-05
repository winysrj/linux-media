Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab2HESQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 14:16:34 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75IGYos022145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 14:16:34 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] get rid of fe_ioctl_override()
Date: Sun,  5 Aug 2012 15:16:28 -0300
Message-Id: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's just one driver using fe_ioctl_override(), and it can be
replaced at tuner_attach call. This callback is evil, as only DVBv3
calls are handled.

Removing it is also a nice cleanup, as about 90 lines of code are
removed.

Get rid of it!

Mauro Carvalho Chehab (2):
  [media] dvb core: remove support for post FE legacy ioctl intercept
  [media] dvb: get rid of fe_ioctl_override callback

 drivers/media/dvb/dvb-core/dvb_frontend.c   | 20 +----------------
 drivers/media/dvb/dvb-core/dvbdev.h         | 26 ----------------------
 drivers/media/dvb/dvb-usb-v2/dvb_usb.h      |  3 ---
 drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c |  2 --
 drivers/media/dvb/dvb-usb-v2/mxl111sf.c     | 34 +----------------------------
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |  1 -
 drivers/media/dvb/dvb-usb/dvb-usb.h         |  2 --
 drivers/media/video/cx23885/cx23885-dvb.c   |  3 +--
 drivers/media/video/cx88/cx88-dvb.c         |  2 +-
 drivers/media/video/saa7134/saa7134-dvb.c   |  2 +-
 drivers/media/video/videobuf-dvb.c          | 11 +++-------
 include/media/videobuf-dvb.h                |  4 +---
 12 files changed, 9 insertions(+), 101 deletions(-)

-- 
1.7.11.2

