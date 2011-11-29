Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47401 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1K2Rzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 12:55:33 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVF000TJOGJFO@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVF00AQGOGIBV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Date: Tue, 29 Nov 2011 18:55:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3] Add new V4L2_CID_ALPHA_COMPONENT control
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com
Message-id: <1322589327-4415-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
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
  - removed limitation of maximum value for the V4L2_CID_ALPHA_COMPONENT control 
    to 0xff in v4l core
  - the driver now uses function v4l2_ctrl_update_range() for the control range 
    update according to selected colour format

Changes since v1:
 - rename V4L2_CID_COLOR_ALPHA to V4L2_CID_ALPHA_COMPONENT,
 - the documentation improvements.


Hans Verkuil (1):
  v4l-ctrl: Add a method for control value range update

Sylwester Nawrocki (2):
  v4l: Add new alpha component control
  s5p-fimc: Add support for alpha component configuration

 Documentation/DocBook/media/v4l/compat.xml         |   11 ++
 Documentation/DocBook/media/v4l/controls.xml       |   25 +++-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   16 ++
 drivers/media/video/s5p-fimc/fimc-core.c           |  130 ++++++++++++++----
 drivers/media/video/s5p-fimc/fimc-core.h           |   31 ++++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 ++++++--
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 +
 drivers/media/video/v4l2-ctrls.c                   |  148 ++++++++++++++------
 include/linux/videodev2.h                          |    7 +-
 include/media/v4l2-ctrls.h                         |   17 +++
 11 files changed, 354 insertions(+), 96 deletions(-)


-- 
Regards,
 
Sylwester Nawrocki 
Samsung Poland R&D Center

