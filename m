Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3CXNhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 09:37:35 -0400
Date: Sun, 24 Mar 2013 10:37:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] em28xx: add support for em25xx i2c bus B
 read/write/check device operations
Message-ID: <20130324103729.0216bdce@redhat.com>
In-Reply-To: <514EF9EF.9050908@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
	<1364059632-29070-2-git-send-email-fschaefer.oss@googlemail.com>
	<20130324082253.54dfc1c1@redhat.com>
	<514EF9EF.9050908@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Mar 2013 14:04:47 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> ...
> 
> Am 24.03.2013 12:22, schrieb Mauro Carvalho Chehab:
> > Please stick with Kernel's coding style, as described on
> > Documentation/CodingStyle and on the common practices.
> >
> > Multi-line comments are like:
> > 	/*
> > 	 * Foo
> > 	 * bar
> > 	 */
> >
> > There are also a bunch of scripts/checkpatch.pl complains for this patch: 
> >
> > WARNING: please, no spaces at the start of a line
> > #69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
> > +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>$
> >
> > WARNING: space prohibited between function name and open parenthesis '('
> > #69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
> > +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
> >
> > WARNING: Avoid CamelCase: <Copyright>
> > #69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
> > +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
> >
> > WARNING: Avoid CamelCase: <Frank>
> > #69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
> > +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
> >
> > WARNING: Avoid CamelCase: <Sch>
> > #69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
> > +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
> 
> The "space prohibited between function name and open parenthesis" and
> "CamelCase" warnings are pure nonsense.
> The "spaces at start of a line thing" applies to the whole and
> licences/copyright headers of the em28xx driver.
> If you think we should change that - fine - but it really doesn't make
> sense to do this as part of this patch series.

The above complaints are because checkpatch doesn't like comments like:

/*
 FOO
 */

As it should be, instead:

 /*
  * FOO
  */

You can safely ignore all the above. It is not worth to fix the comments
there.

> 
> 
> > WARNING: quoted string split across lines
> > #97: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:298:
> > +			em28xx_warn("writing to i2c device at 0x%x failed "
> > +				    "(error=%i)\n", addr, ret);
> >
> > WARNING: quoted string split across lines
> > #101: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:302:
> > +			em28xx_warn("%i bytes write to i2c device at 0x%x "
> > +				    "requested, but %i bytes written\n",
> 
> Yes, these two are discussible.
> AFAIK, strings should not be split across lines to avoid breaking
> grepping for strings.
> In this case I decided for the "80 characters per line rule" instead,
> because grepping for strings containing placeholders IMHO doesn't make
> much sense.
> We do exactly the same in the existing i2c functions.

The "not break strings" rule is stronger. When the code was written, 
80 cols were a mandatory rule (and there was no checkpatch.pl). After
lots of discussions (with took years), we're all set about two points:

	- the 80 cols is a soft limit;

	- strings should not be broken. Linus explicitly pointed on that
time that he doesn't want to see strings broken, as it makes harder to 
grep for the printed messages when needed.

> 
> > WARNING: braces {} are not necessary for any arm of this statement
> > #110: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:311:
> > +	if (ret == 0x00) {
> > [...]
> > +	} else if (ret > 0) {
> > [...]
> >
> > WARNING: braces {} are not necessary for any arm of this statement
> > #156: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:357:
> > +	if (ret == 0x00) {
> > [...]
> > +	} else if (ret > 0) {
> > [...]
> >
> > WARNING: braces {} are not necessary for any arm of this statement
> > #190: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:391:
> > +	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> > [...]
> 
> The patch perfectly matches the kernel coding style rules here !?
> What do you want me to change ?
> Do you really think the code looks better without some of these braces ?

For sure it looks better without the braces. Braces should be used only
if there are multiple lines at the if chain.

> > WARNING: printk() should include KERN_ facility level
> > #199: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:400:
> > +			printk(" no device\n");
> 
> I only moved this piece of code around, but yes, that should really be
> fixed !

Where you're just moving the code, no.

> 
> > WARNING: braces {} are not necessary for any arm of this statement
> > #211: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:412:
> > +	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> > [...]
> 
> See above.
> 
> > WARNING: printk() should include KERN_ facility level
> > #220: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:421:
> > +			printk(" %02x", msg.buf[byte]);
> 
> Same here, should indeed be fixed.
> 
> > WARNING: braces {} are not necessary for any arm of this statement
> > #236: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:437:
> > +	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
> > [...]
> > +	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> > [...]
> 
> See above.
> 
> Except for the two printk warnings, please tell me which changes you
> would like to see exactly.
> I will send an updated version of this series then.
> 
> Regards,
> Frank
> 
> > total: 0 errors, 14 warnings, 333 lines checked
> >
> > Your patch has style problems, please review.
> >
> > If any of these errors are false positives, please report
> > them to the maintainer, see CHECKPATCH in MAINTAINERS.
> >
> > PS.: I'll write a separate email if I find any non-coding style issue on
> > this patch series. Won't comment anymore about coding style, as I'm
> > assuming that you'll be fixing it on the other patches of this series
> > if needed.
> >
> > Regards,
> > Mauro
> 


-- 

Cheers,
Mauro
