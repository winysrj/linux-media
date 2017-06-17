Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62936 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdFQG6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 02:58:41 -0400
Subject: Re: [PATCH v2] [media] davinci: vpif: adaptions for DT support
To: Kevin Hilman <khilman@baylibre.com>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <5085c24d-fec8-7ff0-e97f-ecbce1fbbe01@samsung.com>
Date: Sat, 17 Jun 2017 08:58:32 +0200
MIME-version: 1.0
In-reply-to: <20170609161026.7582-1-khilman@baylibre.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170609161026.7582-1-khilman@baylibre.com>
        <CGME20170617065837epcas5p49ffbc2fd9831b822ab6e368b86049025@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2017 06:10 PM, Kevin Hilman wrote:
> The davinci VPIF is a single hardware block, but the existing driver
> is broken up into a common library (vpif.c), output (vpif_display.c) and
> intput (vpif_capture.c).
> 
> When migrating to DT, to better model the hardware, and because
> registers, interrupts, etc. are all common,it was decided to
> have a single VPIF hardware node[1].
> 
> Because davinci uses legacy, non-DT boot on several SoCs still, the
> platform_drivers need to remain.  But they are also needed in DT boot.
> Since there are no DT nodes for the display/capture parts in DT
> boot (there is a single node for the parent/common device) we need to
> create platform_devices somewhere to instansiate the platform_drivers.
> 
> When VPIF display/capture are needed for a DT boot, the VPIF node
> will have endpoints defined for its subdevs.  Therefore, vpif_probe()
> checks for the presence of endpoints, and if detected manually creates
> the platform_devices for the display and capture platform_drivers.
> 
> [1] Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> 
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


-- 
Regards,
Sylwester
