Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AEi002503
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 38/47] [media] mt2063: Remove two unused temporary vars
Date: Wed,  4 Jan 2012 23:00:49 -0200
Message-Id: <1325725258-27934-39-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mt2063.c:1531:12: warning: variable 'ofout' set but not used [-Wunused-but-set-variable]
mt2063.c:1531:6: warning: variable 'ofin' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index b72105d..92653a9 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1528,7 +1528,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	u32 LO2;		/*  2nd LO register value           */
 	u32 Num2;		/*  Numerator for LO2 reg. value    */
 	u32 ofLO1, ofLO2;	/*  last time's LO frequencies      */
-	u32 ofin, ofout;	/*  last time's I/O frequencies     */
 	u8 fiffc = 0x80;	/*  FIFF center freq from tuner     */
 	u32 fiffof;		/*  Offset from FIFF center freq    */
 	const u8 LO1LK = 0x80;	/*  Mask for LO1 Lock bit           */
@@ -1549,9 +1548,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	 * Save original LO1 and LO2 register values
 	 */
 	ofLO1 = state->AS_Data.f_LO1;
-	ofLO2 = state->AS_Data.f_LO2;
-	ofin = state->AS_Data.f_in;
-	ofout = state->AS_Data.f_out;
+	ofLO2 = state->AS_Data.f_LO2; 
 
 	/*
 	 * Find and set RF Band setting
-- 
1.7.7.5

