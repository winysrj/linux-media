Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:49320 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbeIKWG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 18:06:57 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-media@vger.kernel.org, slongerbeam@gmail.com
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH v3 0/2] media: v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Date: Tue, 11 Sep 2018 19:06:31 +0200
Message-Id: <1536685593-27512-1-git-send-email-phdm@macqel.be>
In-Reply-To: <linux-media@vger.kernel.org.slongerbeam@gmail.com>
References: <linux-media@vger.kernel.org.slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add V4L2_FRMIVAL_TYPE_CONTINUOUS and V4L2_FRMIVAL_TYPE_STEPWISE for
subdev's frame intervals in addition to implicit existing
V4L2_FRMIVAL_TYPE_DISCRETE type.
--
v2:
	Add a 'type' field and a helper function, as asked by Hans
v3:
	Fix documentation (as asked by Hans)
	Convert a driver to use the new helper function (asked by Hans)
	Initialize 'which' to V4L2_SUBDEV_FORMAT_ACTIVE in helper

Philippe De Muyter (2):
  media: v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
  media: imx: capture: use 'v4l2_fill_frmivalenum_from_subdev'

 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 69 +++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-common.c              | 32 ++++++++++
 drivers/staging/media/imx/imx-media-capture.c      | 18 +-----
 include/media/v4l2-common.h                        | 12 ++++
 include/uapi/linux/v4l2-subdev.h                   | 22 ++++++-
 5 files changed, 133 insertions(+), 20 deletions(-)

-- 
1.8.4
