Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:53089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaCIWR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Mar 2014 18:17:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 569D040BB3
	for <linux-media@vger.kernel.org>; Sun,  9 Mar 2014 23:17:54 +0100 (CET)
Date: Sun, 9 Mar 2014 23:17:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 1 patch
Message-ID: <Pine.LNX.4.64.1403092314460.31306@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Yes, I fixed my problem, that I mentioned to you in an earlier mail, 
please just pull this one patch from my tree @ linuxtv.org, assuming the 
MAINTAINERS patch goes in separately:

The following changes since commit 1b0a7e3263168a06d3858798e48c5a21d1c78d3c:

  Add linux-next specific files for 20140307 (2014-03-07 16:10:56 +1100)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.15-1

for you to fetch changes up to 36771b8e0770a327eade28ac16a5f9760d76b86e:

  media: soc_camera: rcar_vin: Add support for 10-bit YUV cameras (2014-03-09 22:33:56 +0100)

----------------------------------------------------------------
Phil Edworthy (1):
      media: soc_camera: rcar_vin: Add support for 10-bit YUV cameras

 drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
 1 file changed, 9 insertions(+)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
