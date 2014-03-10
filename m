Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39803 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaCJTer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:34:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [FINAL PATCH 5/6] msi001: fix v4l2-compliance issues
Date: Mon, 10 Mar 2014 21:34:11 +0200
Message-Id: <1394480052-6003-5-git-send-email-crope@iki.fi>
In-Reply-To: <1394480052-6003-1-git-send-email-crope@iki.fi>
References: <1394480052-6003-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix msi001 driver v4l2-compliance issues.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/msi001.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/msi3101/msi001.c b/drivers/staging/media/msi3101/msi001.c
index 25feece..ac43bae 100644
--- a/drivers/staging/media/msi3101/msi001.c
+++ b/drivers/staging/media/msi3101/msi001.c
@@ -429,6 +429,7 @@ static int msi001_probe(struct spi_device *spi)
 	}
 
 	s->spi = spi;
+	s->f_tuner = bands[0].rangelow;
 	v4l2_spi_subdev_init(&s->sd, spi, &msi001_ops);
 
 	/* Register controls */
-- 
1.8.5.3

