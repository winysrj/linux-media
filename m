Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35222 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbcASHHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 02:07:24 -0500
Received: by mail-pf0-f173.google.com with SMTP id 65so170487199pff.2
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 23:07:24 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com,
	wuchengli@chromium.org, nicolas.dufresne@collabora.com,
	ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	tiffany.lin@mediatek.com, djkurtz@chromium.org
Subject: [PATCH v4 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
Date: Tue, 19 Jan 2016 15:07:08 +0800
Message-Id: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4 changes:
- Change the name to V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
- Add commit message to s5p-mfc patch.

Wu-Cheng Li (2):
  v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
  s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.

 Documentation/DocBook/media/v4l/controls.xml |  8 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  1 +
 4 files changed, 23 insertions(+)

-- 
2.6.0.rc2.230.g3dd15c0

