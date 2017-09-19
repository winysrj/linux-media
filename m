Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35709
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751227AbdISNmr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:42:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 4/6] media: dvb_frontend.h: fix alignment at the cache properties
Date: Tue, 19 Sep 2017 10:42:36 -0300
Message-Id: <0db9ab598c0c7cbcb4324efbc990331ea00f11cb.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are too much tabs on several properties, for no good
reason. That sounds confusing while reading the struct, so
adjust them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 1bdeb10f0d78..d273ed2f72c9 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -557,15 +557,15 @@ struct dtv_frontend_properties {
 
 	enum fe_sec_voltage	voltage;
 	enum fe_sec_tone_mode	sectone;
-	enum fe_spectral_inversion	inversion;
-	enum fe_code_rate		fec_inner;
+	enum fe_spectral_inversion inversion;
+	enum fe_code_rate	fec_inner;
 	enum fe_transmit_mode	transmission_mode;
 	u32			bandwidth_hz;	/* 0 = AUTO */
 	enum fe_guard_interval	guard_interval;
-	enum fe_hierarchy		hierarchy;
+	enum fe_hierarchy	hierarchy;
 	u32			symbol_rate;
-	enum fe_code_rate		code_rate_HP;
-	enum fe_code_rate		code_rate_LP;
+	enum fe_code_rate	code_rate_HP;
+	enum fe_code_rate	code_rate_LP;
 
 	enum fe_pilot		pilot;
 	enum fe_rolloff		rolloff;
-- 
2.13.5
