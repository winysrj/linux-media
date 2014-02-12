Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45530 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaBLJMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 04:12:36 -0500
Message-ID: <1392196314.5536.15.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/media
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 12 Feb 2014 10:11:54 +0100
In-Reply-To: <20140212065306.36a03e82.m.chehab@samsung.com>
References: <1392154905-12007-1-git-send-email-p.zabel@pengutronix.de>
	 <20140212065306.36a03e82.m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Mittwoch, den 12.02.2014, 06:53 +0900 schrieb Mauro Carvalho Chehab:
[...]
> > diff --git a/include/media/of_graph.h b/include/media/of_graph.h
> > new file mode 100644
> > index 0000000..3bbeb60
> > --- /dev/null
> > +++ b/include/media/of_graph.h
> > @@ -0,0 +1,46 @@
> > +/*
> > + * OF graph binding parsing helpers
> > + *
> > + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> > + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > + *
> > + * Copyright (C) 2012 Renesas Electronics Corp.
> > + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of version 2 of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + */
> > +#ifndef __LINUX_OF_GRAPH_H
> > +#define __LINUX_OF_GRAPH_H
> > +
> > +#ifdef CONFIG_OF
> 
> As a matter of consistency, it would be better to test here for
> CONFIG_OF_GRAPH instead, to reflect the same symbol that enables such
> functions as used on Kconfig/Makefile.

Maybe I'm trying to be too clever for my own good, but my reasoning was
as follows:

Suppose I newly use the of_graph_ helpers in a subsystem that does not
yet select OF_GRAPH. In that case I'd rather get linking errors earlier
rather than stubbed out functions that silently fail to parse the DT
later.

Since there is
config VIDEO_DEV
	select OF_GRAPH if OF
already and the same should be added for other users of device tree
graphs, I think stubbing out the functions only if OF is disabled should
be enough.

regards
Philipp

