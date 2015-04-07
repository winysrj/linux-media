Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41018 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbDGMnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 08:43:49 -0400
Date: Tue, 7 Apr 2015 13:43:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 06/14] clkdev: add clkdev_create() helper
Message-ID: <20150407124342.GJ4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <E1Ye59J-0001BF-CZ@rmk-PC.arm.linux.org.uk>
 <5522EA55.5080804@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5522EA55.5080804@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 06, 2015 at 01:19:33PM -0700, Stephen Boyd wrote:
> On 04/03/15 10:12, Russell King wrote:
> > @@ -316,6 +329,29 @@ clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
> >  }
> >  EXPORT_SYMBOL(clkdev_alloc);
> >  
> > +/**
> > + * clkdev_create - allocate and add a clkdev lookup structure
> > + * @clk: struct clk to associate with all clk_lookups
> > + * @con_id: connection ID string on device
> > + * @dev_fmt: format string describing device name
> > + *
> > + * Returns a clk_lookup structure, which can be later unregistered and
> > + * freed.
> 
> Please add that this returns NULL on failure.

Will do, but please remember that _I'm_ taking the clkdev patches through
my tree, as I'm the maintainer for clkdev.  Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
