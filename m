Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbcCWT1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 15:27:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 0/4]  Some fixes and cleanups for the Media Controller code
Date: Wed, 23 Mar 2016 16:27:42 -0300
Message-Id: <cover.1458760750.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first three patches in this series are simple cleanup patches.
No functional changes.

The final patch fixes a longstanding bug at the Media Controller framework:
it prevents race conditions when the /dev/media? device is being removed,
while some program is still accessing it.

I tested it with au0828 and snd-usb-audio and the issues I was noticing 
before it disappeared.

Shuah,

Could you please test it also?

Thanks!
Mauro

Mauro Carvalho Chehab (4):
  [media] media-device: Simplify compat32 logic
  [media] media-devnode: fix namespace mess
  [media] media-device: get rid of a leftover comment
  [meida] media-device: dynamically allocate struct media_devnode

 drivers/media/media-device.c           |  47 ++++++++------
 drivers/media/media-devnode.c          | 115 +++++++++++++++++----------------
 drivers/media/usb/au0828/au0828-core.c |   4 +-
 drivers/media/usb/uvc/uvc_driver.c     |   2 +-
 include/media/media-device.h           |   5 +-
 include/media/media-devnode.h          |  27 +++++---
 sound/usb/media.c                      |   8 +--
 7 files changed, 113 insertions(+), 95 deletions(-)

-- 
2.5.5

