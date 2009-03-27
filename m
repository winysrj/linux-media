Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbZC0AJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 20:09:40 -0400
Date: Thu, 26 Mar 2009 21:09:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: klaas de waal <klaas.de.waal@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	erik_bies@hotmail.com
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
Message-ID: <20090326210929.32235862@pedra.chehab.org>
In-Reply-To: <1238111503.4783.23.camel@pc07.localdom.local>
References: <7b41dd970903251353n46f55bbfg687c1cfa42c5b824@mail.gmail.com>
	<1238111503.4783.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009 00:51:43 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi Klaas,
> 
> Am Mittwoch, den 25.03.2009, 21:53 +0100 schrieb klaas de waal:
> > (2nd try, this should be now  in "plain text" instead of HTML)
> > 
> > Hi Hermann,
> > 
> > Thanks for your "howto" on making a proper patch.
> > After a "make commit" in my local v4l-dvb tree, and filling in the
> > template I got the following output.
> > I confess I do not know if this has now ended up somewhere in
> > linuxtv.org or that it is just local.
> > However, here it is:
> 
> your patches are still local, but they are at least on the proper list
> now. Without starting with [PATCH] in the subject Mauro's scripts to add
> them to patchwork automatically likely will still not find them.

The patchwork scripts are the ones that came with the product. They are not
developed by me ;)

Anyway, if patchwork didn't catch is because the inlined patch is broken, or it is
not inlined and were attached with a wrong mime type.


Cheers,
Mauro
