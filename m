Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/5] V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
Date: Thu, 19 Mar 2015 16:21:21 +0100
Message-id: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

This new set of patches overrides the old patchset

media/v4l2-ctrls: Always run s_ctrl on volatile ctrls

with the comments from Hans and Laurent.

Ricardo Ribalda Delgado (5):
  media/v4l2-ctrls: volatiles should not generate CH_VALUE
  media: New flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
  media/v4l2-ctrls: Add execute flags to write_only controls
  media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
  media/Documentation: New flag EXECUTE_ON_WRITE

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  7 ++++---
 .../DocBook/media/v4l/vidioc-queryctrl.xml         | 15 +++++++++++++--
 Documentation/video4linux/v4l2-controls.txt        |  4 +++-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 22 +++++++++++++++++++---
 include/uapi/linux/videodev2.h                     |  1 +
 5 files changed, 40 insertions(+), 9 deletions(-)

-- 
2.1.4
