Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1ISIsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:48:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>, Jean Delvare <khali@linux-fr.org>,
	Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
	johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
	sameo@linux.intel.com, mchehab@infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Mon, 19 Sep 2011 10:47:50 +0200
Message-ID: <2282172.TF7nejTDIZ@wuerfel>
In-Reply-To: <4E763C3C.3050909@xenotime.net>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <20110918152835.GA30696@kroah.com> <4E763C3C.3050909@xenotime.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 18 September 2011 11:45:16 Randy Dunlap wrote:
> >> We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
> >> consistent or timely with applying drivers/misc/ patches.  It deserves better.
> >> [added him to Cc: list]
> > 
> > I do try to handle patches sent to me for misc/ in time for the
> > different merge windows as that directory contains drivers that have
> > moved out of the staging/ directory.
> > 
> > But yes, I'm not the overall drivers/misc/ maintainer, do we really need
> > one?  If so, I can easily start maintaining a development tree for it to
> > keep it separate for the different driver authors to send me stuff and
> > start tracking it more "for real" if Arnd doesn't want to do it.
> 
> We need for the patches to be applied in a timely manner.
> Sometimes when there is no real maintainer, that does not happen.

I think the other equally import aspect of maintainership that
drivers/misc (and drivers/char) needs is someone who says no to
stuff that doesn't belong there and helps submitters to find a
proper place where appropriate and to come up with a proper user
interface abstraction.

I'm definitely willing to do that part.

Greg, how about we both formally take ownership of driver/{misc,char}
and you track the patches while I do the bulk of the reviews? You
are definitely better than me with the patch tracking workflow.

	Arnd
