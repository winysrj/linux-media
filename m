Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:59027 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1AaMsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:48:52 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: [PATCH] v4l: mx3_camera: fix NULL pointer dereference if debug output enabled
Date: Mon, 31 Jan 2011 13:49:41 +0100
Message-Id: <1296478181-10838-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Running with enabled debug output in the mx3_camera driver results
in a kernel crash:
...
mx3-camera mx3-camera.0: Providing format Bayer BGGR (sRGB) 8 bit using code 11
Unable to handle kernel NULL pointer dereference at virtual address 00000004
...

Fix it by incrementing 'xlate' after usage.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/mx3_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index b9cb4a4..7bcaaf7 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -734,9 +734,9 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	if (xlate) {
 		xlate->host_fmt	= fmt;
 		xlate->code	= code;
-		xlate++;
 		dev_dbg(dev, "Providing format %x in pass-through mode\n",
 			xlate->host_fmt->fourcc);
+		xlate++;
 	}
 
 	return formats;
-- 
1.7.1

