Return-path: <linux-media-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:56642 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbcENR3U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 13:29:20 -0400
Date: Sat, 14 May 2016 18:01:26 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] Fix RC5 decoding with Fintek CIR chipset
Message-ID: <20160514170126.GU14068@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix RC5 decoding with Fintek CIR chipset

Commit e87b540be2dd02552fb9244d50ae8b4e4619a34b tightened up the RC5
decoding by adding a check for trailing silence to ensure a valid RC5
command had been received. Unfortunately the trailer length checked was
10 units and the Fintek CIR device does not want to provide details of a
space longer than 6350us. This meant that RC5 remotes working on a
Fintek setup on 3.16 failed on 3.17 and later. Fix this by shortening
the trailer check to 6 units (allowing for a previous space in the
received remote command).

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=117221
Cc: stable@vger.kernel.org

-----
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 6ffe776..a0fd4e6 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -29,7 +29,7 @@
 #define RC5_BIT_START		(1 * RC5_UNIT)
 #define RC5_BIT_END		(1 * RC5_UNIT)
 #define RC5X_SPACE		(4 * RC5_UNIT)
-#define RC5_TRAILER		(10 * RC5_UNIT) /* In reality, approx 100 */
+#define RC5_TRAILER		(6 * RC5_UNIT) /* In reality, approx 100 */
 
 enum rc5_state {
 	STATE_INACTIVE,
-----

J.

-- 
What did the first punk rock girl wear to your school?
