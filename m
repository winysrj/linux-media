Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43190 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbaCDKKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:10:09 -0500
Message-ID: <1393927791.3917.3.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v5 5/7] [media] of: move common endpoint parsing to
 drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Date: Tue, 04 Mar 2014 11:09:51 +0100
In-Reply-To: <5310FB23.5040203@gmail.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
	 <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>
	 <5310FB23.5040203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 28.02.2014, 22:09 +0100 schrieb Sylwester Nawrocki:
[...]
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1985,6 +1985,37 @@ struct device_node *of_find_next_cache_node(const struct device_node *np)
> >   }
> >
> >   /**
> > + * of_graph_parse_endpoint() - parse common endpoint node properties
> > + * @node: pointer to endpoint device_node
> > + * @endpoint: pointer to the OF endpoint data structure
> > + *
> > + * All properties are optional. If none are found, we don't set any flags.
> > + * This means the port has a static configuration and no properties have
> > + * to be specified explicitly.
> 
> I don't think these two sentences are needed, it's all described in the
> DT binding documentation. And struct of_endpoint doesn't contain any
> "flags" field.

Thanks, I'll remove them.

regards
Philipp

