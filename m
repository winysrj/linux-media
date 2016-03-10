Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33727 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcCJFHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 00:07:15 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] media add change_source handler support
Date: Wed,  9 Mar 2016 22:07:06 -0700
Message-Id: <cover.1457585839.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series:
1. Adds change_source function pointer to struct media_device. Using
   the change_source handler, driver can disable current source and
   enable new one in one step when user selects a new input.
2. Add a new common v4l interface to call change_source handler
3. Add change_source hanlder to au0828-core
4. Change change vidioc_s_input() to call v4l_change_media_source()

Shuah Khan (4):
  media: add change_source handler function pointer
  media: v4l2-mc add v4l_change_media_source() to invoke change_source
  media: au0828 add media device change_source handler
  media: au0828 change vidioc_s_input() to call
    v4l_change_media_source()

 drivers/media/usb/au0828/au0828-core.c  | 64 +++++++++++++++++++++++----------
 drivers/media/usb/au0828/au0828-video.c |  8 ++---
 drivers/media/v4l2-core/v4l2-mc.c       | 14 ++++++++
 include/media/media-device.h            | 18 ++++++++--
 include/media/v4l2-mc.h                 | 20 ++++++++++-
 5 files changed, 97 insertions(+), 27 deletions(-)

-- 
2.5.0

