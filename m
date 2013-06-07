Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FGOEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 10:04:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id AC01140BB3
	for <linux-media@vger.kernel.org>; Fri,  7 Jun 2013 16:04:16 +0200 (CEST)
Date: Fri, 7 Jun 2013 16:04:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 3.10 fixes
Message-ID: <Pine.LNX.4.64.1306071602280.11277@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Please push these to 3.10.

The following changes since commit 1612e111e4e565422242727efb59499cce8738e4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-06 18:09:05 -0700)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.10-rc4-fixes

Katsuya Matsubara (3):
      sh_veu: invoke v4l2_m2m_job_finish() even if a job has been aborted
      sh_veu: keep power supply until the m2m context is released
      sh_veu: fix the buffer size calculation

Wenbing Wang (1):
      soc_camera: error dev remove and v4l2 call

 drivers/media/platform/sh_veu.c                |   15 ++++++---------
 drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
 2 files changed, 8 insertions(+), 11 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
