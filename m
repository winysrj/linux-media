Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:34972 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3A2Pdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 10:33:40 -0500
Received: by mail-we0-f179.google.com with SMTP id x43so396327wey.24
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 07:33:39 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [PULL] video_visstrim ov7670_for_v3.9.
Date: Tue, 29 Jan 2013 16:33:28 +0100
Message-Id: <1359473608-10730-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
this is the pull request I sent to you two months ago.

I've applied the patches on your 'for_v3.9' branch and
everything is still working fine.

Furthermore, I've added the SoB line. I hope everything
is OK this time. If not please let me know.


The following changes since commit 8672c8509e1155a3bc712060bd948ba98a1f283a:

  [media] coda: Fix build due to iram.h rename. (2013-01-29 11:06:53 +0100)

are available in the git repository at:

  https://github.com/jmartinc/video_visstrim.git ov7670_for_v3.9

for you to fetch changes up to 2dc110e020327ad5bbf4cfb2e6717b4d2914d096:

  ov7670: remove legacy ctrl callbacks. (2013-01-29 12:21:40 +0100)

----------------------------------------------------------------
Javier Martin (9):
      media: ov7670: add support for ov7675.
      media: ov7670: make try_fmt() consistent with 'min_height' and 'min_width'.
      media: ov7670: calculate framerate properly for ov7675.
      media: ov7670: add possibility to bypass pll for ov7675.
      media: ov7670: Add possibility to disable pixclk during hblank.
      ov7670: use the control framework.
      mcam-core: implement the control framework.
      via-camera: implement the control framework.
      ov7670: remove legacy ctrl callbacks.

 drivers/media/i2c/ov7670.c                      |  587 +++++++++++++----------
 drivers/media/platform/marvell-ccic/mcam-core.c |   54 +--
 drivers/media/platform/marvell-ccic/mcam-core.h |    2 +
 drivers/media/platform/via-camera.c             |   60 +--
 include/media/ov7670.h                          |    2 +
 5 files changed, 369 insertions(+), 336 deletions(-)
