Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62735 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbcDIWTN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Apr 2016 18:19:13 -0400
Received: from axis700.grange ([89.0.109.86]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MOOpx-1auDkJ2Bzp-005nqy for
 <linux-media@vger.kernel.org>; Sun, 10 Apr 2016 00:19:10 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id BC6A240BC6
	for <linux-media@vger.kernel.org>; Sun, 10 Apr 2016 00:19:06 +0200 (CEST)
Date: Sun, 10 Apr 2016 00:19:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: first pull for 4.7
Message-ID: <Pine.LNX.4.64.1604060626190.12238@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following patches for soc-camera and one additional 
cosmetic patch for au0828 - there has been no objections against it, but 
we need to make sure there isn't a conflicting patch in your queue for 
au0828, that begins to use that macro:

The following changes since commit d3f5193019443ef8e556b64f3cd359773c4d377b:

  Merge tag 'v4.6-rc1' into patchwork (2016-03-29 17:17:26 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.7-1

for you to fetch changes up to 7e8dd0611abffcaf176fbaf4d0f0c03fc52046fb:

  soc_camera: rcar_vin: add device tree support for r8a7792 (2016-04-06 06:08:42 +0200)

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      au0828: remove unused macro

Simon Horman (3):
      rcar_vin: Use ARCH_RENESAS
      sh_mobile_ceu_camera: Remove dependency on SUPERH
      soc_camera: rcar_vin: add device tree support for r8a7792

Yoshihiro Kaneko (1):
      soc_camera: rcar_vin: add R-Car Gen 2 and 3 fallback compatibility strings

 Documentation/devicetree/bindings/media/rcar_vin.txt | 12 ++++++++++--
 drivers/media/platform/soc_camera/Kconfig            |  4 ++--
 drivers/media/platform/soc_camera/rcar_vin.c         |  2 ++
 drivers/media/usb/au0828/au0828.h                    |  1 -
 4 files changed, 14 insertions(+), 5 deletions(-)

Thanks
Guennadi
