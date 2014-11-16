Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60486 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbaKPQeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 11:34:07 -0500
Date: Sun, 16 Nov 2014 17:33:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: soc-camera state 3.19
Message-ID: <Pine.LNX.4.64.1411161711300.21527@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've got 10 patches from Koji Matsuoka and Yoshihiro Kaneko on stack for 
3.19 and a patch from Philipp Zabel, that touches soc-camera, but will 
probably go via Mauro's tree directly. Below is their respective state and 
most recent version and their posting dates. If I missed any patches, 
please let me know!

[PATCH] media: soc_camera: rcar_vin: Add YUYV capture format support
of 14 Oct
state: Ok

[PATCH] media: soc_camera: Fix VIDIOC_S_CROP ioctl miscalculation
of 14 Oct
state: comment posted, waiting for reply

[PATCH] media: soc_camera: rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs
of 20 Oct
state: Ok

[PATCH v3 1/3] media: soc_camera: rcar_vin: Add scaling support
of 21 Oct
state: Ok

[PATCH v3 2/3] media: soc_camera: rcar_vin: Add capture width check for NV16 format
of 21 Oct
state: comment posted, waiting for reply

[PATCH v3 3/3] media: soc_camera: rcar_vin: Add NV16 horizontal scaling-up support
of 21 Oct
state: comment posted, waiting for reply

[PATCH v2] media: soc_camera: rcar_vin: Enable VSYNC field toggle mode
of 22 Oct
state: Ok

[PATCH] media: soc_camera: rcar_vin: Fix alignment of clipping size
of 31 Oct
state: waiting for response to Sergei's comments

[PATCH] media: soc_camera: rcar_vin: Fix interrupt enable in progressive
of 31 Oct
state: Ok

[PATCH v4] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support
of 1 Nov
state: Ok

[PATCH v5 1/6] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
of 29 Sep
state: comment posted, waiting for an update

Thanks
Guennadi
