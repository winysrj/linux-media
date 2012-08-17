Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5960 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2HQGAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 02:00:51 -0400
Date: Fri, 17 Aug 2012 09:00:27 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Antti Palosaari <crope@iki.fi>,
	"htl10@users.sourceforge.net" <htl10@users.sourceforge.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"joe@perches.com" <joe@perches.com>
Subject: Re: noisy dev_dbg_ratelimited()
Message-ID: <20120817090027.a6dffe2c83fbd05ce056822b@nvidia.com>
In-Reply-To: <1345148983.10042.YahooMailClassic@web29405.mail.ird.yahoo.com>
References: <502D4E9D.5010401@iki.fi>
	<1345148983.10042.YahooMailClassic@web29405.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Aug 2012 22:29:43 +0200
Hin-Tak Leung <htl10@users.sourceforge.net> wrote:

> --- On Thu, 16/8/12, Antti Palosaari <crope@iki.fi> wrote:
> 
> > Hello Hiroshi
> > 
> > On 08/16/2012 10:12 AM, Hiroshi Doyu wrote:
> > > Hi Antti,
> > >
> > > Antti Palosaari <crope@iki.fi>
> > wrote @ Thu, 16 Aug 2012 03:11:56 +0200:
> > >
> > >> Hello Hiroshi,
> > >>
> > >> I see you have added dev_dbg_ratelimited()
> > recently, commit
> > >> 6ca045930338485a8cdef117e74372aa1678009d .
> > >>
> > >> However it seems to be noisy as expected similar
> > behavior than normal
> > >> dev_dbg() without a ratelimit.
> > >>
> > >> I looked ratelimit.c and there is:
> > >> printk(KERN_WARNING "%s: %d callbacks
> > suppressed\n", func, rs->missed);
> > >>
> > >> What it looks my eyes it will print those
> > "callbacks suppressed" always
> > >> because KERN_WARNING.
> > >
> > > Right. Can the following fix the problem?
> > 
> > No. That silences dev_dbg_reatelimited() totally.
> > dev_dbg() works as expected printing all the debugs. But
> > when I change 
> > it to dev_dbg_reatelimited() all printings are silenced.

I tested again locally. With DEBUG, it prints sometimes with inserting
"...28916 callbacks suppressed", without DEBUG, it doesn't print
anything. This looks the expected behavior. 

> That's probably correct - the patch looks a bit strange... I did not
> try the patch, but had a quick look at the file and noted that in
> include/linux/device.h, "info" (and possibly another level) are
> treated specially... just thought I should mention this.

I may not get your point correctly, but I think that the debug case is
different from the others(info, warn, err...etc) because, the others
always prints anything, but not debug depends on DEBUG. With DEBUG
it's expected to print at least something, and without DEBUG it's
expected to print nothing at all.
