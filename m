Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:41507 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0G0MGv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:06:51 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 3/4] mx2_camera: fix comment typo
Date: Tue, 27 Jul 2010 15:06:09 +0300
Message-Id: <cd5696b912700bf234c252a08d0ddf7ffdf7665f.1280229966.git.baruch@tkos.co.il>
In-Reply-To: <cover.1280229966.git.baruch@tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index b42ad8d..d327d11 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -469,7 +469,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx2_buffer *buf)
 
 	/*
 	 * This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in STATE_QUEUED or STATE_ACTIVE
+	 * longer in state VIDEOBUF_QUEUED or VIDEOBUF_ACTIVE
 	 */
 	videobuf_waiton(vb, 0, 0);
 
-- 
1.7.1

