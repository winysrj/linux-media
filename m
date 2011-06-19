Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1FSRno (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:44 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5JHhiVq023040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:44 -0400
Received: from pedra (vpn-238-25.phx2.redhat.com [10.3.238.25])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5JHhWq5018286
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:43 -0400
Date: Sun, 19 Jun 2011 14:42:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/11] [media] em28xx: Fix a wrong enum at the ac97 control
 tables
Message-ID: <20110619144236.6c5fc07f@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 55d0d9d..7bf3a86 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -314,12 +314,12 @@ int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val)
 	return 0;
 }
 
-struct em28xx_vol_table {
+struct em28xx_vol_itable {
 	enum em28xx_amux mux;
 	u8		 reg;
 };
 
-static struct em28xx_vol_table inputs[] = {
+static struct em28xx_vol_itable inputs[] = {
 	{ EM28XX_AMUX_VIDEO, 	AC97_VIDEO_VOL   },
 	{ EM28XX_AMUX_LINE_IN,	AC97_LINEIN_VOL  },
 	{ EM28XX_AMUX_PHONE,	AC97_PHONE_VOL   },
@@ -403,7 +403,12 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 	return ret;
 }
 
-static const struct em28xx_vol_table outputs[] = {
+struct em28xx_vol_otable {
+	enum em28xx_aout mux;
+	u8		 reg;
+};
+
+static const struct em28xx_vol_otable outputs[] = {
 	{ EM28XX_AOUT_MASTER, AC97_MASTER_VOL      },
 	{ EM28XX_AOUT_LINE,   AC97_LINE_LEVEL_VOL  },
 	{ EM28XX_AOUT_MONO,   AC97_MASTER_MONO_VOL },
-- 
1.7.1


