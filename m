Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:59585 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab2ASSLv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 13:11:51 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id q0JHe0QN027599
	for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 18:40:00 +0100
Message-ID: <4F18555D.3000205@tvdr.de>
Date: Thu, 19 Jan 2012 18:39:41 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] stb0899: fix the limits for signal strength values
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stb0899_read_signal_strength() adds an offset to the result of the table lookup.
That offset must correspond to the lowest value in the lookup table, to make sure
the result doesn't get below 0, which would mean a "very high" value since the
parameter is unsigned.
'strength' and 'snr' need to be initialized to 0 to make sure they have a
defined result in case there is no "internal->lock".

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>

--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:54:32.000000000 +0200
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:23:00.000000000 +0200
@@ -67,7 +67,7 @@
   * Crude linear extrapolation below -84.8dBm and above -8.0dBm.
   */
  static const struct stb0899_tab stb0899_dvbsrf_tab[] = {
-       { -950, -128 },
+       { -750, -128 },
         { -748,  -94 },
         { -745,  -92 },
         { -735,  -90 },
@@ -131,7 +131,7 @@
         { -730, 13645 },
         { -750, 13909 },
         { -766, 14153 },
-       { -999, 16383 }
+       { -950, 16383 }
  };

  /* DVB-S2 Es/N0 quant in dB/100 vs read value * 100*/
@@ -964,6 +964,7 @@

         int val;
         u32 reg;
+       *strength = 0;
         switch (state->delsys) {
         case SYS_DVBS:
         case SYS_DSS:
@@ -987,7 +988,7 @@
                         val = STB0899_GETFIELD(IF_AGC_GAIN, reg);

                         *strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
-                       *strength += 750;
+                       *strength += 950;
                         dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
                                 val & 0x3fff, *strength);
                 }
@@ -1009,6 +1010,7 @@
         u8 buf[2];
         u32 reg;

+       *snr = 0;
         reg  = stb0899_read_reg(state, STB0899_VSTATUS);
         switch (state->delsys) {
         case SYS_DVBS:
