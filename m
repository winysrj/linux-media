Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:38486 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbeAYLZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 06:25:20 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: magnus.damm@gmail.com, kuninori.morimoto.gx@renesas.com,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, linux-sh@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sh: clk: Relax clk rate match test
Date: Thu, 25 Jan 2018 12:24:53 +0100
Message-Id: <1516879493-24637-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When asking for a clk rate to be set, the sh core clock matches only
exact rate values against the calculated frequency table entries. If the
rate does not match exactly the test fails, and the whole frequency
table is walked, resulting in selection of the last entry, corresponding to
the lowest available clock rate.

Ie. when asking for a 10MHz clock rate on div6 clocks (ie. "video_clk" line),
the calculated clock frequency 10088572 Hz gets ignored, and the clock is
actually set to 5201920 Hz, which is the last available entry of the frequencies
table.

Relax the clock frequency match test, allowing selection of clock rates
immediately slower than the required one.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
Hello renesas lists,

I'm now working on handling frame rate for the ov7720 image sensor to have that
driver accepted as part of v4l2. The sensor is installed on on Migo-R board.
In order to properly calculate pixel clock and the framerate I noticed the
clock signal fed to the sensor from the SH7722 chip was always the lowest
available one.

This patch fixes the issues and allows me to properly select which clock
frequency supply to the sensor, which according to datasheet does not support
input clock frequencies slower than 10MHz (but works anyhow).

As all patches for SH architecture I wonder where they should be picked up from,
as SH seems not maintained at the moment.

Thanks
   j

---
 drivers/sh/clk/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
index 92863e3..d2cb94c 100644
--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -198,9 +198,12 @@ int clk_rate_table_find(struct clk *clk,
 {
 	struct cpufreq_frequency_table *pos;

-	cpufreq_for_each_valid_entry(pos, freq_table)
-		if (pos->frequency == rate)
-			return pos - freq_table;
+	cpufreq_for_each_valid_entry(pos, freq_table) {
+		if (pos->frequency > rate)
+			continue;
+
+		return pos - freq_table;
+	}

 	return -ENOENT;
 }
--
2.7.4
