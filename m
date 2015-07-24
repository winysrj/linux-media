Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49571 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbbGXKWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:22:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com
Subject: [RFC PATCH 0/7] Simplify first open/last close checks
Date: Fri, 24 Jul 2015 12:21:29 +0200
Message-Id: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series makes a number of API improvements to simplify checking
if an open or close of a filehandle was the first or last.

Regards,

	Hans

Hans Verkuil (7):
  v4l2-fh: change int to bool for v4l2_fh_is_singular(_file)
  v4l2-fh: v4l2_fh_add/del now return whether it was the first or last
    fh.
  v4l2-fh: add v4l2_fh_open_is_first and v4l2_fh_release_is_last
  am437x-vpfe/fimc-capture: always return 0 on close
  vb2: _vb2_fop_release returns if this was the last fh.
  am437x/exynos4-is/marvell-ccic/sh_vou: simplify release()
  cpia2/si470x: simplify open

 drivers/media/platform/am437x/am437x-vpfe.c      | 16 ++------
 drivers/media/platform/exynos4-is/fimc-capture.c |  8 +---
 drivers/media/platform/marvell-ccic/mcam-core.c  |  5 +--
 drivers/media/platform/sh_vou.c                  |  5 +--
 drivers/media/radio/si470x/radio-si470x-i2c.c    | 21 ++++-------
 drivers/media/usb/cpia2/cpia2_v4l.c              |  5 +--
 drivers/media/v4l2-core/v4l2-fh.c                | 41 +++++++++++++--------
 drivers/media/v4l2-core/videobuf2-core.c         |  7 ++--
 include/media/v4l2-fh.h                          | 47 ++++++++++++++++++------
 include/media/videobuf2-core.h                   |  2 +-
 10 files changed, 82 insertions(+), 75 deletions(-)

-- 
2.1.4

