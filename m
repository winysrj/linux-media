Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0JHA07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 20:26:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o980Qxrd023449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:26:59 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o980PriR021715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:26:58 -0400
Date: Thu, 7 Oct 2010 21:25:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L/DVB: cx231xx: remove some unused functions
Message-ID: <20101007212546.478c5d5b@pedra>
In-Reply-To: <cover.1286497447.git.mchehab@redhat.com>
References: <cover.1286497447.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This file came originally from cx23885 driver. Some functions aren't
used. Now that they are declared as static, we have those errors:

drivers/media/video/cx231xx/cx231xx-417.c:615: warning: ‘mc417_gpio_set’ defined but not used
drivers/media/video/cx231xx/cx231xx-417.c:625: warning: ‘mc417_gpio_clear’ defined but not used
drivers/media/video/cx231xx/cx231xx-417.c:635: warning: ‘mc417_gpio_enable’ defined but not used

As they're not used, just remove them. If needed, they can be restored from
the git logs or from the cx23885 driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index 2dbad82..e456b97 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -612,39 +612,6 @@ static int mc417_memory_read(struct cx231xx *dev, u32 address, u32 *value)
 	return ret;
 }
 
-static void mc417_gpio_set(struct cx231xx *dev, u32 mask)
-{
-	u32 val;
-
-	/* Set the gpio value */
-	mc417_register_read(dev, 0x900C, &val);
-	val |= (mask & 0x000ffff);
-	mc417_register_write(dev, 0x900C, val);
-}
-
-static void mc417_gpio_clear(struct cx231xx *dev, u32 mask)
-{
-	u32 val;
-
-	/* Clear the gpio value */
-	mc417_register_read(dev, 0x900C, &val);
-	val &= ~(mask & 0x0000ffff);
-	mc417_register_write(dev, 0x900C, val);
-}
-
-static void mc417_gpio_enable(struct cx231xx *dev, u32 mask, int asoutput)
-{
-	u32 val;
-
-	/* Enable GPIO direction bits */
-	mc417_register_read(dev, 0x9020, &val);
-	if (asoutput)
-		val |= (mask & 0x0000ffff);
-	else
-		val &= ~(mask & 0x0000ffff);
-
-	mc417_register_write(dev, 0x9020, val);
-}
 /* ------------------------------------------------------------------ */
 
 /* MPEG encoder API */
-- 
1.7.1

