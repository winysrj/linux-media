Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43866 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbcEYP50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 11:57:26 -0400
Subject: Re: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved
 memory handling
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <0e488519-cbb9-6fdf-264a-1526d267096a@osg.samsung.com>
Date: Wed, 25 May 2016 11:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
> Once MFC driver has been converted to generic reserved memory bindings,
> there is no need for custom memory reservation code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
