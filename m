Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3G3MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:40 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 3E65A40BB7
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 14:25:38 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1V48zh-0003vF-Qm
	for linux-media@vger.kernel.org; Tue, 30 Jul 2013 14:25:37 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] V4L2: mx3_camera: print V4L2_MBUS_FMT_* codes in hexadecimal format
Date: Tue, 30 Jul 2013 14:25:34 +0200
Message-Id: <1375187137-15045-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_MBUS_FMT_* codes are defined in v4l2-mediabus.h as hexadecimal
constants. Print them in the same form for easier recognition.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index e526096..83592e4 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -672,7 +672,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
 		dev_warn(icd->parent,
-			 "Unsupported format code #%u: %d\n", idx, code);
+			 "Unsupported format code #%u: 0x%x\n", idx, code);
 		return 0;
 	}
 
@@ -688,7 +688,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			xlate->host_fmt	= &mx3_camera_formats[0];
 			xlate->code	= code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(dev, "Providing format %s using code 0x%x\n",
 				mx3_camera_formats[0].name, code);
 		}
 		break;
@@ -698,7 +698,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			xlate->host_fmt	= &mx3_camera_formats[1];
 			xlate->code	= code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(dev, "Providing format %s using code 0x%x\n",
 				mx3_camera_formats[1].name, code);
 		}
 		break;
-- 
1.7.2.5

