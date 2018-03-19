Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49644 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754892AbeCSM6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] media: fix inconsistencies
Date: Mon, 19 Mar 2018 13:58:15 +0100
Message-Id: <20180319125820.31254-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes various inconsistencies between
types and documentation and removes the __NEED_MEDIA_LEGACY_API
define.

1) v4l2_pix_format(_mplane) both have a hsv_enc field, but
   not v4l2_mbus_framefmt. It needs to be added to v4l2_mbus_framefmt
   as well.

2) various types in the documentation are not in sync with the
   header.

3) remove __NEED_MEDIA_LEGACY_API since it is both ugly and dangerous.
   Just define what we need in media-device.c with proper comments.

Regards,

	Hans

Hans Verkuil (5):
  v4l2-mediabus.h: add hsv_enc
  subdev-formats.rst: fix incorrect types
  pixfmt-v4l2-mplane.rst: fix types
  pixfmt-v4l2.rst: fix types
  media.h: remove __NEED_MEDIA_LEGACY_API

 .../media/uapi/v4l/pixfmt-v4l2-mplane.rst          | 36 ++++++++++++++--------
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst       | 36 ++++++++++++++--------
 Documentation/media/uapi/v4l/subdev-formats.rst    | 27 ++++++++++++----
 drivers/media/media-device.c                       | 13 ++++++--
 include/uapi/linux/media.h                         |  2 +-
 include/uapi/linux/v4l2-mediabus.h                 |  8 ++++-
 6 files changed, 87 insertions(+), 35 deletions(-)

-- 
2.15.1
