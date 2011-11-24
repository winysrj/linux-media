Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57170 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1KXKx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 05:53:26 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV500EKGVL0EU@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 10:53:24 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV500AJRVKZWL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 10:53:24 +0000 (GMT)
Date: Thu, 24 Nov 2011 11:53:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC] Add V4L2_CID_COLOR_ALPHA control for global color alpha
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com
Message-id: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This changeset adds new V4L2_CID_COLOR_ALPHA control that allows to configure 
per image plane color alpha value on the capture queue buffers.

There was a short discussion in the past about the global alpha control
support started by Jonghun Han:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg27128.html

The second patch adds the control to s5p-fimc video capture and mem-to-mem
driver.


Sylwester Nawrocki (2):
  v4l: Add a global color alpha control
  s5p-fimc: Add support for global color alpha configuration

 Documentation/DocBook/media/v4l/controls.xml       |   20 +++++--
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 ++-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    4 ++
 drivers/media/video/s5p-fimc/fimc-core.c           |   49 ++++++++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.h           |   13 ++++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 +++++++++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 ++
 drivers/media/video/v4l2-ctrls.c                   |    7 +++
 include/linux/videodev2.h                          |    6 +-
 9 files changed, 134 insertions(+), 30 deletions(-)


-- 
Regards,
 
Sylwester Nawrocki 
Samsung Poland R&D Center
