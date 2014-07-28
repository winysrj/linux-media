Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:54655 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaG1Sc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:32:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id DEB4140BD9
	for <linux-media@vger.kernel.org>; Mon, 28 Jul 2014 20:32:27 +0200 (CEST)
Date: Mon, 28 Jul 2014 20:32:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.17
Message-ID: <Pine.LNX.4.64.1407282030410.32592@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry for a delayed pull-request... A couple of DT documentation patches, 
I've been recently told, that for such cases, where no new bindings are 
added, acks from DT-maintainers aren't compulsory.

The following changes since commit fe3afdce0da93aad256183bf40ff9c0e86ae8a72:

  Merge branch 'patchwork' into to_next (2014-07-22 22:12:07 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.17-1

for you to fetch changes up to 196171191371705756fa69c1c99e97fb3ee1bcf2:

  media: atmel-isi: add primary DT support (2014-07-28 20:25:46 +0200)

----------------------------------------------------------------
Ben Dooks (2):
      soc_camera: add support for dt binding soc_camera drivers
      rcar_vin: add devicetree support

Josh Wu (3):
      media: atmel-isi: add v4l2 async probe support
      media: atmel-isi: convert the pdata from pointer to structure
      media: atmel-isi: add primary DT support

Robert Jarzmik (4):
      media: mt9m111: add device-tree documentation
      media: soc_camera: pxa_camera documentation device-tree support
      media: mt9m111: add device-tree suppport
      media: pxa_camera device-tree support

 .../devicetree/bindings/media/atmel-isi.txt        |  51 ++++++++
 .../devicetree/bindings/media/i2c/mt9m111.txt      |  28 +++++
 .../devicetree/bindings/media/pxa-camera.txt       |  43 +++++++
 .../devicetree/bindings/media/rcar_vin.txt         |  86 ++++++++++++++
 drivers/media/i2c/soc_camera/mt9m111.c             |  12 ++
 drivers/media/platform/soc_camera/atmel-isi.c      |  90 ++++++++++++--
 drivers/media/platform/soc_camera/pxa_camera.c     |  81 ++++++++++++-
 drivers/media/platform/soc_camera/rcar_vin.c       |  72 ++++++++++--
 drivers/media/platform/soc_camera/soc_camera.c     | 129 ++++++++++++++++++++-
 include/media/atmel-isi.h                          |   4 +
 10 files changed, 574 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m111.txt
 create mode 100644 Documentation/devicetree/bindings/media/pxa-camera.txt
 create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt

Thanks
Guennadi
