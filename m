Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63350 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429Ab1LFOex (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 09:34:53 -0500
Received: by eeaq14 with SMTP id q14so2938840eea.19
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 06:34:52 -0800 (PST)
Message-ID: <4EDE2809.1040406@gmail.com>
Date: Tue, 06 Dec 2011 15:34:49 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
References: <4EDE27A0.8060406@gmail.com>
In-Reply-To: <4EDE27A0.8060406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

xc3028: force reload of DTV7 firmware in VHF band as DTV78 firmware is
not working with bw=7 MHz.
The patch is effective only with Zarlink demodulators.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c
b/drivers/media/common/tuners/tuner-xc2028.c
index e531267..d92f862 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1129,7 +1129,8 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 			priv->ctrl.vhfbw7 = 1;
 		else
 			priv->ctrl.uhfbw8 = 0;
-		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
+		type |= (priv->ctrl.demod != XC3028_FE_ZARLINK456 &&
+		   priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
 		type |= F8MHZ;
 		break;
 	case BANDWIDTH_6_MHZ:
-- 
1.7.0.4
