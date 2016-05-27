Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47605 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbcE0GTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 02:19:19 -0400
Subject: Re: [PATCH v4 2/7] media: s5p-mfc: use generic reserved memory bindings
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <5747E6E2.6080201@samsung.com>
Date: Fri, 27 May 2016 08:19:14 +0200
MIME-version: 1.0
In-reply-to: <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
> Use generic reserved memory bindings and mark old, custom properties
> as obsoleted.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  .../devicetree/bindings/media/s5p-mfc.txt          | 39 +++++++++++++++++-----
>  1 file changed, 31 insertions(+), 8 deletions(-)
>

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Best regards,
Krzysztof

