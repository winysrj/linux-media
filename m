Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60218 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab2J2QPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 12:15:11 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3781717wgb.1
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 09:15:09 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [PULL] video_visstrim staging/ov7670_for_v3.7
Date: Mon, 29 Oct 2012 17:15:01 +0100
Message-Id: <1351527301-17855-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
since there was some confusion regarding my two last series
for the ov7670 I've decided to send this pull request to 
make things more clear and avoid merging order issues.

It should apply properly in your current tree.

The following changes since commit 1534e55974c7e2f57623457c0f6b4108c6ef4776:

  media: coda: Add Philipp's patches. (2012-09-24 17:30:53 +0200)

are available in the git repository at:

  https://github.com/jmartinc/video_visstrim.git staging/ov7670_for_v3.7 

for you to fetch changes up to 5a594e1b96d3363aedf74d9bd37a2d669beab0bc:

  ov7670: remove legacy ctrl callbacks. (2012-09-28 13:18:23 +0200)

----------------------------------------------------------------
Javier Martin (9):
      media: ov7670: add support for ov7675.
      media: ov7670: make try_fmt() consistent with 'min_height' and 'min_width'.
      media: ov7670: calculate framerate properly for ov7675.
      media: ov7670: add possibility to bypass pll for ov7675.
      media: ov7670: Add possibility to disable pixclk during hblank.
      ov7670: use the control framework
      mcam-core: implement the control framework.
      via-camera: implement the control framework.
      ov7670: remove legacy ctrl callbacks.

 drivers/media/i2c/ov7670.c                      |  587 +++++++++++++----------
 drivers/media/platform/marvell-ccic/mcam-core.c |   54 +--
 drivers/media/platform/marvell-ccic/mcam-core.h |    2 +
 drivers/media/platform/via-camera.c             |   60 +--
 include/media/ov7670.h                          |    2 +
 5 files changed, 369 insertions(+), 336 deletions(-)
