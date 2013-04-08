Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3858 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934539Ab3DHJKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 05:10:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] Fix s5c73m3-core.c compiler warning
Date: Mon, 8 Apr 2013 11:10:34 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304081110.34877.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix for this compiler warning:

  CC [M]  drivers/media/i2c/s5c73m3/s5c73m3-core.o
drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_load_fw’:
drivers/media/i2c/s5c73m3/s5c73m3-core.c:360:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 5dbb65e..b353c50 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -357,7 +357,7 @@ static int s5c73m3_load_fw(struct v4l2_subdev *sd)
 		return -EINVAL;
 	}
 
-	v4l2_info(sd, "Loading firmware (%s, %d B)\n", fw_name, fw->size);
+	v4l2_info(sd, "Loading firmware (%s, %zu B)\n", fw_name, fw->size);
 
 	ret = s5c73m3_spi_write(state, fw->data, fw->size, 64);
 
