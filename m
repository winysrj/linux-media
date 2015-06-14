Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49954 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbbFNT5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 15:57:23 -0400
Received: from axis700.grange ([78.35.93.193]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MaZrd-1Yk4ka1vxZ-00K5yk for
 <linux-media@vger.kernel.org>; Sun, 14 Jun 2015 21:57:21 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3CB0140BD9
	for <linux-media@vger.kernel.org>; Sun, 14 Jun 2015 21:57:18 +0200 (CEST)
Date: Sun, 14 Jun 2015 21:57:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 3 more atmel-isi patches for 4.2
Message-ID: <alpine.DEB.2.00.1506142152320.14350@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull 3 atmel-isi patches for 4.2. I've got two more patch series 
under review currently: pxa and rcar_vin, but they will need some more 
time. I'll try to review them next weekend, but I don't think we'll manage 
to push them for 4.2. Even if the PXA series will not produce any 
comments, it still will have to be resubmitted by the author, at least to 
remove one invalid function call, so it's only after that, that I would be 
able to apply and push them out.

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.2-2

for you to fetch changes up to 08764c7fd4772337b0258c7cd2ce21e068b72b10:

  atmel-isi: remove mck backward compatibility code (2015-06-14 21:48:55 +0200)

----------------------------------------------------------------
Josh Wu (3):
      atmel-isi: disable ISI even if it has codec request
      atmel-isi: add runtime pm support
      atmel-isi: remove mck backward compatibility code

 drivers/media/platform/soc_camera/atmel-isi.c | 105 ++++++++++++--------------
 1 file changed, 48 insertions(+), 57 deletions(-)

Thanks
Guennadi
