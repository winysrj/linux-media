Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44478 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbcBHK0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 05:26:00 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6C519180EBF
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2016 11:25:55 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Various fixes
Message-ID: <56B86D33.4050904@xs4all.nl>
Date: Mon, 8 Feb 2016 11:25:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and improvements.

Add a new control to set the AVI InfoFrame content type.

Regards,

	Hans

The following changes since commit 210bd104c6acd31c3c6b8b075b3f12d4a9f6b60d:

  [media] xc2028: unlock on error in xc2028_set_config() (2016-02-04 09:30:31 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6b

for you to fetch changes up to c35cdaf400c7d8b30e1cc4fb853e63c5a770533a:

  tea575x: convert to library (2016-02-08 11:25:23 +0100)

----------------------------------------------------------------
Amitoj Kaur Chawla (1):
      media: platform: vivid: vivid-osd: Remove unnecessary cast to kfree

Andy Shevchenko (1):
      tea575x: convert to library

Guennadi Liakhovetski (1):
      V4L: ov9650: fix control clusters

Hans Verkuil (5):
      v4l2-ctrls: add V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
      DocBook media: document the new V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
      adv7604: add support to for the content type control.
      adv7842: add support to for the content type control.
      adv7511: add support to for the content type control.

Jean-Michel Hautbois (1):
      media: i2c: adv7604: Use v4l2-dv-timings helpers

Vladimir Zapolskiy (1):
      v4l2-ctrls: remove unclaimed v4l2_ctrl_add_ctrl() interface

 Documentation/DocBook/media/v4l/controls.xml |  50 +++++++++++++++++
 Documentation/video4linux/v4l2-controls.txt  |   1 -
 drivers/media/i2c/adv7511.c                  |  22 +++++++-
 drivers/media/i2c/adv7604.c                  | 199 ++++++++++++++++++++++++++++-------------------------------------
 drivers/media/i2c/adv7842.c                  |  20 +++++++
 drivers/media/i2c/ov9650.c                   |   4 +-
 drivers/media/platform/vivid/vivid-osd.c     |   2 +-
 drivers/media/radio/tea575x.c                |  21 +------
 drivers/media/v4l2-core/v4l2-ctrls.c         |  32 +++++------
 include/media/v4l2-ctrls.h                   |  12 ----
 include/uapi/linux/v4l2-controls.h           |  10 ++++
 11 files changed, 207 insertions(+), 166 deletions(-)

