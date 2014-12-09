Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42595 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbaLIJx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Dec 2014 04:53:27 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id A19192A0085
	for <linux-media@vger.kernel.org>; Tue,  9 Dec 2014 10:53:18 +0100 (CET)
Message-ID: <5486C649.8060700@xs4all.nl>
Date: Tue, 09 Dec 2014 10:52:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] More 3.19 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One vivid typo, two patches that fix the cx88 driver and one patch that
warns if a driver forgets to set device_caps in VIDIOC_QUERYCAP. All
drivers are now supposed to do that, but it is too easy to forget.

I found at least one case where that didn't happen, so expect to see at
least one more pull request for 3.19 fixing this.

Regards,

	Hans

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19n

for you to fetch changes up to d61e832500336d6c1a0267c9b1ed6613156d9fde:

  cx88: remove leftover start_video_dma() call (2014-12-09 10:48:34 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      vivid: fix CROP_BOUNDS typo for video output
      v4l2-ioctl: WARN_ON if querycap didn't fill device_caps
      cx88: add missing alloc_ctx support
      cx88: remove leftover start_video_dma() call

 drivers/media/pci/cx88/cx88-blackbird.c      |  4 +---
 drivers/media/pci/cx88/cx88-dvb.c            |  4 +---
 drivers/media/pci/cx88/cx88-mpeg.c           | 11 +++++++----
 drivers/media/pci/cx88/cx88-vbi.c            |  9 +--------
 drivers/media/pci/cx88/cx88-video.c          | 18 +++++++++---------
 drivers/media/pci/cx88/cx88.h                |  2 ++
 drivers/media/platform/vivid/vivid-vid-out.c |  2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c         |  6 ++++++
 8 files changed, 28 insertions(+), 28 deletions(-)
