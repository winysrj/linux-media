Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34136 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbcEXPGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:06:12 -0400
Received: by mail-pa0-f42.google.com with SMTP id qo8so7587795pab.1
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 08:06:12 -0700 (PDT)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	ricardo.ribalda@gmail.com, p.zabel@pengutronix.de,
	wuchengli@chromium.org, shuahkh@osg.samsung.com,
	hans.verkuil@cisco.com, renesas@ideasonboard.com,
	guennadi.liakhovetski@intel.com, sakari.ailus@linux.intel.com,
	posciak@chromium.org, djkurtz@chromium.org,
	tiffany.lin@mediatek.com, pc.chen@mediatek.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] Add V4L2_PIX_FMT_VP9
Date: Tue, 24 May 2016 23:05:20 +0800
Message-Id: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add V4L2_PIX_FMT_VP9 and the documentation.

Wu-Cheng Li (3):
  videodev2.h: add V4L2_PIX_FMT_VP9 format.
  v4l2-ioctl: add VP9 format description.
  V4L: add VP9 format documentation

 Documentation/DocBook/media/v4l/pixfmt.xml | 5 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c       | 1 +
 include/uapi/linux/videodev2.h             | 1 +
 3 files changed, 7 insertions(+)

-- 
2.8.0.rc3.226.g39d4020

