Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:50915 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DGJlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 05:41:20 -0400
Date: Wed, 7 Apr 2010 12:41:14 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Magnus Damm <damm@opensource.se>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] video: comparing unsigned with negative 0
Message-ID: <20100407094114.GH5157@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc_mbus_bytes_per_line() returns -EINVAL on error but we store it in an
unsigned int so the test for less than zero doesn't work.  I think it
always returns "small" positive values so we can just cast it to int
here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 6e16b39..1ad980f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1633,7 +1633,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	height = pix->height;
 
 	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
-	if (pix->bytesperline < 0)
+	if ((int)pix->bytesperline < 0)
 		return pix->bytesperline;
 	pix->sizeimage = height * pix->bytesperline;
 
