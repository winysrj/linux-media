Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38644 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDUJ0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 05:26:17 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 0/2] Add resolution change event
Date: Mon, 21 Apr 2014 14:56:00 +0530
Message-Id: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds the resolution change event to the MFC
decoder. This will be used for triggering the runtime resolution
change.

Changes from v1
---------------
- Addressed review comments from Hans and Laurent
  https://patchwork.kernel.org/patch/4000951/

Pawel Osciak (2):
  v4l: Add resolution change event.
  [media] s5p-mfc: Add support for resolution change event

 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16 ++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 ++
 include/uapi/linux/videodev2.h                     |    6 ++++++
 4 files changed, 30 insertions(+)

-- 
1.7.9.5

