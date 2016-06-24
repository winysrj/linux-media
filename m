Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbcFXPcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 13/19] dib0090: comment out the unused tables
Date: Fri, 24 Jun 2016 12:31:54 -0300
Message-Id: <cf47faca25e29ffb74c883675a9bada065d9ea10.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those tables are currently unused, so comment them out:

drivers/media/dvb-frontends/dib0090.c:852:18: warning: 'rf_ramp_pwm_sband' defined but not used [-Wunused-const-variable=]
 static const u16 rf_ramp_pwm_sband[] = {
                  ^~~~~~~~~~~~~~~~~
drivers/media/dvb-frontends/dib0090.c:800:18: warning: 'bb_ramp_pwm_boost' defined but not used [-Wunused-const-variable=]
 static const u16 bb_ramp_pwm_boost[] = {
                  ^~~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dib0090.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index d879dc0607f4..14c403254fe0 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -797,6 +797,8 @@ static const u16 bb_ramp_pwm_normal[] = {
 	(0  << 9) | 400, /* BB_RAMP6 */
 };
 
+#if 0
+/* Currently unused */
 static const u16 bb_ramp_pwm_boost[] = {
 	550, /* max BB gain in 10th of dB */
 	8, /* ramp_slope = 1dB of gain -> clock_ticks_per_db = clk_khz / ramp_slope -> BB_RAMP2 */
@@ -806,6 +808,7 @@ static const u16 bb_ramp_pwm_boost[] = {
 	(2  << 9) | 208, /* BB_RAMP5 = 29dB */
 	(0  << 9) | 440, /* BB_RAMP6 */
 };
+#endif
 
 static const u16 rf_ramp_pwm_cband[] = {
 	314, /* max RF gain in 10th of dB */
@@ -849,6 +852,8 @@ static const u16 rf_ramp_pwm_uhf[] = {
 	(0  << 10) | 580, /* GAIN_4_2, LNA 4 */
 };
 
+#if 0
+/* Currently unused */
 static const u16 rf_ramp_pwm_sband[] = {
 	253, /* max RF gain in 10th of dB */
 	38, /* ramp_slope = 1dB of gain -> clock_ticks_per_db = clk_khz / ramp_slope -> RF_RAMP2 */
@@ -862,6 +867,7 @@ static const u16 rf_ramp_pwm_sband[] = {
 	(0  << 10) | 0, /* GAIN_4_1, LNA 4 = 0dB */
 	(0  << 10) | 0, /* GAIN_4_2, LNA 4 */
 };
+#endif
 
 struct slope {
 	s16 range;
-- 
2.7.4


