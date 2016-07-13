Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11276 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcGMH7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 03:59:31 -0400
Subject: Re: [PATCH 2/2] [media] s5p-g2d: Replace old driver with DRM version
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
 <1464096493-13378-2-git-send-email-k.kozlowski@samsung.com>
 <20160712200202.7496445e@recife.lan>
Cc: Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <5785F4CA.8070908@samsung.com>
Date: Wed, 13 Jul 2016 09:59:06 +0200
MIME-version: 1.0
In-reply-to: <20160712200202.7496445e@recife.lan>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2016 01:02 AM, Mauro Carvalho Chehab wrote:
> I suspect that you'll be applying this one via DRM tree, so:
> 
> Em Tue, 24 May 2016 15:28:13 +0200
> Krzysztof Kozlowski <k.kozlowski@samsung.com> escreveu:
> 
>> Remove the old non-DRM driver because it is now entirely supported by
>> exynos_drm_g2d driver.
>>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Kamil Debski <k.debski@samsung.com>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> PS.: If you prefer to apply this one via my tree, I'm ok too. Just
> let me know when the first patch gets merged upstream.

This patchset was insufficient and I didn't came up with follow up.
Please ignore it for now.

Best regards,
Krzysztof
