Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58670 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbbATW21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 17:28:27 -0500
Received: from axis700.grange ([87.78.253.24]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MBFgr-1Y46Vo2G85-00AGNj for
 <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 23:28:25 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 70E1340BD9
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 23:28:23 +0100 (CET)
Date: Tue, 20 Jan 2015 23:28:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.19] soc-camera: capabilities warning fix
Message-ID: <Pine.LNX.4.64.1501202326210.13301@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.19-rc5-fixes

for you to fetch changes up to 52e83770291eb575fec552396a63e95bea9f1557:

  rcar_vin: Update device_caps and capabilities in querycap (2015-01-20 23:22:17 +0100)

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      soc-camera: fix device capabilities in multiple camera host drivers

Nobuhiro Iwamatsu (1):
      rcar_vin: Update device_caps and capabilities in querycap

 drivers/media/platform/soc_camera/atmel-isi.c            | 5 +++--
 drivers/media/platform/soc_camera/mx2_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/mx3_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/omap1_camera.c         | 3 ++-
 drivers/media/platform/soc_camera/pxa_camera.c           | 3 ++-
 drivers/media/platform/soc_camera/rcar_vin.c             | 4 +++-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 4 +++-
 7 files changed, 17 insertions(+), 8 deletions(-)

Thanks
Guennadi
