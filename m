Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117o2016626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/47] [media] mt2063: Remove internal version checks
Date: Wed,  4 Jan 2012 23:00:23 -0200
Message-Id: <1325725258-27934-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0c4ae7f..98bc2e2 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -6,14 +6,12 @@
 
 #include "mt2063.h"
 
-/*  Version of this module                          */
-#define MT2063_VERSION 10018	/*  Version 01.18 */
-
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 
 /* Internal structures and types */
 
+/* FIXME: we probably don't need these new FE get/set property types for tuner */
 #define DVBFE_TUNER_OPEN			99
 #define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
 #define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
@@ -118,8 +116,6 @@ module_param(verbose, int, 0644);
  *  check against this version number to make sure that
  *  it matches the version that the tuner driver knows about.
  */
-/* Version 010201 => 1.21 */
-#define MT2063_AVOID_SPURS_INFO_VERSION 010201
 
 /* DECT Frequency Avoidance */
 #define MT2063_DECT_AVOID_US_FREQS      0x00000001
@@ -497,7 +493,6 @@ struct MT2063_Info_t {
 	void *handle;
 	void *hUserData;
 	u32 address;
-	u32 version;
 	u32 tuner_id;
 	struct MT2063_AvoidSpursData_t AS_Data;
 	u32 f_IF1_actual;
@@ -3115,7 +3110,6 @@ static u32 MT2063_ReInit(void *h)
 
 	if (MT2063_NO_ERROR(status)) {
 		/*  Initialize the tuner state.  */
-		pInfo->version = MT2063_VERSION;
 		pInfo->tuner_id = pInfo->reg[MT2063_REG_PART_REV];
 		pInfo->AS_Data.f_ref = MT2063_REF_FREQ;
 		pInfo->AS_Data.f_if1_Center =
-- 
1.7.7.5

