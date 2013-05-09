Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50400 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIJNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 05:13:09 -0400
Received: by mail-ee0-f41.google.com with SMTP id d4so366776eek.28
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 02:13:07 -0700 (PDT)
Received: from gears (cable-178-148-169-89.dynamic.sbb.rs. [178.148.169.89])
        by mx.google.com with ESMTPSA id bj12sm2860797eeb.8.2013.05.09.02.13.05
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 09 May 2013 02:13:06 -0700 (PDT)
Date: Thu, 9 May 2013 11:13:00 +0200
From: Zoran Turalija <zoran.turalija@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] stb0899: allow minimum symbol rate of 1000000
Message-ID: <20130509091300.GA32595@gears>
References: <20130508131930.GA27051@gears>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20130508131930.GA27051@gears>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 03:19:30PM +0200, Zoran Turalija wrote:
> This makes minimum symbol rate driver capabilities on par with
> windows driver, and allows tuning on linux to transponders that
> have symbol rate below 5000000, too.

Looks like product datasheets for tuners containing STB0899 are
suggesting specification for min. symbol rate of 2MS/s.

Some specs found here, all suggesting 2MS/s for min. symbol rate:

    Comtech DVBS2-6899
      http://comtech.sg1002.myweb.hinet.net/pdf/dvbs2-6899.pdf

    TechniSat SkyStar HD2
      http://www.scaistar.com/skystar2/skystarhd2.htm

    Azurewave AD-SP400
      http://www.pulsat.com/products/AzureWave-AD%252dSP400-High-Definition-PC-Card.html

New patch attached.

-- 
Kind regards,
Zoran Turalija

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-media-stb0899-allow-minimum-symbol-rate-of-2MS-s.patch"

>From 9cd352d8cdcdac7e63064ec2ed0e05e1e446d1ea Mon Sep 17 00:00:00 2001
From: Zoran Turalija <zoran.turalija@gmail.com>
Date: Wed, 8 May 2013 13:50:36 +0200
Subject: [PATCH] [media] stb0899: allow minimum symbol rate of 2MS/s

This makes minimum symbol rate driver capabilities on par with some
accessible datasheet specifications*, and allows tuning on linux to
transponders that have symbol rate between 2000000-5000000, too.

Patch was tested successfully on Eutelsat 16A transponders that
became reachable with it (2000000 < symbol rate < 5000000):

      * DVB/S  12507050 V  2532000 3/4
      * DVB/S2 12574000 V  4355000 3/4 8PSK
      * DVB/S  12593000 V  2500000 2/3
      * DVB/S  12596940 V  2848000 2/3
      * DVB/S  12600750 V  2500000 1/2
      * DVB/S  12675590 H  4248000 3/4

(*) Datasheet: http://comtech.sg1002.myweb.hinet.net/pdf/dvbs2-6899.pdf
        Maximum Symbol Rate
        QPSK/LDPC/PCH: 20-30Mbps
        8PSK/LDPC/BCH: 10-30Mbps
        DVB: 2-45Mbps
             ^--------- min. symbol rate

Signed-off-by: Zoran Turalija <zoran.turalija@gmail.com>
---
 stb0899_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stb0899_drv.c b/stb0899_drv.c
index cc278b3..b3ccd3d 100644
--- a/stb0899_drv.c
+++ b/stb0899_drv.c
@@ -1581,7 +1581,7 @@ static struct dvb_frontend_ops stb0899_ops = {
 		.frequency_max 		= 2150000,
 		.frequency_stepsize	= 0,
 		.frequency_tolerance	= 0,
-		.symbol_rate_min 	=  5000000,
+		.symbol_rate_min 	=  2000000,
 		.symbol_rate_max 	= 45000000,
 
 		.caps 			= FE_CAN_INVERSION_AUTO	|
-- 
1.8.1.2


--4Ckj6UjgE2iN1+kY--
