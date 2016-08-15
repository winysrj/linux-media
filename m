Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34436 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbcHOHYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 03:24:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4467C180831
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2016 09:24:45 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Fixed for mediatek encoder
Message-ID: <fff44d36-51c7-61e9-c9f5-89ce88e5ed2f@xs4all.nl>
Date: Mon, 15 Aug 2016 09:24:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 4.8 for the new mediatek encoder driver.

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8b

for you to fetch changes up to 14afb4c1a43bd05012cc0994691a0e19533a9908:

  vcodec:mediatek: Refine VP8 encoder driver (2016-08-15 09:23:35 +0200)

----------------------------------------------------------------
Tiffany Lin (7):
      vcodec:mediatek:code refine for v4l2 Encoder driver
      vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
      vcodec:mediatek: Fix visible_height larger than coded_height issue in s_fmt_out
      vcodec:mediatek: Add timestamp and timecode copy for V4L2 Encoder
      vcodec:mediatek: change H264 profile default to profile high
      vcodec:mediatek: Refine H264 encoder driver
      vcodec:mediatek: Refine VP8 encoder driver

 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h     |  1 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c     | 42 ++++++++++++++++++++++++++----------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  6 +++++-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h    |  1 -
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c  | 16 ++++++++--------
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c   | 16 +++++++---------
 6 files changed, 46 insertions(+), 36 deletions(-)
