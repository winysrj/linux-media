Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33526 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbcDUAkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 20:40:20 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH/RFC 0/2] Meta-data video device type
Date: Thu, 21 Apr 2016 03:40:25 +0300
Message-Id: <1461199227-22506-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This RFC patch series is a first attempt at adding support for passing
statistics data to userspace using a standard API.

The two core requirements for statistics data capture is zero-copy and
decoupling statistics buffers from images buffers, in order to make statistics
data available to userspace as soon as they're captured. For those reasons the
early consensus we have reached is to use a video device node with a buffer
queue to pass statistics buffers using the V4L2 API.

This patch series extends support for statistics data to the more generic
concept of meta-data. It introduces a new video device type for meta-data,
along with a new format type and a new buffer type.

Patch 1/2 adds support for the meta-data video device type and contains
documentation that explains the concept in more details. Patch 2/2 is an
example of how a meta-data format can be defined and documented to support
histogram data generated by the Renesas R-Car VSP histogram engine (HGO).

Laurent Pinchart (2):
  v4l: Add meta-data video device type
  v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine

 Documentation/DocBook/media/v4l/dev-meta.xml       | 100 +++++++
 .../DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml     | 307 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   9 +
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 ++
 drivers/media/v4l2-core/v4l2-dev.c                 |  21 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  40 +++
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
 include/media/v4l2-dev.h                           |   3 +-
 include/media/v4l2-ioctl.h                         |   8 +
 include/uapi/linux/media.h                         |   2 +
 include/uapi/linux/videodev2.h                     |  17 ++
 12 files changed, 528 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml

-- 
Regards,

Laurent Pinchart

