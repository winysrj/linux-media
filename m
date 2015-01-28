Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49588 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbbA2Bn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:43:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH v2 0/6] omap4iss: Add RGB2RGB blending matrix support
Date: Wed, 28 Jan 2015 11:17:13 +0200
Message-Id: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds support for exposing the OMAP4 ISS IPIPE RGB2RGB blending
matrix through V4L2 controls, using the compound controls support.

Patches 1 to 4 add new signed compound control types and simplify the control
type init operation. Patches 5 then fixes an issue with the omap4iss driver,
and patch 6 finally adds RGB2RGB blending matrix support.

Please see individual patches for changes since v1.

Laurent Pinchart (6):
  v4l2-ctrls: Add new S8, S16 and S32 compound control types
  v4l2-ctrls: Don't initialize array tail when setting a control
  v4l2-ctrls: Make the control type init op initialize the whole control
  v4l2-ctrls: Export the standard control type operations
  staging: media: omap4iss: Cleanup media entities after unregistration
  staging: media: omap4iss: ipipe: Expose the RGB2RGB blending matrix

 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |  21 ++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |  30 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 103 ++++++++++++----
 drivers/staging/media/omap4iss/iss_ipipe.c         | 135 ++++++++++++++++++++-
 drivers/staging/media/omap4iss/iss_ipipe.h         |  17 +++
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   6 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   6 +-
 include/media/v4l2-ctrls.h                         |  16 ++-
 include/uapi/linux/videodev2.h                     |   6 +
 9 files changed, 301 insertions(+), 39 deletions(-)

-- 
Regards,

Laurent Pinchart

