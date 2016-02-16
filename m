Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55604 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbcBPMYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 07:24:47 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 84A91180DD7
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 13:24:42 +0100 (CET)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Fix and new control
Message-ID: <56C31509.8010309@xs4all.nl>
Date: Tue, 16 Feb 2016 13:24:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One fix to cleanup sparse warnings

One new control. It's implemented in s5p-mfc but the primary use will be in the
upcoming mediatek driver.

Regards,

	Hans

The following changes since commit 3d0ccad0dbbd51b64d307c64cc163002334afbfa:

  [media] siano: use generic function to create MC device (2016-02-16 09:30:46 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6e

for you to fetch changes up to 4ea09da34338a0808af1b3a0c992724a374eb76d:

  media: ti-vpe: cal: Fix syntax check warnings (2016-02-16 13:12:49 +0100)

----------------------------------------------------------------
Benoit Parrot (1):
      media: ti-vpe: cal: Fix syntax check warnings

Wu-Cheng Li (2):
      v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
      s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.

 Documentation/DocBook/media/v4l/controls.xml |  8 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
 drivers/media/platform/ti-vpe/cal.c          | 17 +++++++++--------
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  1 +
 5 files changed, 32 insertions(+), 8 deletions(-)
