Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60057 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbbAVOsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:48:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH 0/7] omap4iss: Add RGB2RGB blending matrix support
Date: Thu, 22 Jan 2015 16:48:39 +0200
Message-Id: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds support for exposing the OMAP4 ISS IPIPE RGB2RGB blending
matrix through V4L2 controls, using the compound controls support.

Patches 1 to 4 add new signed compound control types and simplify the control
type init operation. Patches 5 and 6 then fix two issues with the omap4iss
driver, and patch 7 finally adds RGB2RGB blending matrix support.

Hans, patch 5 is a 3.19 fix for a compilation breakage introduced by commit
17028cdb74bf8bb5 ("[media] v4l2 core: improve debug flag handling"). Should I
submit it directly to Mauro, or would you like to queue it up in your 3.19
fixes branch ?

Laurent Pinchart (7):
  v4l2-ctrls: Add new S8, S16 and S32 compound control types
  v4l2-ctrls: Don't initialize array tail when setting a control
  v4l2-ctrls: Make the control type init op initialize the whole control
  v4l2-ctrls: Export the standard control type operations
  Revert "[media] v4l: omap4iss: Add module debug parameter"
  staging: media: omap4iss: Cleanup media entities after unregistration
  staging: media: omap4iss: ipipe: Expose the RGB2RGB blending matrix

 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |  21 ++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |  30 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  99 +++++++++++----
 drivers/staging/media/omap4iss/iss_ipipe.c         | 135 ++++++++++++++++++++-
 drivers/staging/media/omap4iss/iss_ipipe.h         |  17 +++
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   6 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   6 +-
 drivers/staging/media/omap4iss/iss_video.c         |   5 -
 include/media/v4l2-ctrls.h                         |  16 ++-
 include/uapi/linux/videodev2.h                     |   6 +
 10 files changed, 302 insertions(+), 39 deletions(-)

-- 
Regards,

Laurent Pinchart

