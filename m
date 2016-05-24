Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45958 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbcEXN6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:58:52 -0400
Subject: Re: [PATCH 1/2] drm/exynos: g2d: Add support for old S5Pv210 type
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
 <57445BE5.7060702@math.uni-bielefeld.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <57445E16.90301@samsung.com>
Date: Tue, 24 May 2016 15:58:46 +0200
MIME-version: 1.0
In-reply-to: <57445BE5.7060702@math.uni-bielefeld.de>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 03:49 PM, Tobias Jakobi wrote:
> Hello Krzysztof,
> 
> are you sure that these are the only differences. Because AFAIK there
> are quite a few more:
> - DMA submission of commands
> - blend mode / rounding
> - solid fill
> - YCrCb support
> - and probably more
> 
> One would need to add least split the command list parser into a v3 and
> v41 version to accomodate for the differences. In fact userspace/libdrm
> would need to know which hw type it currently uses, but you currently
> always return 4.1 in the corresponding ioctl.

Eh, so probably my patch does not cover fully the support for v3 G2D. I
looked mostly at the differences between v3 and v4 in the s5p-g2d driver
itself. However you are right that this might be not sufficient because
exynos-g2d moved forward and is different than s5p-g2d.

> Krzysztof Kozlowski wrote:
>> The non-DRM s5p-g2d driver supports two versions of G2D: v3.0 on
>> S5Pv210 and v4.x on Exynos 4x12 (or newer). The driver for 3.0 device
>> version is doing two things differently:
>> 1. Before starting the render process, it invalidates caches (pattern,
>>    source buffer and mask buffer). Cache control is not present on v4.x
>>    device.
>> 2. Scalling is done through StretchEn command (in BITBLT_COMMAND_REG
>>    register) instead of SRC_SCALE_CTRL_REG as in v4.x. However the
>>    exynos_drm_g2d driver does not implement the scalling so this
>>    difference can be eliminated.
> Huh? Where did you get this from? Scaling works with the DRM driver.

I was looking for the usage of scaling reg (as there is no scaling
command). How the scaling is implemented then?

Thanks for feedback!

Best regards,
Krzysztof

