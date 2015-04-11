Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61287 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbbDKRvD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2015 13:51:03 -0400
Received: from axis700.grange ([87.79.220.251]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MRB8F-1Yous72rdv-00UZgw for
 <linux-media@vger.kernel.org>; Sat, 11 Apr 2015 19:51:00 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 73ED140BD9
	for <linux-media@vger.kernel.org>; Sat, 11 Apr 2015 19:50:58 +0200 (CEST)
Date: Sat, 11 Apr 2015 19:50:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: one rcar-vin patch for 4.1
Message-ID: <Pine.LNX.4.64.1504111944250.17834@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Would it be still possible to get this patch in for 4.1? Especially since 
this is actually a fix, not a new feature.

The following changes since commit bfb4e26f253201aa4f63f13be9447116b3785194:

  Merge branch 'patchwork' into to_next (2015-04-08 18:08:38 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.1-2

for you to fetch changes up to 5a80b589543d4ef910fa6363b602793cfd97f0cf:

  media: soc_camera: rcar_vin: Fix wait_for_completion (2015-04-11 19:32:53 +0200)

----------------------------------------------------------------
Koji Matsuoka (1):
      media: soc_camera: rcar_vin: Fix wait_for_completion

 drivers/media/platform/soc_camera/rcar_vin.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Thanks
Guennadi
