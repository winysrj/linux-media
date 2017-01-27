Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52050 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752032AbdA0Vzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:55:54 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 4/6] staging: bcm2835-v4l2: Add a TODO file for improvements we need.
Date: Fri, 27 Jan 2017 13:55:01 -0800
Message-Id: <20170127215503.13208-5-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/staging/media/platform/bcm2835/TODO | 39 +++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 drivers/staging/media/platform/bcm2835/TODO

diff --git a/drivers/staging/media/platform/bcm2835/TODO b/drivers/staging/media/platform/bcm2835/TODO
new file mode 100644
index 000000000000..61a509992b9a
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/TODO
@@ -0,0 +1,39 @@
+1) Support dma-buf memory management.
+
+In order to zero-copy import camera images into the 3D or display
+pipelines, we need to export our buffers through dma-buf so that the
+vc4 driver can import them.  This may involve bringing in the VCSM
+driver (which allows long-term management of regions of memory in the
+space that the VPU reserved and Linux otherwise doesn't have access
+to), or building some new protocol that allows VCSM-style management
+of Linux's CMA memory.
+
+2) Avoid extra copies for padding of images.
+
+We expose V4L2_PIX_FMT_* formats that have a specified stride/height
+padding in the V4L2 spec, but that padding doesn't match what the
+hardware can do.  If we exposed the native padding requirements
+through the V4L2 "multiplanar" formats, the firmware would have one
+less copy it needed to do.
+
+3) Port to ARM64
+
+The bulk_receive() does some manual cache flushing that are 32-bit ARM
+only, which we should convert to proper cross-platform APIs.
+
+4) Convert to be a platform driver.
+
+Right now when the module probes, it tries to initialize VCHI and
+errors out if it wasn't ready yet.  If bcm2835-v4l2 was built in, then
+VCHI generally isn't ready because it depends on both the firmware and
+mailbox drivers having already loaded.
+
+We should have VCHI create a platform device once it's initialized,
+and have this driver bind to it, so that we automatically load the
+v4l2 module after VCHI loads.
+
+5) Drop the gstreamer workaround.
+
+This was a temporary workaround for a bug that was fixed mid-2014, and
+we should remove it before stabilizing the driver.
+
-- 
2.11.0

