Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1FSRnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:42 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5JHhgcv028217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:42 -0400
Received: from pedra (vpn-238-25.phx2.redhat.com [10.3.238.25])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5JHhWq4018286
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:41 -0400
Date: Sun, 19 Jun 2011 14:42:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/11] [media] em28xx: Mark Kworld 305 as validated
Message-ID: <20110619144234.7553fa8d@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This board were used for testing the em28xx-alsa using a separate interface.
So, it is obviously validated ;)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index c445bea..c892a1e 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1319,7 +1319,6 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2880_BOARD_KWORLD_DVB_305U] = {
 		.name	      = "KWorld DVB-T 305U",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
-- 
1.7.1

