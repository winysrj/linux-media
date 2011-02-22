Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1BVCTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:19:51 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2Jpfc028480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:19:51 -0500
Received: from pedra (vpn-224-79.phx2.redhat.com [10.3.224.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2HksV012926
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:19:50 -0500
Date: Mon, 21 Feb 2011 23:17:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] em28xx: Fix return value for s_ctrl
Message-ID: <20110221231739.2536d2ae@pedra>
In-Reply-To: <cover.1298340861.git.mchehab@redhat.com>
References: <cover.1298340861.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On some cases, driver returns 1. This should be OK, but qv4l2 is too
strict about return values.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index b2e351c..19b8284 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1452,7 +1452,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 			rc = em28xx_audio_analog_set(dev);
 		}
 	}
-	return rc;
+	return (rc < 0) ? rc : 0;
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
-- 
1.7.1


