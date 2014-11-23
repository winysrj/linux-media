Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59534 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaKWM4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:56:07 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8A9292A0083
	for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 13:56:01 +0100 (CET)
Message-ID: <5471D961.5080607@xs4all.nl>
Date: Sun, 23 Nov 2014 13:56:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Various cleanups &  sg_next fix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5937a784c3e5fe8fd1e201f42a2b1ece6c36a6c0:

  [media] staging: media: bcm2048: fix coding style error (2014-11-21 16:50:37 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19i

for you to fetch changes up to 8b81fc8f5b8b92ff280fe7dc5071eae29c1a7fd3:

  v4l2-common: move v4l2_ctrl_check to cx2341x (2014-11-23 13:54:21 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      bttv/cx25821/cx88/ivtv: use sg_next instead of sg++
      v4l2-dev: vdev->v4l2_dev is always set, so simplify code.
      v4l2-common: remove unused helper functions.
      v4l2-ctrl: move function prototypes from common.h to ctrls.h
      v4l2-common: move v4l2_ctrl_check to cx2341x

Prabhakar Lad (1):
      media: vivid: use vb2_ops_wait_prepare/finish helper

 drivers/media/common/cx2341x.c               |  29 +++++++++++++++++++
 drivers/media/pci/bt8xx/bttv-risc.c          |  12 ++++----
 drivers/media/pci/cx25821/cx25821-core.c     |  12 ++++----
 drivers/media/pci/cx88/cx88-core.c           |   6 ++--
 drivers/media/pci/ivtv/ivtv-udma.c           |   2 +-
 drivers/media/platform/vivid/vivid-core.c    |  19 ++++--------
 drivers/media/platform/vivid/vivid-core.h    |   3 --
 drivers/media/platform/vivid/vivid-sdr-cap.c |   4 +--
 drivers/media/platform/vivid/vivid-vbi-cap.c |   4 +--
 drivers/media/platform/vivid/vivid-vbi-out.c |   4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |   4 +--
 drivers/media/platform/vivid/vivid-vid-out.c |   4 +--
 drivers/media/v4l2-core/v4l2-common.c        | 125 -------------------------------------------------------------------------------
 drivers/media/v4l2-core/v4l2-dev.c           |  34 +++++++++-------------
 include/media/v4l2-common.h                  |  17 +----------
 include/media/v4l2-ctrls.h                   |  25 ++++++++++++++++
 16 files changed, 100 insertions(+), 204 deletions(-)
