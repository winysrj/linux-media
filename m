Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BMRdQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:33:16 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1DHXGJJ008295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:33:16 -0500
Received: from pedra (vpn-239-52.phx2.redhat.com [10.3.239.52])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1DHT5kP015438
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:33:15 -0500
Date: Sun, 13 Feb 2011 15:28:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] [media] cx231xx: Allow some boards to not use I2C port
 3
Message-ID: <20110213152855.2c2d90c8@pedra>
In-Reply-To: <cover.1297617986.git.mchehab@redhat.com>
References: <cover.1297617986.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some devices don't need to use it. So allow to just disable this logic.
Having it enabled on some devices cause power management to complain,
generating error -71.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index b80bccf..62843d3 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1271,6 +1271,8 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	int status = 0;
 	bool current_is_port_3;
 
+	if (dev->board.dont_use_port_3)
+		is_port_3 = false;
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
 				       PWR_CTL_EN, value, 4);
 	if (status < 0)
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index b72503d..e1c222b 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -357,6 +357,7 @@ struct cx231xx_board {
 	unsigned int valid:1;
 	unsigned int no_alt_vanc:1;
 	unsigned int external_av:1;
+	unsigned int dont_use_port_3:1;
 
 	unsigned char xclk, i2c_speed;
 
-- 
1.7.1


