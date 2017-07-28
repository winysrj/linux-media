Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60849 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751744AbdG1LFe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 07:05:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFCv2 PATCH 0/2] add VIDIOC_SUBDEV_QUERYCAP ioctl
Date: Fri, 28 Jul 2017 13:05:27 +0200
Message-Id: <20170728110529.4057-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I tried to get this in back in 2015, but that effort stalled.

Trying again, since I really need this in order to add proper v4l-subdev
support to v4l2-ctl and v4l2-compliance. There currently is no way of
unique identifying that the device really is a v4l-subdev device other
than the device name (which can be changed by udev).

So this patch series adds a VIDIOC_SUBDEV_QUERYCAP ioctl that is in
the core so it's guaranteed to be there.

If the subdev is part of an MC then it also gives the corresponding
entity ID of the subdev and the major/minor numbers of the MC device
so v4l2-compliance can relate the subdev device directly to the right
MC device. The reserved array has room enough for more strings should
we need them later, although I think what we have here is sufficient.

Regards,

	Hans

Changes since v1:
- Add name field. Without that it is hard to figure out which subdev
  it is since the entity ID is not very human readable.

Hans Verkuil (2):
  v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
  v4l: document VIDIOC_SUBDEV_QUERYCAP

 Documentation/media/uapi/v4l/user-func.rst         |   1 +
 .../media/uapi/v4l/vidioc-subdev-querycap.rst      | 121 +++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c              |  27 +++++
 include/uapi/linux/v4l2-subdev.h                   |  31 ++++++
 4 files changed, 180 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst

-- 
2.13.1
