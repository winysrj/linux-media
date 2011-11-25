Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35856 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KYPji (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 10:39:38 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV800D2Y3I0I880@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Nov 2011 15:39:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV800C0V3I0Z3@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Nov 2011 15:39:36 +0000 (GMT)
Date: Fri, 25 Nov 2011 16:39:30 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v2] Add new V4L2_CID_ALPHA_COMPONENT control
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com
Message-id: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This changeset adds new V4L2_CID_ALPHA_COMPONENT control that allows to configure 
an alpha component of all pixels on the video capture device or on capture queue 
of a mem-to-mem device. This is meant for devices that allow to set a per-pixel
alpha at the pipeline output to a desired value and where the input alpha component 
doesn't influence the output alpha value.

The second patch adds the control to s5p-fimc video capture and mem-to-mem driver.

This changset also does a minor cleanup at the user controls DocBook chapter.

Changes since v2:
 - rename V4L2_CID_COLOR_ALPHA to V4L2_CID_ALPHA_COMPONENT,
 - the documentation improvements.


Sylwester Nawrocki (2):
  v4l: Add new alpha component control
  s5p-fimc: Add support for alpha component configuration

 Documentation/DocBook/media/v4l/compat.xml         |   11 ++++
 Documentation/DocBook/media/v4l/controls.xml       |   25 +++++++--
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 ++-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    4 ++
 drivers/media/video/s5p-fimc/fimc-core.c           |   49 ++++++++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.h           |   13 ++++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 +++++++++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 ++
 drivers/media/video/v4l2-ctrls.c                   |    7 +++
 include/linux/videodev2.h                          |    6 +-
 10 files changed, 150 insertions(+), 30 deletions(-)

-- 
Regards,
 
Sylwester Nawrocki 
Samsung Poland R&D Center
