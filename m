Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/36] [media] doc-rst: Move v4l docs to media/v4l-drivers
Date: Sun, 17 Jul 2016 22:55:52 -0300
Message-Id: <70c95242c45d7e6af4c0b4aba4119280eb3aa5de.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move V4L documentation files to media/v4l-drivers. Those aren't
core stuff, so they don't fit at the kAPI document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/{video4linux/cafe_ccic => media/v4l-drivers/cafe_ccic.rst}  | 0
 Documentation/{video4linux/README.cpia2 => media/v4l-drivers/cpia2.rst}   | 0
 .../cpia2_overview.txt => media/v4l-drivers/cpia2_overview.rst}           | 0
 Documentation/{video4linux/cx18.txt => media/v4l-drivers/cx18.rst}        | 0
 Documentation/{video4linux/README.cx88 => media/v4l-drivers/cx88.rst}     | 0
 .../README.davinci-vpbe => media/v4l-drivers/davinci-vpbe.rst}            | 0
 Documentation/{video4linux/fimc.txt => media/v4l-drivers/fimc.rst}        | 0
 Documentation/{video4linux/4CCs.txt => media/v4l-drivers/fourcc.rst}      | 0
 Documentation/{video4linux/gspca.txt => media/v4l-drivers/gspca.rst}      | 0
 Documentation/{video4linux/README.ivtv => media/v4l-drivers/ivtv.rst}     | 0
 Documentation/{video4linux/meye.txt => media/v4l-drivers/meye.rst}        | 0
 .../{video4linux/omap3isp.txt => media/v4l-drivers/omap3isp.rst}          | 0
 .../{video4linux/omap4_camera.txt => media/v4l-drivers/omap4_camera.rst}  | 0
 .../{video4linux/README.pvrusb2 => media/v4l-drivers/pvrusb2.rst}         | 0
 .../{video4linux/pxa_camera.txt => media/v4l-drivers/pxa_camera.rst}      | 0
 .../{video4linux/radiotrack.txt => media/v4l-drivers/radiotrack.rst}      | 0
 .../{video4linux/README.saa7134 => media/v4l-drivers/saa7134.rst}         | 0
 .../v4l-drivers/sh_mobile_ceu_camera.rst}                                 | 0
 Documentation/{video4linux/si470x.txt => media/v4l-drivers/si470x.rst}    | 0
 Documentation/{video4linux/si4713.txt => media/v4l-drivers/si4713.rst}    | 0
 Documentation/{video4linux/si476x.txt => media/v4l-drivers/si476x.rst}    | 0
 .../{video4linux/soc-camera.txt => media/v4l-drivers/soc-camera.rst}      | 0
 .../{video4linux/uvcvideo.txt => media/v4l-drivers/uvcvideo.rst}          | 0
 .../{video4linux/README.ir => media/v4l-drivers/v4l-with-ir.rst}          | 0
 Documentation/{video4linux/vivid.txt => media/v4l-drivers/vivid.rst}      | 0
 Documentation/{video4linux/Zoran => media/v4l-drivers/zoran.rst}          | 0
 Documentation/{video4linux/zr364xx.txt => media/v4l-drivers/zr364xx.rst}  | 0
 27 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{video4linux/cafe_ccic => media/v4l-drivers/cafe_ccic.rst} (100%)
 rename Documentation/{video4linux/README.cpia2 => media/v4l-drivers/cpia2.rst} (100%)
 rename Documentation/{video4linux/cpia2_overview.txt => media/v4l-drivers/cpia2_overview.rst} (100%)
 rename Documentation/{video4linux/cx18.txt => media/v4l-drivers/cx18.rst} (100%)
 rename Documentation/{video4linux/README.cx88 => media/v4l-drivers/cx88.rst} (100%)
 rename Documentation/{video4linux/README.davinci-vpbe => media/v4l-drivers/davinci-vpbe.rst} (100%)
 rename Documentation/{video4linux/fimc.txt => media/v4l-drivers/fimc.rst} (100%)
 rename Documentation/{video4linux/4CCs.txt => media/v4l-drivers/fourcc.rst} (100%)
 rename Documentation/{video4linux/gspca.txt => media/v4l-drivers/gspca.rst} (100%)
 rename Documentation/{video4linux/README.ivtv => media/v4l-drivers/ivtv.rst} (100%)
 rename Documentation/{video4linux/meye.txt => media/v4l-drivers/meye.rst} (100%)
 rename Documentation/{video4linux/omap3isp.txt => media/v4l-drivers/omap3isp.rst} (100%)
 rename Documentation/{video4linux/omap4_camera.txt => media/v4l-drivers/omap4_camera.rst} (100%)
 rename Documentation/{video4linux/README.pvrusb2 => media/v4l-drivers/pvrusb2.rst} (100%)
 rename Documentation/{video4linux/pxa_camera.txt => media/v4l-drivers/pxa_camera.rst} (100%)
 rename Documentation/{video4linux/radiotrack.txt => media/v4l-drivers/radiotrack.rst} (100%)
 rename Documentation/{video4linux/README.saa7134 => media/v4l-drivers/saa7134.rst} (100%)
 rename Documentation/{video4linux/sh_mobile_ceu_camera.txt => media/v4l-drivers/sh_mobile_ceu_camera.rst} (100%)
 rename Documentation/{video4linux/si470x.txt => media/v4l-drivers/si470x.rst} (100%)
 rename Documentation/{video4linux/si4713.txt => media/v4l-drivers/si4713.rst} (100%)
 rename Documentation/{video4linux/si476x.txt => media/v4l-drivers/si476x.rst} (100%)
 rename Documentation/{video4linux/soc-camera.txt => media/v4l-drivers/soc-camera.rst} (100%)
 rename Documentation/{video4linux/uvcvideo.txt => media/v4l-drivers/uvcvideo.rst} (100%)
 rename Documentation/{video4linux/README.ir => media/v4l-drivers/v4l-with-ir.rst} (100%)
 rename Documentation/{video4linux/vivid.txt => media/v4l-drivers/vivid.rst} (100%)
 rename Documentation/{video4linux/Zoran => media/v4l-drivers/zoran.rst} (100%)
 rename Documentation/{video4linux/zr364xx.txt => media/v4l-drivers/zr364xx.rst} (100%)

