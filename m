Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39415 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1LNOmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 09:42:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW700F2S7JBB270@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 14:42:47 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW700K2F7JBR9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 14:42:47 +0000 (GMT)
Date: Wed, 14 Dec 2011 15:42:41 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 0/2] Add new V4L2_CID_ALPHA_COMPONENT control
In-reply-to: <4EE8A5D6.4030408@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1323873763-4491-1-git-send-email-s.nawrocki@samsung.com>
References: <4EE8A5D6.4030408@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This changeset adds new V4L2_CID_ALPHA_COMPONENT control allowing to configure 
an alpha component of all pixels on the video capture device or on capture queue 
of a mem-to-mem device. This is meant for devices that allow to set a per-pixel
alpha at the pipeline output to a desired value and where the input alpha component 
doesn't influence the output alpha value.

The second patch adds the control to s5p-fimc video capture and mem-to-mem driver.

This changset also does a minor cleanup at the user controls DocBook chapter.

Changes since v3:
  - update the alpha control maximum value manually in the driver rather than
    adding support for this in v4l core

Changes since v2:
  - removed limitation of maximum value for the V4L2_CID_ALPHA_COMPONENT control 
    to 0xff in v4l core
  - the driver now uses function v4l2_ctrl_update_range() for the control range 
    update according to selected colour format

Changes since v1:
 - rename V4L2_CID_COLOR_ALPHA to V4L2_CID_ALPHA_COMPONENT,
 - the documentation improvements.


Sylwester Nawrocki (2):
  v4l: Add new alpha component control
  s5p-fimc: Add support for alpha component configuration

 Documentation/DocBook/media/v4l/compat.xml         |   11 ++
 Documentation/DocBook/media/v4l/controls.xml       |   25 +++-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   11 ++
 drivers/media/video/s5p-fimc/fimc-core.c           |  128 ++++++++++++++++----
 drivers/media/video/s5p-fimc/fimc-core.h           |   30 ++++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 ++++++--
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 +
 drivers/media/video/v4l2-ctrls.c                   |    1 +
 include/linux/videodev2.h                          |    6 +-
 10 files changed, 224 insertions(+), 53 deletions(-)

-- 
1.7.8

--
Regards,
Sylwester
