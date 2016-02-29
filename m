Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34745 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbcB2M5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 07:57:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC PATCH 0/2] Calculate capabilities based on device_caps
Date: Mon, 29 Feb 2016 13:57:35 +0100
Message-Id: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Once we have device_caps in struct video_device it is quite easy to
add a capabilities field to struct v4l2_device that is the union of
the device_caps value of all video devices.

Tested with vivid.

Regards,

	Hans

Hans Verkuil (2):
  v4l2: collect the union of all device_caps in struct v4l2_device
  vivid: let the v4l2 core calculate the capabilities field

 drivers/media/platform/vivid/vivid-core.c  | 75 ++++++++++++++++--------------
 drivers/media/platform/vivid/vivid-core.h  |  9 ----
 drivers/media/platform/vivid/vivid-ctrls.c |  8 ++--
 drivers/media/v4l2-core/v4l2-dev.c         |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c       |  2 +-
 include/media/v4l2-device.h                |  2 +
 6 files changed, 47 insertions(+), 50 deletions(-)

-- 
2.7.0

