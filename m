Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:38422 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab0LMPwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 10:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101210170356.GA28472@n2100.arm.linux.org.uk>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl>
	<201012101159.21845.jkrzyszt@tis.icnet.pl>
	<201012101203.09441.jkrzyszt@tis.icnet.pl>
	<20101210170356.GA28472@n2100.arm.linux.org.uk>
Date: Mon, 13 Dec 2010 15:52:20 +0000
Message-ID: <AANLkTimTVWVmVfppAWSosidqLmo6c+8rPhLg=oJAVoYH@mail.gmail.com>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 10 December 2010 17:03, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
>>  void __init omap1_camera_init(void *info)
>>  {
>>       struct platform_device *dev = &omap1_camera_device;
>> +     dma_addr_t paddr = omap1_camera_phys_mempool_base;
>> +     dma_addr_t size = omap1_camera_phys_mempool_size;
>>       int ret;
>>
>>       dev->dev.platform_data = info;
>>
>> +     if (paddr) {
>> +             if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
>> +                             DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
>
> Although this works, you're ending up with SDRAM being mapped via
> ioremap, which uses MT_DEVICE - so what is SDRAM ends up being
> mapped as if it were a device.

BTW, does the generic dma_declare_coherent_memory() does the correct
thing in using ioremap()? Maybe some other function that takes a
pgprot_t would be better (ioremap_page_range) and could pass something
like pgprot_noncached (though ideally a pgprot_dmacoherent). Or just
an architecturally-defined function.

-- 
Catalin
