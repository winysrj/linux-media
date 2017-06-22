Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.187]:17300 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752455AbdFVDVD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 23:21:03 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id B7B3E12209D
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 22:21:00 -0500 (CDT)
Date: Wed, 21 Jun 2017 22:20:59 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] tuners: mxl5005s: remove useless variable assignments
Message-ID: <20170622032059.GA4615@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Values assigned to variables Fmax and Fmin at lines 2740 and 2741 are
overwritten at lines 2754 and 2755 before they can be used. This makes
such variable assignments useless.

Addresses-Coverity-ID: 1226952
Addresses-Coverity-ID: 1226953
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/tuners/mxl5005s.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index 353744f..dd59c2c 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -2737,8 +2737,6 @@ static u16 MXL_TuneRF(struct dvb_frontend *fe, u32 RF_Freq)
 		status += MXL_ControlWrite(fe, TG_LO_DIVVAL,	0x0);
 		status += MXL_ControlWrite(fe, TG_LO_SELVAL,	0x7);
 		divider_val = 2 ;
-		Fmax = FmaxBin ;
-		Fmin = FminBin ;
 	}
 
 	/* TG_DIV_VAL */
-- 
2.5.0
