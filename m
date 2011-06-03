Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1FCSH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 14:07:27 -0400
From: Andre Bartke <andre.bartke@googlemail.com>
To: awalls@md.metrocast.net
Cc: mchehab@infradead.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] drivers/media/video: fix memory leak of snd_cx18_init()
Date: Fri,  3 Jun 2011 20:06:58 +0200
Message-Id: <1307124418-12073-1-git-send-email-andre.bartke@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cxsc is not freed in the error case.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/media/video/cx18/cx18-alsa-main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-alsa-main.c b/drivers/media/video/cx18/cx18-alsa-main.c
index d50d69d..a1e6c2a 100644
--- a/drivers/media/video/cx18/cx18-alsa-main.c
+++ b/drivers/media/video/cx18/cx18-alsa-main.c
@@ -192,6 +192,7 @@ static int snd_cx18_init(struct v4l2_device *v4l2_dev)
 err_exit_free:
 	if (sc != NULL)
 		snd_card_free(sc);
+	kfree(cxsc);
 err_exit:
 	return ret;
 }
-- 
1.7.5.2

