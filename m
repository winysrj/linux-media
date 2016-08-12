Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52507 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbcHLLW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 07:22:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B80CF1800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 13:22:16 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Colorspace handling fixes
Message-ID: <7dcd9871-dd3a-2754-61a4-57ac935abd30@xs4all.nl>
Date: Fri, 12 Aug 2016 13:22:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request fixes a number of bugs/documentation mistakes w.r.t.
colorspaces.

The main one is that the V4L2_YCBCR_ENC_SYCC was mistakenly added. It turns
out it is identical to the BT.601 Y'CbCr encoding. So the use of the old SYCC
define has been removed from the kernel and documentation.

Some other changes: a 4th decimal was added to the BT.601 conversion matrices,
the default Y'CbCr quantization range for sRGB and AdobeRGB is full range
instead of limited range, and two textual mistakes were fixed in the doc.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sycc

for you to fetch changes up to 90c7c496be2ddabc4ea42453e56edd807ca8592e:

  pixfmt-007.rst: fix copy-and-paste error in SMPTE-240M doc (2016-08-12 13:12:28 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      videodev2.h: fix sYCC/AdobeYCC default quantization range
      vivid: don't mention the obsolete sYCC Y'CbCr encoding
      v4l2-tpg-core: drop SYCC, use higher precision 601 conversion matrix
      videodev2.h: put V4L2_YCBCR_ENC_SYCC under #ifndef __KERNEL__
      pixfmt.rst: drop V4L2_YCBCR_ENC_SYCC from the documentation
      pixfmt-007.rst: fix a messed up note in the DCI-P3 doc
      pixfmt-007.rst: fix copy-and-paste error in SMPTE-240M doc

 Documentation/media/uapi/v4l/pixfmt-006.rst   | 10 ++--------
 Documentation/media/uapi/v4l/pixfmt-007.rst   | 58 ++++++++++++++++++++++++++-----------------------------
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 14 ++++++--------
 drivers/media/platform/vivid/vivid-ctrls.c    |  3 ++-
 include/uapi/linux/videodev2.h                | 21 ++++++++++++--------
 5 files changed, 50 insertions(+), 56 deletions(-)
