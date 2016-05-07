Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbcEGPO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 11:14:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/2] Prepare for cdev fixes
Date: Sat,  7 May 2016 12:12:07 -0300
Message-Id: <cover.1462633500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two patches are needed by Shuah's patch that fix use-after free troubles: 
	https://patchwork.linuxtv.org/patch/34201/

Those two patches were already sent  back on March, 23 but specially the second
patch  would need more review.

So, resend it, in order to get some acks. My plan is to test them together with Shuah's
patch on this Monday, and apply them as soon as possible, for the Kernel 4.7 merge
window. Those patches should be c/c to stable, in order to fix for older Kernels.

Mauro Carvalho Chehab (2):
  [media] media-devnode: fix namespace mess
  [media] media-device: dynamically allocate struct media_devnode

 drivers/media/media-device.c           |  44 +++++++++----
 drivers/media/media-devnode.c          | 115 +++++++++++++++++----------------
 drivers/media/usb/au0828/au0828-core.c |   4 +-
 drivers/media/usb/uvc/uvc_driver.c     |   2 +-
 include/media/media-device.h           |   5 +-
 include/media/media-devnode.h          |  27 +++++---
 6 files changed, 113 insertions(+), 84 deletions(-)

-- 
2.5.5


