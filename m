Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34521 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760031Ab3LHWbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 14/18] m88ds3103: remove unneeded AGC from inittab
Date: Mon,  9 Dec 2013 00:31:31 +0200
Message-Id: <1386541895-8634-15-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Optimal AGC is highly depended on used RF tuner and due to that
it is already included to chip configuration. However, inittab
has default AGC value, which was later replaced by one from config.

Add also comment to all chip configuration options about default
values and if those are needed to set or not.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.h      | 14 ++++++++++++--
 drivers/media/dvb-frontends/m88ds3103_priv.h |  2 --
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index 287d62a..eaa5d10 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -26,26 +26,28 @@
 struct m88ds3103_config {
 	/*
 	 * I2C address
+	 * Default: none, must set
 	 * 0x68, ...
 	 */
 	u8 i2c_addr;
 
 	/*
 	 * clock
+	 * Default: none, must set
 	 * 27000000
 	 */
 	u32 clock;
 
 	/*
 	 * max bytes I2C provider is asked to write at once
-	 * Note: Buffer is taken from the stack currently!
-	 * Value must be set.
+	 * Default: none, must set
 	 * 33, 65, ...
 	 */
 	u16 i2c_wr_max;
 
 	/*
 	 * TS output mode
+	 * Default: M88DS3103_TS_SERIAL
 	 */
 #define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
 #define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
@@ -58,16 +60,19 @@ struct m88ds3103_config {
 
 	/*
 	 * spectrum inversion
+	 * Default: 0
 	 */
 	u8 spec_inv:1;
 
 	/*
 	 * AGC polarity
+	 * Default: 0
 	 */
 	u8 agc_inv:1;
 
 	/*
 	 * clock output
+	 * Default: M88DS3103_CLOCK_OUT_DISABLED
 	 */
 #define M88DS3103_CLOCK_OUT_DISABLED        0
 #define M88DS3103_CLOCK_OUT_ENABLED         1
@@ -76,9 +81,14 @@ struct m88ds3103_config {
 
 	/*
 	 * DiSEqC envelope mode
+	 * Default: 0
 	 */
 	u8 envelope_mode:1;
 
+	/*
+	 * AGC configuration
+	 * Default: none, must set
+	 */
 	u8 agc;
 };
 
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 322db4d..80c5a25 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -57,7 +57,6 @@ static const struct m88ds3103_reg_val m88ds3103_dvbs_init_reg_vals[] = {
 	{0x30, 0x08},
 	{0x31, 0x40},
 	{0x32, 0x32},
-	{0x33, 0x35},
 	{0x35, 0xff},
 	{0x3a, 0x00},
 	{0x37, 0x10},
@@ -139,7 +138,6 @@ static const struct m88ds3103_reg_val m88ds3103_dvbs2_init_reg_vals[] = {
 	{0x27, 0x31},
 	{0x30, 0x08},
 	{0x32, 0x32},
-	{0x33, 0x35},
 	{0x35, 0xff},
 	{0x3a, 0x00},
 	{0x37, 0x10},
-- 
1.8.4.2

