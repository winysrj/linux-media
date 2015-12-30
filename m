Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55871 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbL3XZ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 18:25:27 -0500
MIME-Version: 1.0
In-Reply-To: <1450280249-24681-4-git-send-email-m.szyprowski@samsung.com>
References: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com> <1450280249-24681-4-git-send-email-m.szyprowski@samsung.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 30 Dec 2015 17:25:04 -0600
Message-ID: <CAL_JsqKmY3DOZ6xNcQ7mSrkuLzdxaGtAPRCjkanH-G58=iOtmw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] of: reserved_mem: add support for named reserved
 mem nodes
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 16, 2015 at 9:37 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> This patch allows device drivers to initialize more than one reserved
> memory region assigned to given device. When driver needs to use more
> than one reserved memory region, it should allocate child devices and
> initialize regions by index or name for each of its child devices.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  .../bindings/reserved-memory/reserved-memory.txt   |   2 +
>  .../devicetree/bindings/resource-names.txt         |   1 +
>  drivers/of/of_reserved_mem.c                       | 104 +++++++++++++++++----
>  include/linux/of_reserved_mem.h                    |  31 +++++-
>  4 files changed, 115 insertions(+), 23 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
> index 3da0ebdba8d9..43a14957fd64 100644
> --- a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
> +++ b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
> @@ -74,6 +74,8 @@ Regions in the /reserved-memory node may be referenced by other device
>  nodes by adding a memory-region property to the device node.
>
>  memory-region (optional) - phandle, specifier pairs to children of /reserved-memory
> +memory-region-names (optional) - supplemental names property, provide array of
> +                                names to identify memory regions
>
>  Example
>  -------
> diff --git a/Documentation/devicetree/bindings/resource-names.txt b/Documentation/devicetree/bindings/resource-names.txt
> index e280fef6f265..51823e99b983 100644
> --- a/Documentation/devicetree/bindings/resource-names.txt
> +++ b/Documentation/devicetree/bindings/resource-names.txt
> @@ -12,6 +12,7 @@ Resource Property     Supplemental Names Property
>  reg                    reg-names
>  clocks                 clock-names
>  interrupts             interrupt-names
> +memory-region          memory-region-names

The other cases of *-names should correspond to actual h/w names for a
h/w block. memory-regions are not really h/w. So I'd prefer to not add
memory-region-names. If you want a name for the region, put it in the
region node. The name for each client node is not going to be
different.

Rob
