Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54488 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbcFVAW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 20:22:26 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	mchehab@kernel.org, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com
Cc: linux-samsung-soc@vger.kernel.org,
	mjpeg-users@lists.sourceforge.net, devel@driverdev.osuosl.org,
	lars@metafoo.de,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/2] move s_stream from v4l2_subdev_video_ops to move s_stream from v4l2_subdev_pad_ops
Date: Wed, 22 Jun 2016 02:19:23 +0200
Message-Id: <20160622001925.30077-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This series moves s_stream from struct v4l2_subdev_video_ops to struct
v4l2_subdev_pad_ops. The reason for this is that there are devices 
(adv7482 for example) which can support more then one video pipeline 
connected to two different output pads to run simultaneously. In order 
to be able to be able to start and stop streams on a pad level the 
s_stream operation needs to be extended with a pad argument.

The series is based on the master branch of the media_tree.

It have been suggested by both Laurent Pinchart and Hans Verkuil that if 
a pad aware s_stream is needed the operation should be moved from the 
video struct to the pad ops struct and not just add a s_stream to the 
pad ops struct.

The change to v4l framework is trivial and only moves s_stream between 
the two structs and adds a 'pad' argument. The majority of the changes 
is updating all users of the s_stream operation to use the one from 
v4l2_subdev_pad_ops.

Patch 1/2 is a preparation of the vsp1 driver where the 
v4l2_subdev_video_ops struct was shared by two devices which no longer 
can be shared since only one of them implements s_stream.

Patch 2/2 moves the s_stream operation between the struct and updates 
all users. The callers have primarily been updated using Coccinelle 
patch which is attached to this cover letter.

After the spatch run all changes have been manually reviewed and struct 
v4l2_subdev_pad_ops have been added to drivers which previously did not 
have one. Likewise struct v4l2_subdev_video_ops which became 'empty' 
after removing s_stream have been removed. A few drivers needed some 
code to me moved around (most notably s5k4ecgx) for ordering but nothing 
in the code itself have changed while moving it except to update calls 
to s_stream to use the pad version.

I have tested this series to the best of my ability by building 
allyesconfig configurations for arm, arm64 and x86_64. I have also 
tested on a R-Car Koelsch board (rcar-vin and adv7180).

>>>>cut<<<<
@ rule1 @
identifier fn, s;
@@

 struct v4l2_subdev_video_ops s = { .s_stream = fn, };

@@
identifier rule1.fn, rule1.s;
@@

 struct v4l2_subdev_video_ops s = {
-.s_stream = fn,
 };

@@
identifier rule1.fn, s;
@@

 struct v4l2_subdev_pad_ops s = {
+.s_stream = fn,
 };

@@
identifier rule1.fn, a, b;
symbol pad;
@@

-fn(struct v4l2_subdev *a, int b)
+fn(struct v4l2_subdev *a, unsigned int pad, int b)
 {
 ...
 }

@@
identifier rule1.fn;
expression e1, e2;
@@

-fn(e1, e2);
+fn(e1, 0, e2);

@@
expression e1, e2;
symbol video, pad, s_stream;
@@

-v4l2_subdev_call(e1, video, s_stream, e2);
+v4l2_subdev_call(e1, pad, s_stream, 0, e2);

@@
expression e1, e2, e3;
symbol video, pad, s_stream;
@@

-e3 = v4l2_subdev_call(e1, video, s_stream, e2);
+e3 = v4l2_subdev_call(e1, pad, s_stream, 0, e2);

@@
expression e1, e2;
@@

-call_all(e1, video, s_stream, e2);
+call_all(e1, pad, s_stream, 0, e2);

@@
expression e1, e2, e3;
symbol video, pad, s_stream;
@@

-ivtv_call_hw(e1, e2, video, s_stream, e3);
+ivtv_call_hw(e1, e2, pad, s_stream, 0, e3);

@@
expression e1, e2, e3, e4;
symbol video, pad, s_stream;
@@

-e1 = v4l2_device_call_until_err(e2, e3, video, s_stream, e4);
+e1 = v4l2_device_call_until_err(e2, e3, pad, s_stream, 0, e4);

@@
expression e2, e3, e4;
symbol video, pad, s_stream;
@@

-v4l2_device_call_until_err(e2, e3, video, s_stream, e4);
+v4l2_device_call_until_err(e2, e3, pad, s_stream, 0, e4);

