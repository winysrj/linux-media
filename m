Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2IYL30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:29:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 4BC3310675B
	for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 13:29:24 +0200 (CEST)
Date: Tue, 25 Sep 2012 13:29:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera 3.7-rc7 fixes
Message-ID: <Pine.LNX.4.64.1209251329110.9446@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

There go the 3 fixes, that popped up (at least in my INBOX;-)) last 
weekend. Unfortunately they'll break your renaming work, not sure if you 
manage to get git to automatically merge the stuff. In fact, I so far 
haven't been able to do anything like "git log" across those directory 
structure revamping patches, which makes work a bit more difficult, but 
well... As for stable - Frank has marked his patch for stable, so, maybe 
it's important for him:-) In any case, the bug, that that patch fixes 
isn't a regression, it has been in the driver since the first version of 
that code. The other two patches aren't too critical either, so, use your 
judgement, I guess.

The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-09-24 16:17:17 -0700)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.7-rc7-fixes

Frank Schäfer (1):
      ov2640: select sensor register bank before applying h/v-flip settings

Peter Senna Tschudin (2):
      drivers/media/video/mx2_camera.c: fix error return code
      drivers/media/video/soc_camera.c: fix error return code

 drivers/media/video/mx2_camera.c |    4 +++-
 drivers/media/video/ov2640.c     |    5 +++++
 drivers/media/video/soc_camera.c |    3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
