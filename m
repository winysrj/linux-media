Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37192 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaEHLt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 07:49:26 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH v3 0/2] Add resolution change event
Date: Thu,  8 May 2014 17:19:14 +0530
Message-Id: <1399549756-3743-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds a source_change event to the v4l2-events.
This can be used for notifying the userspace about runtime
format changes happening on video nodes / pads like resolution
change in video decoder.

This version includes suggestions from Hans and Laurent
to make it more generic and to be used by all kinds of
video devices to notify userspace about runtime parameter
changes. The discussion can be seen here [1]

If this is accepted, I can send another series implementing
v4l2_event_init() for zeoring the data array addressing
compatibility issues as discussed in [1].

[1] https://patchwork.kernel.org/patch/4023131/

Changes from v2
---------------
- Event can be subscribed on specific pad / port as
  suggested by Hans.

Changes from v1
---------------
- Addressed review comments from Hans and Laurent
  https://patchwork.kernel.org/patch/4000951/

Arun Kumar K (1):
  [media] v4l: Add source change event

Pawel Osciak (1):
  [media] s5p-mfc: Add support for resolution change event

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   32 +++++++++++++++++
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   19 +++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    7 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 ++
 drivers/media/v4l2-core/v4l2-event.c               |   36 ++++++++++++++++++++
 include/media/v4l2-event.h                         |    4 +++
 include/uapi/linux/videodev2.h                     |    8 +++++
 7 files changed, 108 insertions(+)

-- 
1.7.9.5

