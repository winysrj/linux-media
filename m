Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58052 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab2JJSfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:35:07 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 0/5] MEDIA: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:33:30 +0100
Message-Id: <1349894010-7985-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Running below Coccinelle lookup pattern like below on the 
latest kernel showed about 52 hits. This patch series is a subset 
of those 52 patches, so that it will be easy for maintainers to review.
Hopefully these patches will get rid of some code duplication in kernel.

@  @
- initfunc(void)
- { return platform_driver_register(&dr); }

...

- module_init(initfunc);
...

- exitfunc(void)
- { platform_driver_unregister(&dr); }

...

- module_exit(exitfunc);
+ module_platform_driver(dr); 


Srinivas Kandagatla (5):
  media/bfin: use module_platform_driver macro
  media/m2m: use module_platform_driver macro
  media/mx2_emmaprp: use module_platform_driver macro
  media/soc_camera: use module_platform_driver macro
  media/ir_rx51: use module_platform_driver macro

 drivers/media/platform/blackfin/bfin_capture.c |   14 +-------------
 drivers/media/platform/m2m-deinterlace.c       |   14 +-------------
 drivers/media/platform/mx2_emmaprp.c           |   14 +-------------
 drivers/media/platform/soc_camera/soc_camera.c |   14 +-------------
 drivers/media/rc/ir-rx51.c                     |   13 +------------
 5 files changed, 5 insertions(+), 64 deletions(-)

