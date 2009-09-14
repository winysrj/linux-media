Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZINQR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 12:17:27 -0400
Date: Mon, 14 Sep 2009 13:16:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [ANOUNCE] Staging trees at V4L/DVB trees
Message-ID: <20090914131651.3165bbb3@pedra.chehab.org>
In-Reply-To: <20090913210841.6a4db925@caramujo.chehab.org>
References: <20090913210841.6a4db925@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Sep 2009 21:08:41 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> I intend to add tm6000 driver there later this week, if time permits to port it
> to the new i2c interface.

Ok, I've send part 1 of the patches I have here for tm6000. It still doesn't
compile with kernel 2.6.30 or upper, due to the I2C API changes.

I have still some other patches here pending, that are waiting for some time
for testing them. I also intend to fix its compilation during this week.

> The policy to accept new drivers code at staging tree is less rigid than
> at /drivers/media: the kernel driver for an unsupported hardware shouldn't
> depend on any userspace library other than libv4l and dvb-apps and the code
> should compile fine with the latest kernel, and the developer(s) should be
> working on fixing it for upstream inclusion. Drivers with bugs, CodingStyle
> errors, deprecated API usage, etc can be accepted. Also, drivers there not
> maintained for some time can be removed.

>From some breakage reports with go7007 with some kernels and due to tm6000,
I've added an option at Kconfig: STAGING_BROKEN, to indicate the drivers that
are known to not compile against the latest kernel. However, there's a bad
effect with this: those broken patches can't be updated upstream, otherwise
they'll break upstream compilations. So, while we might eventually accept a
broken driver at staging, a fix for it should be done quickly, to avoid causing
upstream merging issues



Cheers,
Mauro
