Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39957 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBKVqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 16:46:48 -0500
Date: Tue, 11 Feb 2014 22:46:28 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Rob Herring <robherring2@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
Message-ID: <20140211214628.GA10068@pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140211145248.GI26684@n2100.arm.linux.org.uk>
 <8648675.AIXYyYlgXy@avalon>
 <1392136617.6943.33.camel@pizza.hi.pengutronix.de>
 <52FA5C5A.1090008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA5C5A.1090008@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Feb 11, 2014 at 06:22:34PM +0100, Sylwester Nawrocki wrote:
> drivers/media sounds like a good alternative to me.
> 
> I would just remove also v4l2_of_{parse/get}* and update the users
> to call of_graph_* directly, there should not be many of them.

For now I'd like to skip v4l2_of_parse_endpoint. The others can just be
copied verbatim, but this one also depends on struct 4l2_of_endpoint,
struct v4l2_of_bus_*, and <media/v4l2-mediabus.h>.

regards
Philipp
