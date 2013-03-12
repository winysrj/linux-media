Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab3CLONY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 10:13:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 4DBA440BB3
	for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 15:13:22 +0100 (CET)
Date: Tue, 12 Mar 2013 15:13:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera fixes for 3.9 / stable
Message-ID: <Pine.LNX.4.64.1303121508410.680@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

All these patches are fixes and are also good for stable, of them the 
patch from me "fix Oops" should only go back as far as 3.7.

The following changes since commit 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b:

  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-11 07:54:29 -0700)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.9-rc2-fixes

Andrei Andreyanau (1):
      mt9v022 driver: send valid HORIZONTAL_BLANKING values to mt9v024 soc camera

Benoît Thébaudeau (1):
      soc-camera: mt9m111: Fix auto-exposure control

Guennadi Liakhovetski (1):
      mt9m111: fix Oops - initialise context before dereferencing

 drivers/media/i2c/soc_camera/mt9m111.c |    9 +++++----
 drivers/media/i2c/soc_camera/mt9v022.c |   19 ++++++++++++++-----
 2 files changed, 19 insertions(+), 9 deletions(-)

pwclient -u 'accepted' 17341
pwclient -u 'accepted' 16980
pwclient -u 'accepted' 16659

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
