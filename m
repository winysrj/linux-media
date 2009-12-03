Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48921 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZLCN5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 08:57:03 -0500
Message-ID: <4B17C3AE.6070207@gmail.com>
Date: Thu, 03 Dec 2009 21:57:02 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-next@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] atbm8830: replace 64-bit division and floating point usage
References: <20091130175346.3f3345ed.sfr@canb.auug.org.au>	<4B1409D9.1050901@oracle.com> <20091202100406.e25b2322.randy.dunlap@oracle.com>
In-Reply-To: <20091202100406.e25b2322.randy.dunlap@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------000707020409050203010201"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000707020409050203010201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Randy Dunlap wrote:
> On Mon, 30 Nov 2009 10:07:21 -0800 Randy Dunlap wrote:
> 
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20091127:
>>>
>>> The v4l-dvb tree lost its conflict.
>>
>> on i386 (X86_32):
>>
>> a 'double' variable is used, causing:
>>
>> ERROR: "__floatunsidf" [drivers/media/common/tuners/max2165.ko] undefined!
>> ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
>> ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!
> 
> 
> linux-next-20091202:
> 
> still have this one (above) and similar with
> drivers/media/dvb/frontends/atbm8830.c:
> 
> drivers/built-in.o: In function `atbm8830_init':
> atbm8830.c:(.text+0x9012f9): undefined reference to `__udivdi3'
> atbm8830.c:(.text+0x901384): undefined reference to `__floatunsidf'
> atbm8830.c:(.text+0x901395): undefined reference to `__muldf3'
> atbm8830.c:(.text+0x9013a5): undefined reference to `__floatunsidf'
> atbm8830.c:(.text+0x9013b2): undefined reference to `__divdf3'
> atbm8830.c:(.text+0x9013c3): undefined reference to `__muldf3'
> atbm8830.c:(.text+0x9013cd): undefined reference to `__fixunsdfsi'
> 
> ---
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This patch replace 64-bit division by do_div() macro and remove usage of 
floating point variable

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

--------------000707020409050203010201
Content-Type: text/x-patch;
 name="atbm8830_32bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atbm8830_32bit.patch"

diff --git a/linux/drivers/media/dvb/frontends/atbm8830.c b/linux/drivers/media/dvb/frontends/atbm8830.c
--- a/linux/drivers/media/dvb/frontends/atbm8830.c
+++ b/linux/drivers/media/dvb/frontends/atbm8830.c
@@ -19,6 +19,7 @@
  *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <asm/div64.h>
 #include "dvb_frontend.h"
 
 #include "atbm8830.h"
@@ -102,8 +103,12 @@
 static int set_osc_freq(struct atbm_state *priv, u32 freq /*in kHz*/)
 {
 	u32 val;
+	u64 t;
 
-	val = (u64)0x100000 * freq / 30400;
+	/* 0x100000 * freq / 30.4MHz */
+	t = (u64)0x100000 * freq;
+	do_div(t, 30400);
+	val = t;
 
 	atbm8830_write_reg(priv, REG_OSC_CLK, val);
 	atbm8830_write_reg(priv, REG_OSC_CLK + 1, val >> 8);
@@ -116,14 +121,18 @@
 {
 	
 	u32 fs = priv->config->osc_clk_freq;
-	double t;
+	u64 t;
 	u32 val;
 	u8 dat;
 
-	t = 2 * 3.141593 * (freq - fs) / fs * (1 << 22);
-	val = t;
+	if (freq != 0) {
+		/* 2 * PI * (freq - fs) / fs * (2 ^ 22) */
+		t = (u64) 2 * 31416 * (freq - fs);
+		t <<= 22;
+		do_div(t, fs);
+		do_div(t, 1000);
+		val = t;
 
-	if (freq != 0) {
 		atbm8830_write_reg(priv, REG_TUNER_BASEBAND, 1);
 		atbm8830_write_reg(priv, REG_IF_FREQ, val);
 		atbm8830_write_reg(priv, REG_IF_FREQ+1, val >> 8);

--------------000707020409050203010201--
