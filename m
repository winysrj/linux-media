Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160995AbcFHNGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2016 09:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <1465368713-17866-1-git-send-email-m.szyprowski@samsung.com>
References: <20160607143425.GE1165@e106497-lin.cambridge.arm.com> <1465368713-17866-1-git-send-email-m.szyprowski@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 8 Jun 2016 08:05:56 -0500
Message-ID: <CAL_JsqKNpx09UFkGB0n9W0GkAv8OVUdRN8cYriau83SdD6xnuw@mail.gmail.com>
Subject: Re: [PATCH] of: reserved_mem: restore old behavior when no region is defined
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 8, 2016 at 1:51 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Change return value back to -ENODEV when no region is defined for given
> device. This restores old behavior of this function, as some drivers rely
> on such error code.
>
> Reported-by: Liviu Dudau <liviu.dudau@arm.com>
> Fixes: 59ce4039727ef40 ("of: reserved_mem: add support for using more than
>        one region for given device")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/of_reserved_mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
