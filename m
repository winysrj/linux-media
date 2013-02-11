Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3BKIjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 03:39:00 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id B282640B98
	for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 09:38:58 +0100 (CET)
Date: Mon, 11 Feb 2013 09:38:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.9] soc-camera + sh-vou
Message-ID: <Pine.LNX.4.64.1302110934420.30282@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Here go a couple of improvements for 3.9.

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.9-set_2

Julia Lawall (1):
      drivers/media/platform/soc_camera/pxa_camera.c: use devm_ functions

Laurent Pinchart (2):
      sh_vou: Use video_drvdata()
      sh_vou: Use vou_dev instead of vou_file wherever possible

 drivers/media/platform/sh_vou.c                |  114 +++++++++++-------------
 drivers/media/platform/soc_camera/pxa_camera.c |   65 +++----------
 2 files changed, 67 insertions(+), 112 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
