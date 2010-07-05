Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0GEW3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 18:29:13 -0400
Message-ID: <4C325CB9.7080108@redhat.com>
Date: Mon, 05 Jul 2010 19:29:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jay Guillory <Jay.Guillory@conexant.com>
Subject: Re: [cx231xx 1/2] Added support for s5h1432 demod
References: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-06-2010 01:25, Palash Bandyopadhyay escreveu:
> From 53df9742b92902b5fa9d28b2dcc949cb495725a5 Mon Sep 17 00:00:00 2001
> Message-Id: <53df9742b92902b5fa9d28b2dcc949cb495725a5.1276143429.git.palash.bandyopadhyay@conexant.com>
> From: palash <palash.bandyopadhyay@conexant.com>
> Date: Wed, 9 Jun 2010 21:13:17 -0700
> Subject: [cx231xx 1/2] Added support for s5h1432 demod
> To: linux-media@vger.kernel.org
> 
> Signed-off-by: palash <palash.bandyopadhyay@conexant.com>

There are lots of CodingStyle issues that need fixes. Even fixing the bad whitespacing
with a script, there are still lots of other issues, as pointed by scripts/checkpatch.pl:

WARNING: please write a paragraph that describes the config symbol fully
#60: FILE: drivers/media/dvb/frontends/Kconfig:264:
+       help

WARNING: suspect code indent for conditional statements (7, 15)
#130: FILE: drivers/media/dvb/frontends/s5h1432.c:52:
+       if (debug)              \
+	       printk(arg);    \

WARNING: suspect code indent for conditional statements (7, 15)
#145: FILE: drivers/media/dvb/frontends/s5h1432.c:67:
+       if (ret != 1)
+	       printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, "

WARNING: suspect code indent for conditional statements (7, 15)
#164: FILE: drivers/media/dvb/frontends/s5h1432.c:86:
+       if (ret != 2)
+	       printk(KERN_ERR "%s: readreg error (ret == %i)\n",

WARNING: unnecessary whitespace before a quoted newline
#256: FILE: drivers/media/dvb/frontends/s5h1432.c:178:
+	       printk(KERN_INFO "Default IFFreq %d :reg value = 0x%x \n",

WARNING: suspect code indent for conditional statements (7, 15)
#279: FILE: drivers/media/dvb/frontends/s5h1432.c:201:
+       if (p->frequency == state->current_frequency) {
+	       /*current_frequency = p->frequency;*/

WARNING: suspect code indent for conditional statements (7, 15)
#396: FILE: drivers/media/dvb/frontends/s5h1432.c:318:
+       for (i = 0; i < 0xFF; i++) {
+	       reg = s5h1432_readreg(state, S5H1432_I2C_TOP_ADDR, i);

WARNING: suspect code indent for conditional statements (7, 15)
#463: FILE: drivers/media/dvb/frontends/s5h1432.c:385:
+       if (state == NULL)
+	       goto error;

total: 0 errors, 8 warnings, 562 lines checked

patches/lmml_108408_cx231xx_1_2_added_support_for_s5h1432_demod.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please fix.

Cheers,
Mauro
