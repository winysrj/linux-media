Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47797 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752043AbdFLMYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:24:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] MAINTAINERS: add maintainer entry for video multiplexer v4l2 subdevice driver
Date: Mon, 12 Jun 2017 14:24:24 +0200
Message-Id: <20170612122424.15280-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainer entry for the video multiplexer v4l2 subdevice driver that
will control video bus multiplexers via the multiplexer framework.

Signed-off-by: Philip Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f7d568b8f133..f6b8282efe46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13522,6 +13522,12 @@ S:	Maintained
 F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
 
+VIDEO MULTIPLEXER DRIVER
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/video-mux.c
+
 VIRTIO AND VHOST VSOCK DRIVER
 M:	Stefan Hajnoczi <stefanha@redhat.com>
 L:	kvm@vger.kernel.org
-- 
2.11.0