diff --git a/Documentation/video4linux/cafe_ccic b/Documentation/media/v4l-drivers/cafe_ccic.rst
similarity index 100%
rename from Documentation/video4linux/cafe_ccic
rename to Documentation/media/v4l-drivers/cafe_ccic.rst
diff --git a/Documentation/video4linux/README.cpia2 b/Documentation/media/v4l-drivers/cpia2.rst
similarity index 100%
rename from Documentation/video4linux/README.cpia2
rename to Documentation/media/v4l-drivers/cpia2.rst
diff --git a/Documentation/video4linux/cpia2_overview.txt b/Documentation/media/v4l-drivers/cpia2_overview.rst
similarity index 100%
rename from Documentation/video4linux/cpia2_overview.txt
rename to Documentation/media/v4l-drivers/cpia2_overview.rst
diff --git a/Documentation/video4linux/cx18.txt b/Documentation/media/v4l-drivers/cx18.rst
similarity index 100%
rename from Documentation/video4linux/cx18.txt
rename to Documentation/media/v4l-drivers/cx18.rst
diff --git a/Documentation/video4linux/README.cx88 b/Documentation/media/v4l-drivers/cx88.rst
similarity index 100%
rename from Documentation/video4linux/README.cx88
rename to Documentation/media/v4l-drivers/cx88.rst
diff --git a/Documentation/video4linux/README.davinci-vpbe b/Documentation/media/v4l-drivers/davinci-vpbe.rst
similarity index 100%
rename from Documentation/video4linux/README.davinci-vpbe
rename to Documentation/media/v4l-drivers/davinci-vpbe.rst
diff --git a/Documentation/video4linux/fimc.txt b/Documentation/media/v4l-drivers/fimc.rst
similarity index 100%
rename from Documentation/video4linux/fimc.txt
rename to Documentation/media/v4l-drivers/fimc.rst
diff --git a/Documentation/video4linux/4CCs.txt b/Documentation/media/v4l-drivers/fourcc.rst
similarity index 100%
rename from Documentation/video4linux/4CCs.txt
rename to Documentation/media/v4l-drivers/fourcc.rst
diff --git a/Documentation/video4linux/gspca.txt b/Documentation/media/v4l-drivers/gspca.rst
similarity index 100%
rename from Documentation/video4linux/gspca.txt
rename to Documentation/media/v4l-drivers/gspca.rst
diff --git a/Documentation/video4linux/README.ivtv b/Documentation/media/v4l-drivers/ivtv.rst
similarity index 100%
rename from Documentation/video4linux/README.ivtv
rename to Documentation/media/v4l-drivers/ivtv.rst
diff --git a/Documentation/video4linux/meye.txt b/Documentation/media/v4l-drivers/meye.rst
similarity index 100%
rename from Documentation/video4linux/meye.txt
rename to Documentation/media/v4l-drivers/meye.rst
diff --git a/Documentation/video4linux/omap3isp.txt b/Documentation/media/v4l-drivers/omap3isp.rst
similarity index 100%
rename from Documentation/video4linux/omap3isp.txt
rename to Documentation/media/v4l-drivers/omap3isp.rst
diff --git a/Documentation/video4linux/omap4_camera.txt b/Documentation/media/v4l-drivers/omap4_camera.rst
similarity index 100%
rename from Documentation/video4linux/omap4_camera.txt
rename to Documentation/media/v4l-drivers/omap4_camera.rst
diff --git a/Documentation/video4linux/README.pvrusb2 b/Documentation/media/v4l-drivers/pvrusb2.rst
similarity index 100%
rename from Documentation/video4linux/README.pvrusb2
rename to Documentation/media/v4l-drivers/pvrusb2.rst
diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/media/v4l-drivers/pxa_camera.rst
similarity index 100%
rename from Documentation/video4linux/pxa_camera.txt
rename to Documentation/media/v4l-drivers/pxa_camera.rst
diff --git a/Documentation/video4linux/radiotrack.txt b/Documentation/media/v4l-drivers/radiotrack.rst
similarity index 100%
rename from Documentation/video4linux/radiotrack.txt
rename to Documentation/media/v4l-drivers/radiotrack.rst
diff --git a/Documentation/video4linux/README.saa7134 b/Documentation/media/v4l-drivers/saa7134.rst
similarity index 100%
rename from Documentation/video4linux/README.saa7134
rename to Documentation/media/v4l-drivers/saa7134.rst
diff --git a/Documentation/video4linux/sh_mobile_ceu_camera.txt b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
similarity index 100%
rename from Documentation/video4linux/sh_mobile_ceu_camera.txt
rename to Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
diff --git a/Documentation/video4linux/si470x.txt b/Documentation/media/v4l-drivers/si470x.rst
similarity index 100%
rename from Documentation/video4linux/si470x.txt
rename to Documentation/media/v4l-drivers/si470x.rst
diff --git a/Documentation/video4linux/si4713.txt b/Documentation/media/v4l-drivers/si4713.rst
similarity index 100%
rename from Documentation/video4linux/si4713.txt
rename to Documentation/media/v4l-drivers/si4713.rst
diff --git a/Documentation/video4linux/si476x.txt b/Documentation/media/v4l-drivers/si476x.rst
similarity index 100%
rename from Documentation/video4linux/si476x.txt
rename to Documentation/media/v4l-drivers/si476x.rst
diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/media/v4l-drivers/soc-camera.rst
similarity index 100%
rename from Documentation/video4linux/soc-camera.txt
rename to Documentation/media/v4l-drivers/soc-camera.rst
diff --git a/Documentation/video4linux/uvcvideo.txt b/Documentation/media/v4l-drivers/uvcvideo.rst
similarity index 100%
rename from Documentation/video4linux/uvcvideo.txt
rename to Documentation/media/v4l-drivers/uvcvideo.rst
diff --git a/Documentation/video4linux/README.ir b/Documentation/media/v4l-drivers/v4l-with-ir.rst
similarity index 100%
rename from Documentation/video4linux/README.ir
rename to Documentation/media/v4l-drivers/v4l-with-ir.rst
diff --git a/Documentation/video4linux/vivid.txt b/Documentation/media/v4l-drivers/vivid.rst
similarity index 100%
rename from Documentation/video4linux/vivid.txt
rename to Documentation/media/v4l-drivers/vivid.rst
diff --git a/Documentation/video4linux/Zoran b/Documentation/media/v4l-drivers/zoran.rst
similarity index 100%
rename from Documentation/video4linux/Zoran
rename to Documentation/media/v4l-drivers/zoran.rst
diff --git a/Documentation/video4linux/zr364xx.txt b/Documentation/media/v4l-drivers/zr364xx.rst
similarity index 100%
rename from Documentation/video4linux/zr364xx.txt
rename to Documentation/media/v4l-drivers/zr364xx.rst
-- 
2.7.4

