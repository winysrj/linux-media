Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:44159 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab0BCUjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:39:21 -0500
Message-ID: <4B69DEDA.3020200@arcor.de>
Date: Wed, 03 Feb 2010 21:38:50 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 14/15] -  zl10353
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/media/dvb/frontends/zl10353.h
+++ b/drivers/media/dvb/frontends/zl10353.h
@@ -45,6 +45,8 @@ struct zl10353_config
 	/* clock control registers (0x51-0x54) */
 	u8 clock_ctl_1;  /* default: 0x46 */
 	u8 pll_0;        /* default: 0x15 */
+	
+	int tm6000:1;
 };
 
 #if defined(CONFIG_DVB_ZL10353) || (defined(CONFIG_DVB_ZL10353_MODULE) && defined(MODULE))

-- 
Stefan Ringel <stefan.ringel@arcor.de>

