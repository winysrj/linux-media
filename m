Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32874 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZE0MBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 08:01:41 -0400
Date: Wed, 27 May 2009 13:01:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Simplified CONFIG_I2C=n interface.
Message-ID: <20090527120140.GC1970@sirena.org.uk>
References: <20090527070850.GA11221@linux-sh.org> <20090527091831.26b60d6d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527091831.26b60d6d@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2009 at 09:18:31AM +0200, Jean Delvare wrote:

> Violent nack. Drivers which optionally use I2C are a minority.

It's extremely common for devices like the CODECs and PMICs used in
embedded systems to have both I2C and SPI interfaces, selectable via a
pin strap at power on.  It's less common to have the SPI option for
things like hardware monitoring chips found in PCs but for anything that
might be I/O bound the high speed interface is a very common option.

> Designing them in such a way that a single #ifdef CONFIG_I2C will make
> them work can't be that hard, really. Not to mention that having a
> dozen stubs in i2c.h in the CONFIG_I2C=n case won't save you much work
> at the driver level anyway, because you certainly need to run different
> code paths depending on how the device is connected, and you also have
> to differentiate between the "I2C support is missing" case and the "I2C
> device registration failed" case, etc.

For the devices I've dealt with there's very little work at the driver
level - the various interfaces that can be used each probe using the
normal device model, set some register read/write operations and
possibly some other things and then call into the bulk of the driver
which has all the I/O abstracted away from it.

The error handling is already an issue with the current situation since
people are just silently building out the I2C support when I2C is not
enabled.  At the minute the main problem is with people not remembering
to do the #ifdef (a lot of platforms really need I2C enabled to be
useful so people never think to do the build without).
