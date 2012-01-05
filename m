Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab2AEBBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:09 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05118ga002485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 22/47] [media] mt2063: Use linux default max function
Date: Wed,  4 Jan 2012 23:00:33 -0200
Message-Id: <1325725258-27934-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   34 +++-------------------------------
 1 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 6c73bfd..8662007 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -953,34 +953,6 @@ static u32 MT2063_gcd(u32 u, u32 v)
 
 /****************************************************************************
 **
-**  Name: umax
-**
-**  Description:    Implements a simple maximum function for unsigned numbers.
-**                  Implemented as a function rather than a macro to avoid
-**                  multiple evaluation of the calling parameters.
-**
-**  Parameters:     a, b     - Values to be compared
-**
-**  Global:         None
-**
-**  Returns:        larger of the input values.
-**
-**  Dependencies:   None.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   06-02-2004    JWS    Original
-**
-****************************************************************************/
-static u32 MT2063_umax(u32 a, u32 b)
-{
-	return (a >= b) ? a : b;
-}
-
-/****************************************************************************
-**
 **  Name: IsSpurInBand
 **
 **  Description:    Checks to see if a spur will be present within the IF's
@@ -1037,11 +1009,11 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	 ** gcd-based scale factor or f_Scale.
 	 */
 	lo_gcd = MT2063_gcd(f_LO1, f_LO2);
-	gd_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, d), f_Scale);
+	gd_Scale = max((u32) MT2063_gcd(lo_gcd, d), f_Scale);
 	hgds = gd_Scale / 2;
-	gc_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, c), f_Scale);
+	gc_Scale = max((u32) MT2063_gcd(lo_gcd, c), f_Scale);
 	hgcs = gc_Scale / 2;
-	gf_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, f), f_Scale);
+	gf_Scale = max((u32) MT2063_gcd(lo_gcd, f), f_Scale);
 	hgfs = gf_Scale / 2;
 
 	n0 = DIV_ROUND_UP(f_LO2 - d, f_LO1 - f_LO2);
-- 
1.7.7.5

