Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbZCDRRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 12:17:45 -0500
Date: Wed, 4 Mar 2009 14:17:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Message-ID: <20090304141715.0a1af14d@pedra.chehab.org>
In-Reply-To: <200903022218.24259.hverkuil@xs4all.nl>
References: <200903022218.24259.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Mon, 2 Mar 2009 22:18:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> In the final analysis I'm the boss of my own time. And I've decided that 
> once the conversion of all the i2c modules is finished I'll stop spending 
> time on the compatibility code for kernels <2.6.22 as it is simply no 
> longer an effective use of my time. If someone else wants to spend time on 
> that, then that's great and I will of course answer questions or help in 
> whatever way is needed.
> 
> I know that Mauro thinks he can keep the backwards compat code in by doing 
> nifty code transformations. It would be nice if he succeeds (and I have no 
> doubt that it is possible given enough time and effort), but personally I 
> think it is time better spent elsewhere.

It required just a couple of hours today, in order to add the I2C conversion
rules on the backport tree:

	http://linuxtv.org/hg/~mchehab/backport/

There, I used, as example, the tea6415c.c file that you sent me, meant to be an
example of a driver converted to use just the new I2C API. I've removed from it
all the other #ifdefs for 2.6.26, so, the module doesn't have any compat bits
(except for "compat.h" that can also be handled by the script). I didn't compile
the entire tree, since several drivers will break, as they aren't ported yet
to the new I2C style.

Maybe a few adjustments on the backport.pl may be needed, after having all
drivers converted to 2.6.22, since the final version may need some other
patching rules.

That's said, the backport tree is still an experimental work. The scripts
require more time to be tested, and the Makefiles need some cleanups.

Beside the fact that we don't need to strip support for legacy kernels, the
advantage of using this method is that we can evolute to a new development
model. As several developers already required, we should really use the
standard -git tree as everybody's else. This will simplify a lot the way we
work, and give us more agility to send patches upstream.

With this backport script, plus the current v4l-dvb building systems, and after
having all backport rules properly mapped, we can generate a "test tree"
based on -git drivers/media, for the users to test the drivers against their
kernels, and still use a clean tree for development.

Cheers,
Mauro

--

PS: the tea6415c.c fully ported to the new I2C API you sent in priv
doesn't compile fine with 2.6.28. Since this file is just an example, I didn't
care to fix it.
