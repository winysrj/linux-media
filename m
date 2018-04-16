Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49791 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754953AbeDPNV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:21:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/9] media/mc: fix inconsistencies
Date: Mon, 16 Apr 2018 15:21:12 +0200
Message-Id: <20180416132121.46205-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is a follow-up to these two v1 series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg127943.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg127963.html

Some of those patches have been merged for 4.17, so this v2 contains
the remainder and has been updated/rebased for 4.18.

The first two patches add the missing hsv_enc to struct v4l2_mbus_framefmt.
The next patch removes the ugly and IMHO dangerous __NEED_MEDIA_LEGACY_API
define from media.h.

The remaining 6 patches add missing features to the 'old' and 'new' media
controller API. Afterwards the two APIs are the same, except that the new
API exposes interfaces (but that's reasonable since it is a superset of
the 'old' API).

While I am calling it 'old' and 'new' API, there is no reason why applications
can't just pick which API to use, just like applications can choose whether
to use QUERYCTRL or QUERY_EXT_CTRL. The latter ioctl is only required if you
need the new functionality that it gives you.

The one thing I did not add to the 'old' API is to expose the pad/link IDs.
While there is room for it in the structs, there is no API that uses those
IDs at the moment, and I think it would be confusing.

Link IDs would most likely be used with a future S_TOPOLOGY ioctl and not
with the old SETUP_LINK ioctl.

Regards,

	Hans

Hans Verkuil (9):
  v4l2-mediabus.h: add hsv_enc
  subdev-formats.rst: fix incorrect types
  media.h: remove __NEED_MEDIA_LEGACY_API
  media: add function field to struct media_entity_desc
  media-ioc-enum-entities.rst: document new 'function' field
  media: add 'index' to struct media_v2_pad
  media-ioc-g-topology.rst: document new 'index' field
  media: add flags field to struct media_v2_entity
  media-ioc-g-topology.rst: document new 'flags' field

 .../uapi/mediactl/media-ioc-enum-entities.rst      | 31 +++++++++++++++++-----
 .../media/uapi/mediactl/media-ioc-g-topology.rst   | 25 +++++++++++++++--
 Documentation/media/uapi/v4l/subdev-formats.rst    | 27 ++++++++++++++-----
 drivers/media/media-device.c                       | 16 ++++++++---
 include/uapi/linux/media.h                         | 23 +++++++++++++---
 include/uapi/linux/v4l2-mediabus.h                 |  8 +++++-
 6 files changed, 108 insertions(+), 22 deletions(-)

-- 
2.15.1
