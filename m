Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33010 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932942AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 680F81800DD
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2016 11:28:22 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] Colorspace fixes
Date: Thu,  4 Aug 2016 11:28:14 +0200
Message-Id: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes a number of bugs/documentation mistakes w.r.t.
colorspaces.

The main one is that the V4L2_YCBCR_ENC_SYCC was mistakenly added. It turns
out it is identical to the BT.601 Y'CbCr encoding. So the use of the old SYCC
define has been removed from the kernel and documentation.

Some other changes: a 4th decimal was added to the BT.601 conversion matrices,
the default Y'CbCr quantization range for sRGB and AdobeRGB is full range
instead of limited range, and two textual mistakes were fixed in the doc.

Hans Verkuil (7):
  videodev2.h: fix sYCC/AdobeYCC default quantization range
  vivid: don't mention the obsolete sYCC Y'CbCr encoding
  v4l2-tpg-core: drop SYCC, use higher precision 601 conversion matrix
  videodev2.h: put V4L2_YCBCR_ENC_SYCC under #ifndef __KERNEL__
  pixfmt.rst: drop V4L2_YCBCR_ENC_SYCC from the documentation
  pixfmt-007.rst: fix a messed up note in the DCI-P3 doc
  pixfmt-007.rst: fix copy-and-paste error in SMPTE-240M doc

 Documentation/media/uapi/v4l/pixfmt-006.rst   | 10 +----
 Documentation/media/uapi/v4l/pixfmt-007.rst   | 58 +++++++++++++--------------
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 14 +++----
 drivers/media/platform/vivid/vivid-ctrls.c    |  3 +-
 include/uapi/linux/videodev2.h                | 21 ++++++----
 5 files changed, 50 insertions(+), 56 deletions(-)

-- 
2.8.1

