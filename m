Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42665 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbbEALeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 07:34:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC PATCH 0/3] Add VIDIOC_SUBDEV_QUERYCAP
Date: Fri,  1 May 2015 13:33:47 +0200
Message-Id: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev devices
as discussed during the ELC in San Jose and as discussed here:

http://www.spinics.net/lists/linux-media/msg88009.html

It also adds the entity_id to v4l2_capability.


Hans Verkuil (3):
  v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
  DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
  videodev2.h: add entity_id to struct v4l2_capability

 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 .../DocBook/media/v4l/vidioc-querycap.xml          |  18 ++-
 .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 140 +++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   7 ++
 drivers/media/v4l2-core/v4l2-subdev.c              |  19 +++
 include/uapi/linux/v4l2-subdev.h                   |  12 ++
 include/uapi/linux/videodev2.h                     |   5 +-
 7 files changed, 199 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml

-- 
2.1.4

