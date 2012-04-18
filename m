Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:48141 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRSxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 14:53:31 -0400
Received: from pannekake.samfundet.no ([2001:700:300:1800::dddd])
	by cassarossa.samfundet.no with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1SKa0J-0003lP-IM
	for linux-media@vger.kernel.org; Wed, 18 Apr 2012 20:53:28 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1SKa0J-0003Yr-6y
	for linux-media@vger.kernel.org; Wed, 18 Apr 2012 20:53:23 +0200
Date: Wed, 18 Apr 2012 20:53:23 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Various fixes, hacks and patches for Mantis CA support.
Message-ID: <20120418185323.GA30118@uio.no>
References: <20120401155330.GA31901@uio.no>
 <4F8F0A12.6070309@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F8F0A12.6070309@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2012 at 08:38:10PM +0200, Ninja wrote:
> sorry for the late response. Unfortunately my Skystar HD2 died on me
> and it looks like i get an other card in exchange.
> Anyway, as far I could test, the patches were ok to me. I can still
> put my marks, but I'm not sure which ones I should use or I'm
> allowed to use.

All except 01 (IRQ0 handling) and 11 (enable CA) are written by me. 01 should
probably be safe (it's already pending review here); 11 is more unclear.
Anyway, I'm sure 11 is pretty trivial once it's cleaned up, so someone should
just rewrite it without the part that moves a function around, and I'm sure
it can go in.

02, 04 and 06 are fixes for debugging output only. They should be safe.

03 (dvbdev mutex) should probably be fixed in a more general way, by someone
more knowledgeable of the DVB subsystem.

06 and 08 are general cleanups. They should be pretty safe.

07 (atomic accesses) contains important SMP fixes. Should definitely go in.

09 and 10 contain fixes for IRQ0 timeouts on SMP. They should go in, but only
as a pair; if you do 09 without 10, you will unmask a lot of the timeouts
that are there. (09 doesn't introduce any new timeouts, it just makes
userspace see them properly, and as an end result, things get worse.)

So, as a start, pull 01, 02, and 04 through 10? We'll still be without CA
support, but as a whole the Mantis driver will be better.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
