Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46226 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2EHEWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 00:22:32 -0400
Received: by dady13 with SMTP id y13so2126307dad.19
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 21:22:31 -0700 (PDT)
Date: Mon, 07 May 2012 21:22:31 -0700 (PDT)
Message-ID: <87ehqvmhdo.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi <g.liakhovetski@gmx.de>
Cc: Simon <horms@verge.net.au>,
	Masahiro Nakai <nakai@atmark-techno.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: [PATCH] V4L2: mt9t112: fixup JPEG initialization workaround
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Masahiro Nakai <nakai@atmark-techno.com>

It has been indicated on Atmark Techno Web page
http://armadillo.atmark-techno.com/faq/a800eva-dont-work-camera

Signed-off-by: Masahiro Nakai <nakai@atmark-techno.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 drivers/media/video/mt9t112.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 8d1445f..931a378 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -453,6 +453,7 @@ static int mt9t112_init_pll(const struct i2c_client *client)
 	 * I2C Master Clock Divider
 	 */
 	mt9t112_reg_write(ret, client, 0x0014, 0x3046);
+	mt9t112_reg_write(ret, client, 0x0016, 0x0400);
 	mt9t112_reg_write(ret, client, 0x0022, 0x0190);
 	mt9t112_reg_write(ret, client, 0x3B84, 0x0212);
 
-- 
1.7.5.4

