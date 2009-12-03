Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45317 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZLCNyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 08:54:24 -0500
Message-ID: <4B17C311.6050500@gmail.com>
Date: Thu, 03 Dec 2009 21:54:25 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-next@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] max2165 32bit build patch
References: <20091130175346.3f3345ed.sfr@canb.auug.org.au>	<4B1409D9.1050901@oracle.com> <20091202100406.e25b2322.randy.dunlap@oracle.com>
In-Reply-To: <20091202100406.e25b2322.randy.dunlap@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------060404090507030301090501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060404090507030301090501
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

This patch drops usage of floating point variable for 32bit build

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

--------------060404090507030301090501
Content-Type: text/x-patch;
 name="max2165_no_float.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="max2165_no_float.patch"

diff --git a/linux/drivers/media/common/tuners/max2165.c b/linux/drivers/media/common/tuners/max2165.c
--- a/linux/drivers/media/common/tuners/max2165.c
+++ b/linux/drivers/media/common/tuners/max2165.c
@@ -193,7 +193,7 @@
 {
 	u8 tf;
 	u8 tf_ntch;
-	double t;
+	u32 t;
 	u32 quotient, fraction;
 
 	/* Set PLL divider according to RF frequency */
@@ -217,9 +217,6 @@
 	t += (priv->tf_balun_hi_ref - priv->tf_balun_low_ref)
 		* (freq / 1000 - 470000) / (780000 - 470000);
 
-#if 0
-	tf = t + 0.5; /* round up */
-#endif
 	tf = t;
 	dprintk("tf = %X\n", tf);
 	tf |= tf_ntch << 4;


--------------060404090507030301090501--
