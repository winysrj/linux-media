Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab0I1Sxf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:53:35 -0400
Date: Tue, 28 Sep 2010 15:46:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/10] V4L/DVB: cx231xx: Only change gpio direction when
 needed
Message-ID: <20100928154658.35941986@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 8e088db..28f77a7 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -495,10 +495,11 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 	if (dev->board.tuner_gpio) {
 		cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
 		cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit, 1);
+	}
+	if (dev->board.tuner_sif_gpio >= 0)
 		cx231xx_set_gpio_direction(dev, dev->board.tuner_sif_gpio, 1);
 
-		/* request some modules if any required */
-	}
+	/* request some modules if any required */
 
 	/* set the mode to Analog mode initially */
 	cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index b4859a0..d079433 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -333,9 +333,10 @@ struct cx231xx_board {
 	struct cx231xx_reg_seq *dvb_gpio;
 	struct cx231xx_reg_seq *suspend_gpio;
 	struct cx231xx_reg_seq *tuner_gpio;
-	u8 tuner_sif_gpio;
-	u8 tuner_scl_gpio;
-	u8 tuner_sda_gpio;
+		/* Negative means don't use it */
+	s8 tuner_sif_gpio;
+	s8 tuner_scl_gpio;
+	s8 tuner_sda_gpio;
 
 	/* PIN ctrl */
 	u32 ctl_pin_status_mask;
-- 
1.7.1


