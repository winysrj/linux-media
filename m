Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:43257 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbCWQ3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 12:29:22 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	Benoit Parrot <bparrot@ti.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Darren Etheridge <detheridge@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL v2] of: Add of-graph helpers to loop over endpoints and find ports by id
Date: Mon, 23 Mar 2015 17:29:02 +0100
Message-ID: <2376013.jScnaqPlDa@phil>
In-Reply-To: <1426063881.3101.33.camel@pengutronix.de>
References: <1425369592.3146.14.camel@pengutronix.de> <CAL_Jsq+s5RN+7z8Q5N1VghxaQ_ajQmBddtWOTovLoVJjb_6uDw@mail.gmail.com> <1426063881.3101.33.camel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob, Philipp,

Am Mittwoch, 11. März 2015, 09:51:21 schrieb Philipp Zabel:
> Am Dienstag, den 10.03.2015, 14:05 -0500 schrieb Rob Herring:
> > I've only been copied on this latest pull request and a version from
> > March of last year which Grant nak'ed. This series did not go to
> > devicetree list either. I'll take a look at the series.
> 
> My bad, I should have copied you, too. Thanks for having a look now.

any news on this?

Because it looks like I'll need the of_graph_get_port_by_id functionality in 
the short term, it'll be nice to not having to opencode this :-)


Thanks
Heiko

> 
> The nak'ed series (https://lkml.org/lkml/2014/3/20/664) indeed already
> included the "of: Add OF graph helper to get a specific port by id" and
> "of: Add OF graph helpers to iterate over ports" patches, but Grant's
> nak applied to the first patch, "of: Parse OF graph into graph
> structure", which I then dropped.
> 
> > If there is an explanation of how Grant's nak was addressed that would
> > speed up my review.
> 
> See above. The other two patches have been uncontroversial. The
> of_graph_get_next_endpoint and for_each_endpoint_of_node patches
> fix an in-kernel API that was too easy to use incorrectly, and
> the of_graph_get_port_by_id patch I can't remember being
> commented on at all.
> 
> > I'm not applying for v4.0 though.
> 
> If you decide to apply them, please consider merging the tag and giving
> your ack for it to be merged into the other subsystem trees, too.
> 
> regards
> Philipp
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

