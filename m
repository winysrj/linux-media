Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C044AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 14:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C8BB20880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 14:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbfBTORo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:17:44 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:44417 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfBTORo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 09:17:44 -0500
Received: from localhost (unknown [185.94.189.187])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 38AC310000D;
        Wed, 20 Feb 2019 14:17:37 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4 0/2] media: cedrus: Add H264 decoding support
Date:   Wed, 20 Feb 2019 15:17:32 +0100
Message-Id: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Here is a new version of the H264 decoding support in the cedrus
driver.

As you might already know, the cedrus driver relies on the Request
API, and is a reverse engineered driver for the video decoding engine
found on the Allwinner SoCs.

This work has been possible thanks to the work done by the people
behind libvdpau-sunxi found here:
https://github.com/linux-sunxi/libvdpau-sunxi/

I've tested the various ABI using this gdb script:
http://code.bulix.org/jl4se4-505620?raw

And this test script:
http://code.bulix.org/8zle4s-505623?raw

The application compiled is quite trivial:
http://code.bulix.org/e34zp8-505624?raw

The output is:
arm:	builds/arm-test-v4l2-h264-structures
	SHA1: fd15b30328765c2caac877e8ea8452c829b2b1d8
x86:	builds/x86-test-v4l2-h264-structures
	SHA1: fd15b30328765c2caac877e8ea8452c829b2b1d8
x64:	builds/x64-test-v4l2-h264-structures
	SHA1: fd15b30328765c2caac877e8ea8452c829b2b1d8
arm64:	builds/arm64-test-v4l2-h264-structures
	SHA1: fd15b30328765c2caac877e8ea8452c829b2b1d8

Let me know if there's any flaw using that test setup, or if you have
any comments on the patches.

Maxime

Changes from v3:
  - Reintroduced long term reference flag and documented it
  - Reintroduced ref_pic_list_p0/b0/b1 and documented it
  - Documented the DPB flags
  - Treat the scaling matrix as optional in the driver, as documented
  - Free the neighbor buffer
  - Increase the control IDs by a large margin to be safe of collisions
  - Reorder the fields documentation according to the structure layout
  - Change the tag documentation by the timestamp
  - Convert the sram array to size_t
  - Simplify the buffer retrieval from timestamp
  - Rebase

Changes from v2:
  - Simplified _cedrus_write_ref_list as suggested by Jernej
  - Set whether the frame is used as reference using nal_ref_idc
  - Respect chroma_format_idc
  - Fixes for the scaling list and prediction tables
  - Wrote the documentation for the flags
  - Added a bunch of defines to the driver bit fields
  - Reworded the controls and data format descriptions as suggested
    by Hans
  - Reworked the controls' structure field size to avoid padding
  - Removed the long term reference flag
  - Reintroduced the neighbor info buffer
  - Removed the ref_pic_list_p0/b0/b1 arrays that are redundant with the
    one in the DPB
  - used the timestamps instead of tags
  - Rebased on 5.0-rc1

Changes from v1:
  - Rebased on 4.20
  - Did the documentation for the userspace API
  - Used the tags instead of buffer IDs
  - Added a comment to explain why we still needed the swdec trigger
  - Reworked the MV col buffer in order to have one slot per frame
  - Removed the unused neighbor info buffer
  - Made sure to have the same structure offset and alignments across
    32 bits and 64 bits architecture

Maxime Ripard (1):
  media: cedrus: Add H264 decoding support

Pawel Osciak (1):
  media: uapi: Add H264 low-level decoder API compound controls.

 Documentation/media/uapi/v4l/biblio.rst            |   9 +-
 Documentation/media/uapi/v4l/extended-controls.rst | 547 +++++++++++++-
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |  20 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
 Documentation/media/videodev2.h.rst.exceptions     |   5 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
 drivers/staging/media/sunxi/cedrus/Makefile        |   3 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |  30 +-
 drivers/staging/media/sunxi/cedrus/cedrus.h        |  38 +-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  13 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   | 584 ++++++++++++++-
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |  91 ++-
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   9 +-
 include/media/h264-ctrls.h                         | 190 +++++-
 include/media/v4l2-ctrls.h                         |  13 +-
 include/uapi/linux/videodev2.h                     |   1 +-
 18 files changed, 1627 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h264.c
 create mode 100644 include/media/h264-ctrls.h

base-commit: aa89b613a1c52cfd25076acfbbf6266c4b6f411b
-- 
git-series 0.9.1
