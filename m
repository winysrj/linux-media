Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:46317 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbcEWTJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 15:09:21 -0400
Date: Mon, 23 May 2016 21:01:06 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] Fix RC5 decoding with Fintek CIR chipset
Message-ID: <20160523190106.GC6526@hardeman.nu>
References: <20160514170126.GU14068@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160514170126.GU14068@earth.li>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 14, 2016 at 06:01:26PM +0100, Jonathan McDowell wrote:
>Fix RC5 decoding with Fintek CIR chipset
>
>Commit e87b540be2dd02552fb9244d50ae8b4e4619a34b tightened up the RC5
>decoding by adding a check for trailing silence to ensure a valid RC5
>command had been received. Unfortunately the trailer length checked was
>10 units and the Fintek CIR device does not want to provide details of a
>space longer than 6350us. This meant that RC5 remotes working on a
>Fintek setup on 3.16 failed on 3.17 and later. Fix this by shortening
>the trailer check to 6 units (allowing for a previous space in the
>received remote command).
>
>Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David Härdeman <david@hardeman.nu>

>Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=117221
>Cc: stable@vger.kernel.org
>
>-----
>diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
>index 6ffe776..a0fd4e6 100644
>--- a/drivers/media/rc/ir-rc5-decoder.c
>+++ b/drivers/media/rc/ir-rc5-decoder.c
>@@ -29,7 +29,7 @@
> #define RC5_BIT_START		(1 * RC5_UNIT)
> #define RC5_BIT_END		(1 * RC5_UNIT)
> #define RC5X_SPACE		(4 * RC5_UNIT)
>-#define RC5_TRAILER		(10 * RC5_UNIT) /* In reality, approx 100 */
>+#define RC5_TRAILER		(6 * RC5_UNIT) /* In reality, approx 100 */
> 
> enum rc5_state {
> 	STATE_INACTIVE,
>-----
>
>J.
>
>-- 
>What did the first punk rock girl wear to your school?
>

-- 
David Härdeman
