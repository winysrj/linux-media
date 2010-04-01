Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab0DAR5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 13:57:48 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/15] V4L/DVB: saa7134: clear warning noise
Message-ID: <20100401145631.0fe0ab24@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/saa7134/saa7134-input.c: In function ‘saa7134_raw_decode_irq’:
drivers/media/video/saa7134/saa7134-input.c:957: warning: unused variable ‘oldpulse’
drivers/media/video/saa7134/saa7134-input.c:957: warning: unused variable ‘count’

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 8dd74ae..a42c953 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -954,7 +954,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 {
 	struct card_ir	*ir = dev->remote;
 	unsigned long 	timeout;
-	int count, pulse, oldpulse;
+	int pulse;
 
 	/* Generate initial event */
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-- 
1.6.6.1


