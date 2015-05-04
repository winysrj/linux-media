Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:36466 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbEDIHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 04:07:39 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/4] Add support for V4L2_PIX_FMT_Y16_BE
Date: Mon,  4 May 2015 10:07:28 +0200
Message-Id: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New pixel format type Y16_BE (16 bits greyscale big-endian).

Once I get the fist feedback on this patch I will send the patches for
v4lconvert and qv4l2.


Thanks

Ricardo Ribalda Delgado (4):
  media/vivid: Add support for Y16 format
  media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
  media/vivid: Add support for Y16_BE format
  media/vivid: Code cleanout

 drivers/media/platform/vivid/vivid-tpg.c        | 20 ++++++++++++++++----
 drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
 include/uapi/linux/videodev2.h                  |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

-- 
2.1.4

