Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:60242 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2B1Bpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 20:45:39 -0500
Received: from pannekake.samfundet.no ([2001:700:300:1800::dddd] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S2C8F-0002hW-Tw
	for linux-media@vger.kernel.org; Tue, 28 Feb 2012 02:45:36 +0100
Received: from sesse by pannekake.samfundet.no with local (Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S2C8F-0000ZJ-FM
	for linux-media@vger.kernel.org; Tue, 28 Feb 2012 02:45:35 +0100
Date: Tue, 28 Feb 2012 02:45:35 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
Message-ID: <20120228014535.GA31217@uio.no>
References: <20120228010330.GA25786@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120228010330.GA25786@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2012 at 02:03:30AM +0100, Steinar H. Gunderson wrote:
> I'm still not happy with the bit-banging on the I2C interface (as opposed to
> dealing with it in the interrupt handler); I long suspected it for causing
> the IRQ0 problems, especially as they seem to have a sort-of similar issue
> with I2CDONE/I2CRACk never being set, but it seem the DMA transfers is really
> what causes it somehow, so I've left it alone.

There's one more thing I forgot to mention; deinitialization does not seem to
work correctly. If I remove the mantis driver and reload it, the CAM is no
longer detected correctly (when the 50211 driver tries to read the
identification bits from the CAM memory space, they simply don't match
anymore). This is annoying, as it means a reboot is required whenever one
wants to test a new fix, but I haven't been able to figure out why it
happens. Just wanted to mention so that nobody bangs their head in the wall
too much due to hitting that problem :-)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
