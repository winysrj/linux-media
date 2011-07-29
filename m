Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab1G2K5J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:09 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 50/59] sh: migor: remove unused ov772x buswidth flag
Date: Fri, 29 Jul 2011 12:56:50 +0200
Message-Id: <1311937019-29914-51-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver only supports 8 bits per sample pixel codes, hence
the OV772X_FLAG_8BIT flag has no effect. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/boards/mach-migor/setup.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 184fde1..97899a7 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -448,9 +448,7 @@ static struct i2c_board_info migor_i2c_camera[] = {
 	},
 };
 
-static struct ov772x_camera_info ov7725_info = {
-	.flags		= OV772X_FLAG_8BIT,
-};
+static struct ov772x_camera_info ov7725_info;
 
 static struct soc_camera_link ov7725_link = {
 	.power		= ov7725_power,
-- 
1.7.2.5

