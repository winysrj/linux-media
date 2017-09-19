Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:60228 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbdISNJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:09:42 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JD9O9L023987
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:41 +0100
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg1jgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:41 +0100
Received: by mail-wm0-f72.google.com with SMTP id i131so3879562wma.1
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 06:09:41 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 3/3] [media] tc358743: Add support for 972Mbit/s link freq.
Date: Tue, 19 Sep 2017 14:08:53 +0100
Message-Id: <6de475044437c01c14429ac20292e5c29fdd39f9.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds register setups for running the CSI lanes at 972Mbit/s,
which allows 1080P50 UYVY down 2 lanes.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 47 +++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 7632daf..dcc100e 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1809,6 +1809,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	/*
 	 * The CSI bps per lane must be between 62.5 Mbps and 1 Gbps.
 	 * The default is 594 Mbps for 4-lane 1080p60 or 2-lane 720p60.
+	 * 972 Mbps allows 1080P50 UYVY over 2-lane.
 	 */
 	bps_pr_lane = 2 * endpoint->link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
@@ -1821,23 +1822,41 @@ static int tc358743_probe_of(struct tc358743_state *state)
 			       state->pdata.refclk_hz * state->pdata.pll_prd;
 
 	/*
-	 * FIXME: These timings are from REF_02 for 594 Mbps per lane (297 MHz
-	 * link frequency). In principle it should be possible to calculate
+	 * FIXME: These timings are from REF_02 for 594 or 972 Mbps per lane
+	 * (297 MHz or 495 MHz link frequency).
+	 * In principle it should be possible to calculate
 	 * them based on link frequency and resolution.
 	 */
-	if (bps_pr_lane != 594000000U)
+	switch (bps_pr_lane) {
+	default:
 		dev_warn(dev, "untested bps per lane: %u bps\n", bps_pr_lane);
-	state->pdata.lineinitcnt = 0xe80;
-	state->pdata.lptxtimecnt = 0x003;
-	/* tclk-preparecnt: 3, tclk-zerocnt: 20 */
-	state->pdata.tclk_headercnt = 0x1403;
-	state->pdata.tclk_trailcnt = 0x00;
-	/* ths-preparecnt: 3, ths-zerocnt: 1 */
-	state->pdata.ths_headercnt = 0x0103;
-	state->pdata.twakeup = 0x4882;
-	state->pdata.tclk_postcnt = 0x008;
-	state->pdata.ths_trailcnt = 0x2;
-	state->pdata.hstxvregcnt = 0;
+	case 594000000U:
+		state->pdata.lineinitcnt = 0xe80;
+		state->pdata.lptxtimecnt = 0x003;
+		/* tclk-preparecnt: 3, tclk-zerocnt: 20 */
+		state->pdata.tclk_headercnt = 0x1403;
+		state->pdata.tclk_trailcnt = 0x00;
+		/* ths-preparecnt: 3, ths-zerocnt: 1 */
+		state->pdata.ths_headercnt = 0x0103;
+		state->pdata.twakeup = 0x4882;
+		state->pdata.tclk_postcnt = 0x008;
+		state->pdata.ths_trailcnt = 0x2;
+		state->pdata.hstxvregcnt = 0;
+		break;
+	case 972000000U:
+		state->pdata.lineinitcnt = 0xFA0;
+		state->pdata.lptxtimecnt = 0x007;
+		/* tclk-preparecnt: 6, tclk-zerocnt: 40 */
+		state->pdata.tclk_headercnt = 0x2806;
+		state->pdata.tclk_trailcnt = 0x00;
+		/* ths-preparecnt: 3, ths-zerocnt: 1 */
+		state->pdata.ths_headercnt = 0x0806;
+		state->pdata.twakeup = 0x4268;
+		state->pdata.tclk_postcnt = 0x008;
+		state->pdata.ths_trailcnt = 0x5;
+		state->pdata.hstxvregcnt = 0;
+		break;
+	}
 
 	state->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						    GPIOD_OUT_LOW);
-- 
2.7.4
