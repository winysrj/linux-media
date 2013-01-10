Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AJJBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 04:01:17 -0500
Date: Thu, 10 Jan 2013 12:00:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] staging: go7007: print the audio input type
Message-ID: <20130110090057.GD23063@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that the "Audio input:" printk isn't reachable.  Hiding
the "return 0;" behind another statement is a style violation.

It looks like audio_input is normally configured so I've enabled the
print statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index d60e065..37400bf 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -534,7 +534,7 @@ static int s2250_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Brightness: %d\n", state->brightness);
 	v4l2_info(sd, "Contrast: %d\n", state->contrast);
 	v4l2_info(sd, "Saturation: %d\n", state->saturation);
-	v4l2_info(sd, "Hue: %d\n", state->hue);	return 0;
+	v4l2_info(sd, "Hue: %d\n", state->hue);
 	v4l2_info(sd, "Audio input: %s\n", state->audio_input == 0 ? "Line In" :
 					state->audio_input == 1 ? "Mic" :
 					state->audio_input == 2 ? "Mic Boost" :
