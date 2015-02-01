Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57485 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbbBATqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2015 14:46:14 -0500
Date: Sun, 1 Feb 2015 20:46:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
	Kassey <kassey1216@gmail.com>,
	William Towle <william.towle@codethink.co.uk>,
	Josh Wu <josh.wu@atmel.com>
Subject: soc-camera: patches in work
Message-ID: <Pine.LNX.4.64.1502012038220.18447@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've just posted a pull request with 5 relatively simple patches for 
soc-camera 3.20. AFAICS, the following patches are still in work 
(respective authors and submitters Cc'ed):

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
soc_camera: rcar_vin: Add capture width check for NV16 format

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
soc_camera: rcar_vin: Add NV16 horizontal scaling-up support

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
soc_camera: rcar_vin: Fix alignment of clipping size
 
Josh Wu (5):
  media: soc-camera: use icd->control instead of icd->pdev for reset()
  media: ov2640: add async probe function
  media: ov2640: add primary dt support
  media: ov2640: add a master clock for sensor
  media: ov2640: dt: add the device tree binding document 
  (atmel-isi: add runtime PM)
 
From: Kassey <kassey1216@gmail.com>
V4L: soc-camera: add SPI device support

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com> http://lists.kde.org/?l=linux-sh&m=141476801629391&w=4
From: Valentine Barshak <valentine.barshak@cogentembedded.com> http://marc.info/?l=linux-sh&m=138002993417489
From: William Towle <william.towle@codethink.co.uk>
rcar_vin: Add RGB888_1X24 input format support

Please, remind me if I missed any.

Thanks
Guennadi
