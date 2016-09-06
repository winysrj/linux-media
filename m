Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:49515 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933334AbcIFJMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:12:06 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v6 14/14] media: platform: pxa_camera: fix style
Date: Tue,  6 Sep 2016 11:04:24 +0200
Message-Id: <1473152664-5077-14-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a tiny fix for a switch case which quiets 2 checkpatch harmless
warnings. The generated code is not affected.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/pxa_camera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 868c6ad4784c..c2d1ceaea49b 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1296,6 +1296,7 @@ static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
 				"Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code.code);
 		}
+	/* fall through */
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YVYU8_2X8:
@@ -1313,6 +1314,7 @@ static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
 			dev_dbg(pcdev_to_dev(pcdev),
 				"Providing format %s in pass-through mode\n",
 				fmt->name);
+		break;
 	}
 
 	/* Generic pass-through */
-- 
2.1.4

