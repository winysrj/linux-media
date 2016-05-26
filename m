Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55680 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbcEZTJQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 15:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <1464096690-23605-2-git-send-email-m.szyprowski@samsung.com>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com> <1464096690-23605-2-git-send-email-m.szyprowski@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 26 May 2016 14:08:51 -0500
Message-ID: <CAL_JsqJxbVnj+FYz_f34QhM+Cf2gvpwZJZy4pKkNW2VnAmEa=w@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] of: reserved_mem: add support for using more than
 one region for given device
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 24, 2016 at 8:31 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> This patch allows device drivers to initialize more than one reserved
> memory region assigned to given device. When driver needs to use more
> than one reserved memory region, it should allocate child devices and
> initialize regions by index for each of its child devices.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/of_reserved_mem.c    | 85 +++++++++++++++++++++++++++++++----------
>  include/linux/of_reserved_mem.h | 25 ++++++++++--
>  2 files changed, 86 insertions(+), 24 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
