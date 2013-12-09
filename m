Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4996 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3LIM1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 07:27:35 -0500
Received: from tschai.lan (173-38-208-170.cisco.com [173.38.208.170])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id rB9CRWSg011364
	for <linux-media@vger.kernel.org>; Mon, 9 Dec 2013 13:27:34 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BF03D2A2223
	for <linux-media@vger.kernel.org>; Mon,  9 Dec 2013 13:27:27 +0100 (CET)
Message-ID: <52A5B72F.5040204@xs4all.nl>
Date: Mon, 09 Dec 2013 13:27:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] vb2 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various vb2 fixes. I've asked Marek if I could take care of these since I have
more vb2 patches pending.

Regards,

	Hans

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2

for you to fetch changes up to 46b150a09ec3c12053a334e5f545cc84f3c959e3:

  videobuf2-dma-sg: Support io userptr operations on io memory (2013-12-09 13:25:18 +0100)

----------------------------------------------------------------
Ricardo Ribalda (4):
      videobuf2-dma-sg: Fix typo on debug message
      vb2: Return 0 when streamon and streamoff are already on/off
      videobuf2: Add missing lock held on vb2_fop_release
      videobuf2-dma-sg: Support io userptr operations on io memory

Seung-Woo Kim (1):
      videobuf2: Add log for size checking error in __qbuf_dmabuf

 drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c         | 25 ++++++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-dma-sg.c       | 53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 include/media/videobuf2-core.h                   |  1 +
 5 files changed, 71 insertions(+), 12 deletions(-)
