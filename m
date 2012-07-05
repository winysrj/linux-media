Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GERS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 13:18:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: chanchoiwing@gmail.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] [media] xc5000: Add support for DMB-TH and ISDB-T
Date: Thu,  5 Jul 2012 14:18:44 -0300
Message-Id: <1341508724-32619-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <CAHPEtt=7Yxz=U1YaJrMAk8GqoiVSkZpJD9vwo2vumpAb27CCCw@mail.gmail.com>
References: <CAHPEtt=7Yxz=U1YaJrMAk8GqoiVSkZpJD9vwo2vumpAb27CCCw@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

xc5000 is just a tuner, not a decoder, so both DMB-TH and ISDB-T should
work properly there: it is just a matter of teaching the driver what
saw filter should be used and how to calculate the center frequency.

Requested-by: Choi Wing Chan <chanchoiwing@gmail.com>
Cc: Steven Toth <stoth@linuxtv.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc5000.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index dcca42c..bac8009 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -717,6 +717,12 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		priv->freq_hz = freq - 1750000;
 		priv->video_standard = DTV6;
 		break;
+	case SYS_ISDBT:
+		/* All ISDB-T are currently for 6 MHz bw */
+		if (!bw)
+			bw = 6000000;
+		/* fall to OFDM handling */
+	case SYS_DMBTH:
 	case SYS_DVBT:
 	case SYS_DVBT2:
 		dprintk(1, "%s() OFDM\n", __func__);
-- 
1.7.10.4

