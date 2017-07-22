Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46274 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdGVGmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 02:42:23 -0400
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [PATCH v2] media: Convert to using %pOF instead of full_name
To: Rob Herring <robh@kernel.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <97f42d10-d2ed-c5bb-9562-5515d5f13f7d@samsung.com>
Date: Sat, 22 Jul 2017 08:42:11 +0200
In-reply-to: <20170721192835.25555-2-robh@kernel.org>
Content-language: en-GB
Content-transfer-encoding: 8bit
References: <20170721192835.25555-1-robh@kernel.org>
        <CGME20170721192855epcas5p40919807b161c8dee900b5661ea5128aa@epcas5p4.samsung.com>
        <20170721192835.25555-2-robh@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2017 09:28 PM, Rob Herring wrote:
> Now that we have a custom printf format specifier, convert users of
> full_name to use %pOF instead. This is preparation to remove storing
> of the full path string for each node.
> 
> Signed-off-by: Rob Herring<robh@kernel.org>
> Acked-by: Niklas Söderlund<niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Reviewed-by: Matthias Brugger<matthias.bgg@gmail.com>
> Acked-by: Nicolas Ferre<nicolas.ferre@microchip.com>
> Acked-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>

> ---
> v2:
> - Fix missing to_of_node() in xilinx-vipp.c
> - Drop v4l2-async.c changes. Doing as revert instead.
> - Add acks

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
