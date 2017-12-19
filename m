Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34414 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966545AbdLSI1V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 03:27:21 -0500
Date: Tue, 19 Dec 2017 10:27:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Benoit Parrot <bparrot@ti.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Petr Cvek <petr.cvek@tul.cz>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sebastian Reichel <sre@kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/8] media: v4l2-async: simplify v4l2_async_subdev
 structure
Message-ID: <20171219082717.3cs62f2lqaj4ib27@valkosipuli.retiisi.org.uk>
References: <cover.1513625884.git.mchehab@s-opensource.com>
 <014b64d13c8b9d516afc3319a9de1a97b2a845de.1513625884.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014b64d13c8b9d516afc3319a9de1a97b2a845de.1513625884.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 18, 2017 at 05:53:57PM -0200, Mauro Carvalho Chehab wrote:
> The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
> struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
> match criteria requires just a device name.
> 
> So, it doesn't make sense to enclose those into structs,
> as the criteria can go directly into the union.
> 
> That makes easier to document it, as we don't need to document
> weird senseless structs.
> 
> At drivers, this makes even clearer about the match criteria.
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I'm not sure this is needed but it doesn't break anything either.

Feel free to add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
