Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:39783 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751000AbdISNJi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:09:38 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JD9UDA006048
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:36 +0100
Received: from mail-wr0-f198.google.com (mail-wr0-f198.google.com [209.85.128.198])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc01jce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:36 +0100
Received: by mail-wr0-f198.google.com with SMTP id d6so3751358wrd.7
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 06:09:36 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
Date: Tue, 19 Sep 2017 14:08:52 +0100
Message-Id: <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The existing fixed value of 16 worked for UYVY 720P60 over
2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
1080P60 needs 6 lanes at 594MHz).
It doesn't allow for lower resolutions to work as the FIFO
underflows.

Using a value of 300 works for all resolutions down to VGA60,
and the increase in frame delay is <4usecs for 1080P60 UYVY
(2.55usecs for RGB888).

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6b0fd07..7632daf 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1782,8 +1782,14 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	state->pdata.refclk_hz = clk_get_rate(refclk);
 	state->pdata.ddc5v_delay = DDC5V_DELAY_100_MS;
 	state->pdata.enable_hdcp = false;
-	/* A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz. */
-	state->pdata.fifo_level = 16;
+	/*
+	 * A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz,
+	 * but is insufficient for lower resolutions.
+	 * A value of 300 allows for resolutions down to VGA60 (and possibly
+	 * lower) to work, whilst still leaving the delay for 1080P60
+	 * stilll below 4usecs.
+	 */
+	state->pdata.fifo_level = 300;
 	/*
 	 * The PLL input clock is obtained by dividing refclk by pll_prd.
 	 * It must be between 6 MHz and 40 MHz, lower frequency is better.
-- 
2.7.4
