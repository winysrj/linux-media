Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:35248 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755310Ab2B1Sks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 13:40:48 -0500
Message-ID: <4F4D1FAC.5050703@gmx.de>
Date: Tue, 28 Feb 2012 19:40:44 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] stb0899: fixed reading of IF_AGC_GAIN register
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When reading IF_AGC_GAIN register a wrong value for the base address
register was used (STB0899_DEMOD instead of STB0899_S2DEMOD). That
lead to a wrong signal strength value on DVB-S2 transponders.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
---
  drivers/media/dvb/frontends/stb0899_drv.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_drv.c 
b/drivers/media/dvb/frontends/stb0899_drv.c
index 4a58afc..a2e9eba 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -983,7 +983,7 @@ static int stb0899_read_signal_strength(struct 
dvb_frontend *fe, u16 *strength)
  		break;
  	case SYS_DVBS2:
  		if (internal->lock) {
-			reg = STB0899_READ_S2REG(STB0899_DEMOD, IF_AGC_GAIN);
+			reg = STB0899_READ_S2REG(STB0899_S2DEMOD, IF_AGC_GAIN);
  			val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
   			*strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, 
ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
-- 
1.7.2.5

