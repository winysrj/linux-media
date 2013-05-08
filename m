Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:58960 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3EHNTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:19:39 -0400
Received: by mail-ea0-f175.google.com with SMTP id q10so922240eaj.20
        for <linux-media@vger.kernel.org>; Wed, 08 May 2013 06:19:38 -0700 (PDT)
Received: from gears (cable-178-148-169-89.dynamic.sbb.rs. [178.148.169.89])
        by mx.google.com with ESMTPSA id x41sm36632844eey.17.2013.05.08.06.19.36
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 08 May 2013 06:19:37 -0700 (PDT)
Date: Wed, 8 May 2013 15:19:30 +0200
From: Zoran Turalija <zoran.turalija@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] stb0899: allow minimum symbol rate of 1000000
Message-ID: <20130508131930.GA27051@gears>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes minimum symbol rate driver capabilities on par with
windows driver, and allows tuning on linux to transponders that
have symbol rate below 5000000, too.

Patch was tested successfully on Eutelsat 16A transponders that
became reachable with it (1000000 < symbol rate < 5000000):

      * DVB/S  12507050 V  2532000 3/4
      * DVB/S2 12574000 V  4355000 3/4 8PSK
      * DVB/S  12593000 V  2500000 2/3
      * DVB/S  12596940 V  2848000 2/3
      * DVB/S  12600750 V  2500000 1/2
      * DVB/S  12675590 H  4248000 3/4

Signed-off-by: Zoran Turalija <zoran.turalija@gmail.com>
---
 stb0899_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stb0899_drv.c b/stb0899_drv.c
index cc278b3..527f5c3 100644
--- a/stb0899_drv.c
+++ b/stb0899_drv.c
@@ -1581,7 +1581,7 @@ static struct dvb_frontend_ops stb0899_ops = {
 		.frequency_max 		= 2150000,
 		.frequency_stepsize	= 0,
 		.frequency_tolerance	= 0,
-		.symbol_rate_min 	=  5000000,
+		.symbol_rate_min 	=  1000000,
 		.symbol_rate_max 	= 45000000,
 
 		.caps 			= FE_CAN_INVERSION_AUTO	|
-- 
1.8.1.2


-- 
Kind regards,
Zoran Turalija
