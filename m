Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:38842 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbbCXJQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 05:16:04 -0400
Date: Tue, 24 Mar 2015 09:15:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Heiko Stuebner <heiko@sntech.de>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	Benoit Parrot <bparrot@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Darren Etheridge <detheridge@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL v2] of: Add of-graph helpers to loop over endpoints
 and find ports by id
Message-ID: <20150324091540.GU8656@n2100.arm.linux.org.uk>
References: <1425369592.3146.14.camel@pengutronix.de>
 <CAL_Jsq+s5RN+7z8Q5N1VghxaQ_ajQmBddtWOTovLoVJjb_6uDw@mail.gmail.com>
 <1426063881.3101.33.camel@pengutronix.de>
 <2376013.jScnaqPlDa@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2376013.jScnaqPlDa@phil>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 23, 2015 at 05:29:02PM +0100, Heiko Stuebner wrote:
> Hi Rob, Philipp,
> 
> Am Mittwoch, 11. März 2015, 09:51:21 schrieb Philipp Zabel:
> > Am Dienstag, den 10.03.2015, 14:05 -0500 schrieb Rob Herring:
> > > I've only been copied on this latest pull request and a version from
> > > March of last year which Grant nak'ed. This series did not go to
> > > devicetree list either. I'll take a look at the series.
> > 
> > My bad, I should have copied you, too. Thanks for having a look now.
> 
> any news on this?
> 
> Because it looks like I'll need the of_graph_get_port_by_id functionality in 
> the short term, it'll be nice to not having to opencode this :-)

Oh hell, you mean this still hasn't been merged for the next merge window?

What's going on, Grant?

Andrew, can you please take this if we send you the individual patches?
If not, I'll merge it into my tree, and send it to Linus myself.  If
Grant wakes up, we can address any comments he has at that time by
additional patches.  (I'll give Grant an extra few days to reply to
this mail...)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
