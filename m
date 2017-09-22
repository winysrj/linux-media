Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46539
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752168AbdIVVrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:47:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/8] Document more parts of V4L2 kAPI part 1
Date: Fri, 22 Sep 2017 18:46:58 -0300
Message-Id: <cover.1506116720.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several  functions and structs at V4L2 that aren't documented.

This is an effort to document some of those. My plan is to work on other
similar patch series until we have the kAPI in sync with the current
implementation.

Mauro Carvalho Chehab (8):
  media: tuner-types: add kernel-doc markups for struct tunertype
  media: v4l2-common: get rid of v4l2_routing dead struct
  media: v4l2-common: get rid of struct v4l2_discrete_probe
  media: v4l2-common.h: document ancillary functions
  media: v4l2-device.h: document ancillary macros
  media: v4l2-dv-timings.h: convert comment into kernel-doc markup
  media: v4l2-event.rst: improve events description
  media: v4l2-ioctl.h: convert debug macros into enum and document

 Documentation/media/kapi/v4l2-event.rst      |  64 +++++--
 drivers/media/platform/vivid/vivid-vid-cap.c |   9 +-
 drivers/media/v4l2-core/v4l2-common.c        |  27 +--
 include/media/tuner-types.h                  |  15 ++
 include/media/v4l2-common.h                  | 130 ++++++++++++---
 include/media/v4l2-device.h                  | 238 +++++++++++++++++++++++----
 include/media/v4l2-dv-timings.h              |  14 +-
 include/media/v4l2-event.h                   |  34 ----
 include/media/v4l2-ioctl.h                   |  33 ++--
 9 files changed, 411 insertions(+), 153 deletions(-)

-- 
2.13.5
