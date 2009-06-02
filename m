Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46711 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755382AbZFBJeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2009 05:34:31 -0400
Date: Tue, 2 Jun 2009 10:34:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Simplified CONFIG_I2C=n interface.
Message-ID: <20090602093431.GA19390@rakim.wolfsonmicro.main>
References: <20090527070850.GA11221@linux-sh.org> <20090527091831.26b60d6d@hyperion.delvare> <20090527120140.GC1970@sirena.org.uk> <20090602091229.0810f54b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602091229.0810f54b@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 02, 2009 at 09:12:29AM +0200, Jean Delvare wrote:
> On Wed, 27 May 2009 13:01:40 +0100, Mark Brown wrote:

> > It's extremely common for devices like the CODECs and PMICs used in
> > embedded systems to have both I2C and SPI interfaces, selectable via a

> Can you please point me at a couple of affected drivers?

Most of the Wolfson CODECs in sound/soc/codecs are affected (more than
actually have the SPI code at the minute), probably a lot of the other
CODECs there too.  I'd expect most I2C devices in drivers/mfd will also
be affectd.  For anything with more than a few registers the tendency is
to have both options unless there's a hardware constraint.

> I would really expect all I2C-related code to be in one place of the
> driver (or even in a separate source file) and same for SPI-related
> code. Then surrounding one big block of code with an ifdef doesn't
> sound that difficult to read.

It's not a legibility issue, it's to do with people remembering to
handle all the cases.  It's a bit of a PITA but not the end of the
world - I'm mentioning this more because you were suggesting that a
driver that was still useful with I2C=n was unusual rather than anything
else.

> driver needs to be reviewed for the CONFIG_I2C=n case. If we add stubs
> all around to workaround the link breakage, this means the review never
> happens, so the code might as well build and link but not work properly
> or at least not be optimal. I wouldn't call this progress.

I can't really see a situation where things wouldn't work properly
beyond the current situation where I2C support can just be built out -
if nobody is running the code then that's a separate issue.

> What could be done, OTOH, is to surround all the function declarations
> in <linux/i2c.h> with a simple #ifdef CONFIG_I2C, so that mistakes are
> caught earlier (build time instead of link time.)

That'd be helpful, yes.
