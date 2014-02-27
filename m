Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42140 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbaB0AZh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:25:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 6/6] msi3101: clamp mmap buffers to reasonable level
Date: Thu, 27 Feb 2014 02:25:22 +0200
Message-Id: <1393460722-11774-7-git-send-email-crope@iki.fi>
In-Reply-To: <1393460722-11774-1-git-send-email-crope@iki.fi>
References: <1393460722-11774-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That value is coming from the user and we need only ensure it is
reasonable. That was pointed by Hans when reviewing rtl2832_sdr driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index c111e9a..000395a 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -831,7 +831,7 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
 
 	/* Absolute min and max number of buffers available for mmap() */
-	*nbuffers = 32;
+	*nbuffers = clamp_t(unsigned int, *nbuffers, 8, 32);
 	*nplanes = 1;
 	/*
 	 *   3, wMaxPacketSize 3x 1024 bytes
-- 
1.8.5.3

