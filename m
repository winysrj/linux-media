Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1G1TFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 15:05:12 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ5B7D008169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:12 -0400
Received: from localhost.localdomain (vpn-8-21.rdu.redhat.com [10.11.8.21])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ58KD026840
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:11 -0400
Date: Thu, 28 Jul 2011 16:04:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] em28xx: Fix DVB-C maxsize for em2884
Message-ID: <20110728160433.5a5eb707@redhat.com>
In-Reply-To: <cover.1311879724.git.mchehab@redhat.com>
References: <cover.1311879724.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at em28xx_isoc_dvb_max_packetsize() sucks, at least for newer
chips: it just returns a magic number. There's no code there to guess
the needed packet size. Yet, it is better than nothing.

Rewrite the code in order to change the default to 752 for em2884 and
newer chips and provide a better way to handle per-chipset specifics.

For em2874, the current default should be enough, as the only em2874
board is currently a 1-seg ISDB-T board, so, it needs only a limited
amount of bandwidth.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index ee0acd8..57b1b5c 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1113,17 +1113,19 @@ EXPORT_SYMBOL_GPL(em28xx_init_isoc);
 int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
 {
 	unsigned int chip_cfg2;
-	unsigned int packet_size = 564;
+	unsigned int packet_size;
 
-	if (dev->chip_id == CHIP_ID_EM2874) {
-		/* FIXME - for now assume 564 like it was before, but the
-		   em2874 code should be added to return the proper value... */
-		packet_size = 564;
-	} else if (dev->chip_id == CHIP_ID_EM28174 || dev->chip_id == CHIP_ID_EM2884) {
-		/* FIXME same as em2874. 564 was enough for 22 Mbit DVB-T
-		   but too much for 44 Mbit DVB-C. */
-		packet_size = 752;
-	} else {
+	switch (dev->chip_id) {
+	case CHIP_ID_EM2710:
+	case CHIP_ID_EM2750:
+	case CHIP_ID_EM2800:
+	case CHIP_ID_EM2820:
+	case CHIP_ID_EM2840:
+	case CHIP_ID_EM2860:
+		/* No DVB support */
+		return -EINVAL;
+	case CHIP_ID_EM2870:
+	case CHIP_ID_EM2883:
 		/* TS max packet size stored in bits 1-0 of R01 */
 		chip_cfg2 = em28xx_read_reg(dev, EM28XX_R01_CHIPCFG2);
 		switch (chip_cfg2 & EM28XX_CHIPCFG2_TS_PACKETSIZE_MASK) {
@@ -1140,9 +1142,24 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
 			packet_size = 752;
 			break;
 		}
+		break;
+	case CHIP_ID_EM2874:
+		/*
+		 * FIXME: for now assumes 564 like it was before, but the
+		 * em2874 code should be added to return the proper value
+		 */
+		packet_size = 564;
+		break;
+	case CHIP_ID_EM2884:
+	case CHIP_ID_EM28174:
+	default:
+		/*
+		 * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
+		 * but not enough for 44 Mbit DVB-C.
+		 */
+		packet_size = 752;
 	}
 
-	em28xx_coredbg("dvb max packet size=%d\n", packet_size);
 	return packet_size;
 }
 EXPORT_SYMBOL_GPL(em28xx_isoc_dvb_max_packetsize);
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index ab8a740..e5916de 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -167,6 +167,11 @@ static int start_streaming(struct em28xx_dvb *dvb)
 		return rc;
 
 	max_dvb_packet_size = em28xx_isoc_dvb_max_packetsize(dev);
+	if (max_dvb_packet_size < 0)
+		return max_dvb_packet_size;
+	dprintk(1, "Using %d buffers each with %d bytes\n",
+		EM28XX_DVB_NUM_BUFS,
+		max_dvb_packet_size);
 
 	return em28xx_init_isoc(dev, EM28XX_DVB_MAX_PACKETS,
 				EM28XX_DVB_NUM_BUFS, max_dvb_packet_size,
-- 
1.7.1


