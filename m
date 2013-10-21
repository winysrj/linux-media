Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3JUJ2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 05:28:08 -0400
Date: Mon, 21 Oct 2013 11:28:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC 2/2] V4L2: em28xx: tell the ov2640 driver to balance
 clock enabling internally
In-Reply-To: <Pine.LNX.4.64.1310211107420.32101@axis700.grange>
Message-ID: <Pine.LNX.4.64.1310211127330.32101@axis700.grange>
References: <Pine.LNX.4.64.1310211107420.32101@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver only calls subdevices' .s_power() method to power them
down, relying on the hardware to wake up automatically, which is usually
the case with tuners. This was acceptable with the old .standby() method,
but is wrong with .s_power(). Fixing the driver would be difficult due to
a broad supported hardware base. Instead this patch makes use of the
unbalanced_power soc-camera subdevice flag to tell the ov2640 driver to
balance calls to v4l2_clk_enable() and v4l2_clk_disable() internally.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/usb/em28xx/em28xx-camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 73cc50a..f30043e 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -47,6 +47,7 @@ static struct soc_camera_link camlink = {
 	.bus_id = 0,
 	.flags = 0,
 	.module_name = "em28xx",
+	.unbalanced_power = true,
 };
 
 
-- 
1.7.2.5

