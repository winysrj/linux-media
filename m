Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:60969 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab2CBXVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 18:21:41 -0500
Received: from pannekake.samfundet.no ([2001:700:300:1800::dddd] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S3bn7-0002OH-B3
	for linux-media@vger.kernel.org; Sat, 03 Mar 2012 00:21:37 +0100
Received: from sesse by pannekake.samfundet.no with local (Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S3bn7-0002J7-1i
	for linux-media@vger.kernel.org; Sat, 03 Mar 2012 00:21:37 +0100
Date: Sat, 3 Mar 2012 00:21:37 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
Message-ID: <20120302232136.GB31447@uio.no>
References: <20120228010330.GA25786@uio.no>
 <4F514CCB.8020502@kolumbus.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F514CCB.8020502@kolumbus.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 03, 2012 at 12:42:19AM +0200, Marko Ristola wrote:
> I'm not happy with I2CDONE busy looping either.
> I've tried twice lately to swith into I2C IRQ, but those patches have caused I2CDONE timeouts.

Note that there are already timeouts with the current polling code, but they
are ignored (my patch makes them at least be printed with verbose=5). I can't
immediately recall if it's on RACK, DONE or both.

> Do my following I2C logic thoughts make any sense?

Well, note first of all that I know next to nothing about I2C, and I've never
seen any hardware documentation on the Mantis card (is there any?). But
generally it makes sense to me, except that I've never heard of the demand of
radio silence for 10 ms before.

> There might be race conditions, that the driver possibly manages:
> 1. If two threads talk into DVB frontend, one could turn off the I2C gate, while the other is talking to DVB frontend.
>    This would case lack of I2CRACK: only way to recover would be to turn
>    the I2C gate on, and then redo the I2C transfer.

Note that I've tried putting mutexes around the I2C functions, and it didn't
help on the I2C timeouts; however, that was largely on a single-character
level, so it might not be enough. (You can see these mutexes being commented
out in my patch.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
