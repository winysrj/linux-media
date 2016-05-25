Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43800 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbcEYPmp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 11:42:45 -0400
Subject: Re: [PATCH v4 3/7] media: s5p-mfc: replace custom reserved memory
 handling code with generic one
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-4-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <458196c1-806c-4cd6-abf1-f01dd23bff2a@osg.samsung.com>
Date: Wed, 25 May 2016 11:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <1464096690-23605-4-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
> This patch removes custom code for initialization and handling of
> reserved memory regions in s5p-mfc driver and replaces it with generic
> reserved memory regions api.
> 
> s5p-mfc driver now handles two reserved memory regions defined by
> generic reserved memory bindings. Support for non-dt platform has been
> removed, because all supported platforms have been already converted to
> device tree.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Similar question than for patch #2, shouldn't we include the in-kernel DTS
changes with this patch to keep bisectability? Otherwise the mfc-{l,r} mem
allocation will fail after this patch.

The patch looks good to me though:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

I couldn't test this exact patch because my Odroid XU4 died but I've tested
the previous version and the only difference is that the memory reserve is
made by index now instead of name, so I think you can add:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
