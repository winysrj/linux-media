Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64602 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2COReM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:34:12 -0400
Received: by eekc41 with SMTP id c41so1790106eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 10:34:11 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: crope@iki.fi, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/3] em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
Date: Thu, 15 Mar 2012 18:33:48 +0100
Message-Id: <1331832829-4580-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the LNA amplifier also for DVB-T (like for DVB-T2 and DVB-C);
this greatly improves reception of weak signals without affecting the reception
of the strong ones.

Experimental data (collected with the mipsel STB) on the weakest frequencies
available in my area:

LNA OFF:

MUX          level   BER     picture

RAI mux 4    72%     32000   corrupted
TIMB 2       75%     14      OK
TVA Vicenza  68%     32000   corrupted
RAI mux 2    78%     14      OK

LNA ON:

MUX          level   BER     picture

RAI mux 4    73%     1500    OK
TIMB 2       76%     0       OK
TVA Vicenza  69%     0       OK
RAI mux 2    79%     0       OK

Moreover, with LNA enabled, the PCTV 290e was able to pick up 2 new frequencies
matching the integrated tuner of my Panasonic G20 TV, which is really good.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index fbd9010..4917b71 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -502,7 +502,8 @@ static struct cxd2820r_config em28xx_cxd2820r_config = {
 	.i2c_address = (0xd8 >> 1),
 	.ts_mode = CXD2820R_TS_SERIAL,
 
-	/* enable LNA for DVB-T2 and DVB-C */
+	/* enable LNA for DVB-T, DVB-T2 and DVB-C */
+	.gpio_dvbt[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
 	.gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
 	.gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
 };
-- 
1.7.5.4

