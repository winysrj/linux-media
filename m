Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50960 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbbCOVAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 17:00:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4F18E2A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 22:00:45 +0100 (CET)
Message-ID: <5505F2FD.6000503@xs4all.nl>
Date: Sun, 15 Mar 2015 22:00:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] vivid: fixes and enhancements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes a bunch of vivid bugs and adds support for YUV 4:2:0
formats, Bayer formats and a few other miscellaneous formats that were easy to
implement.

It also refactors the test pattern generator code to split up one huge
function.

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1l

for you to fetch changes up to 5c273b169fce6e4ae0f042c27e7e2fb281f8d48d:

  vivid: sanitize selection rectangle (2015-03-15 19:09:36 +0100)

----------------------------------------------------------------
Hans Verkuil (43):
      vivid: the overlay API wasn't disabled completely for multiplanar
      vivid: fix typo in plane size checks
      vivid: wrong top/bottom order for FIELD_ALTERNATE
      vivid: use TPG_MAX_PLANES instead of hardcoding plane-arrays
      vivid: fix test pattern movement for V4L2_FIELD_ALTERNATE
      vivid: add new checkboard patterns
      vivid-tpg: don't add offset when switching to monochrome
      vivid: do not allow video loopback for SEQ_TB/BT
      vivid-tpg: separate planes and buffers
      vivid-tpg: add helper functions for single buffer planar formats
      vivid-tpg: add hor/vert downsampling fields
      vivid-tpg: precalculate downsampled lines
      vivid-tpg: correctly average the two pixels in gen_twopix()
      vivid-tpg: add hor/vert downsampling support to tpg_gen_text
      vivid-tpg: finish hor/vert downsampling support
      vivid-tpg: add support for more planar formats
      vivid-tpg: add support for V4L2_PIX_FMT_GREY
      vivid-tpg: add helper functions to simplify common calculations
      vivid-tpg: add const where appropriate
      vivid-tpg: add a new tpg_draw_params structure
      vivid-tpg: move common parameters to tpg_draw_params
      vivid-tpg: move pattern-related fields to struct tpg_draw_params
      vivid-tpg: move 'extras' parameters to tpg_draw_params
      vivid-tpg: move the 'extras' drawing to a separate function
      vivid-tpg: split off the pattern drawing code.
      vivid: add new format fields
      vivid: add support for single buffer planar formats
      vivid: add downsampling support
      vivid: add the new planar and monochrome formats
      vivid: add RGB444 support
      vivid: fix format comments
      vivid: add support for [A|X]RGB555X
      vivid: add support for NV24 and NV42
      vivid: add support for PIX_FMT_RGB332
      DocBook media: clarify BGR666
      vivid: add support for BGR666
      vivid: add support for packed YUV formats
      vivid: turn this into a platform_device
      vivid: use v4l2_device.release to clean up the driver
      vivid: add support for 8-bit Bayer formats
      vivid: allow s_dv_timings if it is the same as the current
      vivid: report only one frameinterval
      vivid: sanitize selection rectangle

 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml |   79 +++---
 Documentation/video4linux/vivid.txt                   |    5 +
 drivers/media/platform/vivid/vivid-core.c             |   93 ++++--
 drivers/media/platform/vivid/vivid-core.h             |    8 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c      |  125 ++++----
 drivers/media/platform/vivid/vivid-tpg.c              | 1074 +++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/platform/vivid/vivid-tpg.h              |  112 +++++++-
 drivers/media/platform/vivid/vivid-vid-cap.c          |  112 +++++---
 drivers/media/platform/vivid/vivid-vid-common.c       |  373 +++++++++++++++++++++---
 drivers/media/platform/vivid/vivid-vid-out.c          |   79 +++---
 10 files changed, 1554 insertions(+), 506 deletions(-)