@@
expression e1, e2, e3;
symbol video, pad, s_stream;
@@

-v4l2_device_call_all(e1, e2, video, s_stream, e3);
+v4l2_device_call_all(e1, e2, pad, s_stream, 0, e3);

@@
expression e1, e2;
symbol video, pad, s_stream;
@@

-cx25840_call(e1, video, s_stream, e2);
+cx25840_call(e1, pad, s_stream, 0, e2);
>>>>cut<<<<

Niklas Söderlund (2):
  [media] v4l: vsp1: Split pad operations between rpf and wpf
  [media] v4l: subdev: move s_stream from v4l2_subdev_video_ops to
    v4l2_subdev_pad_ops

 drivers/media/dvb-frontends/au8522_decoder.c       |   9 +-
 drivers/media/i2c/ad9389b.c                        |   7 +-
 drivers/media/i2c/adv7180.c                        |   5 +-
 drivers/media/i2c/adv7183.c                        |   5 +-
 drivers/media/i2c/adv7511.c                        |   7 +-
 drivers/media/i2c/ak881x.c                         |   5 +-
 drivers/media/i2c/bt819.c                          |   9 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   5 +-
 drivers/media/i2c/ks0127.c                         |   9 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |  19 +--
 drivers/media/i2c/mt9m032.c                        |   5 +-
 drivers/media/i2c/mt9p031.c                        |   9 +-
 drivers/media/i2c/mt9t001.c                        |   9 +-
 drivers/media/i2c/mt9v032.c                        |   9 +-
 drivers/media/i2c/noon010pc30.c                    |   6 +-
 drivers/media/i2c/ov2659.c                         |   8 +-
 drivers/media/i2c/ov9650.c                         |   4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   5 +-
 drivers/media/i2c/s5k4ecgx.c                       | 180 ++++++++++-----------
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/s5k6aa.c                         |   4 +-
 drivers/media/i2c/saa7110.c                        |   9 +-
 drivers/media/i2c/saa7115.c                        |   5 +-
 drivers/media/i2c/saa7127.c                        |   9 +-
 drivers/media/i2c/saa717x.c                        |   5 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   9 +-
 drivers/media/i2c/soc_camera/imx074.c              |   5 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   5 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   5 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   5 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   5 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   5 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   9 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   5 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   5 +-
 drivers/media/i2c/tc358743.c                       |   5 +-
 drivers/media/i2c/ths7303.c                        |  10 +-
 drivers/media/i2c/ths8200.c                        |   9 +-
 drivers/media/i2c/tvp514x.c                        |  10 +-
 drivers/media/i2c/tvp5150.c                        |   5 +-
 drivers/media/i2c/tvp7002.c                        |   5 +-
 drivers/media/i2c/vpx3220.c                        |   9 +-
 drivers/media/i2c/vs6624.c                         |   5 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |   2 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   5 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   7 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |   4 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   6 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/pci/zoran/zoran_device.c             |   6 +-
 drivers/media/pci/zoran/zoran_driver.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   4 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   4 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif_capture.c      |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   7 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   7 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   5 +-
 drivers/media/platform/omap3isp/isp.c              |  28 ++--
 drivers/media/platform/omap3isp/ispccdc.c          |  10 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   9 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  10 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   4 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |   4 +-
 drivers/media/platform/omap3isp/isphist.c          |   4 +-
 drivers/media/platform/omap3isp/isppreview.c       |  10 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  10 +-
 drivers/media/platform/omap3isp/ispstat.c          |   3 +-
 drivers/media/platform/omap3isp/ispstat.h          |   3 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  16 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |   5 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |   4 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   4 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |   7 +-
 drivers/media/platform/sh_vou.c                    |   7 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   4 +-
 .../platform/soc_camera/soc_camera_platform.c      |   5 +-
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |  12 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  40 ++---
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  20 +++
 drivers/media/platform/vsp1/vsp1_wpf.c             |  15 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |   9 +-
 drivers/media/usb/au0828/au0828-video.c            |   6 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   6 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   4 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  10 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   4 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  10 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  10 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  10 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  10 +-
 include/media/v4l2-subdev.h                        |   8 +-
 112 files changed, 482 insertions(+), 472 deletions(-)

-- 
2.8.3

