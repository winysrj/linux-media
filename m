Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26338 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbbEUKSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 06:18:03 -0400
Date: Thu, 21 May 2015 18:16:36 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH linuxtv-media] cx24120: cx24120_calculate_ber_window() can be
 static
Message-ID: <20150521101636.GA92515@snb>
References: <201505211815.u8Tcv6qa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201505211815.u8Tcv6qa%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cx24120.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 2d46780..edff79a 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -803,7 +803,7 @@ static int cx24120_get_fec(struct dvb_frontend *fe)
 }
 
 /* Calculate ber window time */
-void cx24120_calculate_ber_window(struct cx24120_state *state, u32 rate)
+static void cx24120_calculate_ber_window(struct cx24120_state *state, u32 rate)
 {
 	struct dvb_frontend *fe = &state->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
