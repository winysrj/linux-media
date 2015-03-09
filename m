Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56623 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbbCIPo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:44:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 00/29] vivid: add support for 4:2:0 formats
Date: Mon,  9 Mar 2015 16:44:22 +0100
Message-Id: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for most of the 4:2:0 formats that V4L2 has.
In addition, it fixes various bugs, adds some new features and refactors
the test pattern generation code.

The first 8 patches fix bugs and add support for new red/blue checkerboard
patterns.

Patches 9-19 add 4:2:0 support to the test pattern generator code.

Patches 20-25 refactors the test pattern generation function which become
much, much too large.

Patches 26-28 add vivid driver support for the 4:2:0 formats and the last
patch finally enables support for the new formats.

Besides the new 4:2:0 formats support was also added for PIX_FMT_GREY and
some missing 4:2:2 formats.

Regards,

	Hans

Hans Verkuil (29):
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

 Documentation/video4linux/vivid.txt              |   5 +
 drivers/media/platform/vivid/vivid-core.h        |   8 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c | 125 ++--
 drivers/media/platform/vivid/vivid-tpg.c         | 903 ++++++++++++++++-------
 drivers/media/platform/vivid/vivid-tpg.h         | 103 ++-
 drivers/media/platform/vivid/vivid-vid-cap.c     | 100 ++-
 drivers/media/platform/vivid/vivid-vid-common.c  | 207 +++++-
 drivers/media/platform/vivid/vivid-vid-out.c     |  75 +-
 8 files changed, 1109 insertions(+), 417 deletions(-)

-- 
2.1.4

