Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60958 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbcB2Lpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 06:45:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/5] media: better type handling
Date: Mon, 29 Feb 2016 12:45:40 +0100
Message-Id: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series takes Laurent's patch 1/2 and by adding the
device_caps field to video_device it makes it possible to create
a real is_media_entity_v4l2_io() function.

Regards,

	Hans

Hans Verkuil (4):
  v4l2: add device_caps to struct video_device
  v4l2-pci-skeleton.c: fill in device_caps in video_device
  vivid: set device_caps in video_device.
  media-entity.h: rename _io to _video_device and add real _io

Laurent Pinchart (1):
  media: Add type field to struct media_entity

 Documentation/video4linux/v4l2-pci-skeleton.c |  6 +--
 drivers/media/platform/vivid/vivid-core.c     | 22 +++-----
 drivers/media/v4l2-core/v4l2-dev.c            |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c          |  3 ++
 drivers/media/v4l2-core/v4l2-subdev.c         |  1 +
 include/media/media-entity.h                  | 77 ++++++++++++++-------------
 include/media/v4l2-common.h                   | 28 ++++++++++
 include/media/v4l2-dev.h                      |  3 ++
 8 files changed, 85 insertions(+), 56 deletions(-)

-- 
2.7.0

