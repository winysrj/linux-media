Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42890 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1ILOUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 10:20:13 -0400
Received: from lancelot.localnet (unknown [91.178.101.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CDDC8359BB
	for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 14:20:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.1] v4l and uvcvideo fixes
Date: Mon, 12 Sep 2011 16:20:05 +0200
MIME-Version: 1.0
Message-Id: <201109121620.06762.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are four bug fixes for v3.1.

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:                                                                               
                                                                                                                                                           
  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)                                                                                                                

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Dave Young (1):
      v4l: Make sure we hold a reference to the v4l2_device before using it

Hans Verkuil (1):
      v4l: Fix use-after-free case in v4l2_device_release

Laurent Pinchart (1):
      uvcvideo: Fix crash when linking entities

Ming Lei (1):
      uvcvideo: Set alternate setting 0 on resume if the bus has been reset

 drivers/media/video/uvc/uvc_driver.c |    2 +-
 drivers/media/video/uvc/uvc_entity.c |    2 +-
 drivers/media/video/uvc/uvc_video.c  |   10 +++++++++-
 drivers/media/video/uvc/uvcvideo.h   |    2 +-
 drivers/media/video/v4l2-dev.c       |   11 +++++++++++
 drivers/media/video/v4l2-device.c    |    2 ++
 6 files changed, 25 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart
