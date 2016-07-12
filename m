Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62863 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbcGLMTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:19:15 -0400
Subject: Re: [PATCH v5 00/44] dma-mapping: Use unsigned long for dma_attrs
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	sparclinux@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-c6x-dev@linux-c6x.org,
	linux-rdma@vger.kernel.org, linux-hexagon@vger.kernel.org,
	linux-sh@vger.kernel.org, hch@infradead.org,
	linux-rockchip@lists.infradead.org, nouveau@lists.freedesktop.org,
	xen-devel@lists.xenproject.org, linux-snps-arc@lists.infradead.org,
	linux-media@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	linux-arm-msm@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-metag@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-cris-kernel@axis.com,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux-foundation.org, linux-alpha@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
References: <1467275019-30789-1-git-send-email-k.kozlowski@samsung.com>
 <20160712121625.GP23520@phenom.ffwll.local>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <5784E03B.6060000@samsung.com>
Date: Tue, 12 Jul 2016 14:19:07 +0200
MIME-version: 1.0
In-reply-to: <20160712121625.GP23520@phenom.ffwll.local>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2016 02:16 PM, Daniel Vetter wrote:
> On Thu, Jun 30, 2016 at 10:23:39AM +0200, Krzysztof Kozlowski wrote:
>> Hi,
>>
>>
>> This is fifth approach for replacing struct dma_attrs with unsigned
>> long.
>>
>> The main patch (1/44) doing the change is split into many subpatches
>> for easier review (2-42).  They should be squashed together when
>> applying.
> 
> For all the drm driver patches:
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Should I pull these in through drm-misc, or do you prefer to merge them
> through a special topic branch (with everything else) instead on your own?
> -Daniel

Thanks. I saw today that Andrew Morton applied the patchset so I think
he will handle it.

Best regards,
Krzysztof

