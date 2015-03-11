Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41267 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbCKIvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 04:51:39 -0400
Message-ID: <1426063881.3101.33.camel@pengutronix.de>
Subject: Re: [GIT PULL v2] of: Add of-graph helpers to loop over endpoints
 and find ports by id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Darren Etheridge <detheridge@ti.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Wed, 11 Mar 2015 09:51:21 +0100
In-Reply-To: <CAL_Jsq+s5RN+7z8Q5N1VghxaQ_ajQmBddtWOTovLoVJjb_6uDw@mail.gmail.com>
References: <1425369592.3146.14.camel@pengutronix.de>
	 <1426001087.3141.46.camel@pengutronix.de>
	 <20150310154253.GO8656@n2100.arm.linux.org.uk>
	 <CAL_Jsq+s5RN+7z8Q5N1VghxaQ_ajQmBddtWOTovLoVJjb_6uDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Am Dienstag, den 10.03.2015, 14:05 -0500 schrieb Rob Herring:
> I've only been copied on this latest pull request and a version from
> March of last year which Grant nak'ed. This series did not go to
> devicetree list either. I'll take a look at the series. 

My bad, I should have copied you, too. Thanks for having a look now.

The nak'ed series (https://lkml.org/lkml/2014/3/20/664) indeed already
included the "of: Add OF graph helper to get a specific port by id" and
"of: Add OF graph helpers to iterate over ports" patches, but Grant's
nak applied to the first patch, "of: Parse OF graph into graph
structure", which I then dropped.

> If there is an explanation of how Grant's nak was addressed that would
> speed up my review.

See above. The other two patches have been uncontroversial. The
of_graph_get_next_endpoint and for_each_endpoint_of_node patches
fix an in-kernel API that was too easy to use incorrectly, and
the of_graph_get_port_by_id patch I can't remember being
commented on at all.

> I'm not applying for v4.0 though.

If you decide to apply them, please consider merging the tag and giving
your ack for it to be merged into the other subsystem trees, too.

regards
Philipp

