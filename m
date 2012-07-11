Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:22669 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GKODG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 10:03:06 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M70005DU1OU3ZJ0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Jul 2012 23:03:05 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7000LFC1OYVM10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Jul 2012 23:03:04 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl, mchehab@infradead.org,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v1 0/2] Add new fourcc definitions and H264 codec controls
Date: Wed, 11 Jul 2012 19:47:08 +0530
Message-id: <1342016230-14278-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set adds new control and fourcc definitions which will be
used by samsung s5p-mfc driver.
Patch 1 adds new fourcc definitions for YCbCr and compressed formats.
Patch 2 adds control definitions for new H264 encoder features.
The review comments given in [1] are addressed.

[1] http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/45197

Jeongtae Park (2):
  [media] v4l: Add fourcc definitions for new formats
  [media] v4l: Add control definitions for new H264 encoder features

 Documentation/DocBook/media/v4l/controls.xml     |  268 +++++++++++++++++++++-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml |   17 +-
 Documentation/DocBook/media/v4l/pixfmt.xml       |   10 +
 drivers/media/video/v4l2-ctrls.c                 |   42 ++++
 include/linux/videodev2.h                        |   45 ++++
 5 files changed, 376 insertions(+), 6 deletions(-)

