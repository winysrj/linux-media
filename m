Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17022 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdI1JG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:06:26 -0400
Subject: Re: [PATCH v2 13/17] media: v4l2-async: simplify v4l2_async_subdev
 structure
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javi Merino <javi.merino@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Markus Elfring <elfring@users.sourceforge.net>,
        devel@driverdev.osuosl.org, Yannick Fertre <yannick.fertre@st.com>,
        linux-samsung-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tuukka Toivonen <tuukka.toivonen@intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <garsilva@emb>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <2c9c90cc-a41a-ae08-1a50-7d2532aef3e2@samsung.com>
Date: Thu, 28 Sep 2017 11:06:13 +0200
MIME-version: 1.0
In-reply-to: <cd089c6dac22c8ea2194c47c48386e52bb6e561f.1506548682.git.mchehab@s-opensource.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <cd089c6dac22c8ea2194c47c48386e52bb6e561f.1506548682.git.mchehab@s-opensource.com>
        <CGME20170928090623epcas2p37888b0350217812c84921c4e11340df1@epcas2p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2017 11:46 PM, Mauro Carvalho Chehab wrote:
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
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
