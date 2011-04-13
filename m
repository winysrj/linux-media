Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1DMMFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 08:05:18 -0400
Received: by bwz15 with SMTP id 15so501592bwz.19
        for <linux-media@vger.kernel.org>; Wed, 13 Apr 2011 05:05:17 -0700 (PDT)
Message-ID: <4DA59120.1070402@ru.mvista.com>
Date: Wed, 13 Apr 2011 16:03:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken
 on	ARM
References: <201104122306.34909.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201104122306.34909.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 13-04-2011 1:06, Janusz Krzysztofik wrote:

> After switching from mem->dma_handle to virt_to_phys(mem->vaddr) used
> for obtaining page frame number passed to remap_pfn_range()
> (commit 35d9f510b67b10338161aba6229d4f55b4000f5b), videobuf-dma-contig

    Please specify the commit summary -- for the human readers.

> stopped working on my ARM based board. The ARM architecture maintainer,
> Russell King, confirmed that using something like
> virt_to_phys(dma_alloc_coherent()) is not supported on ARM, and can be
> broken on other architectures as well. The author of the change, Jiri
> Slaby, also confirmed that his code may not work on all architectures.

> The patch tries to solve this regression by using
> virt_to_phys(bus_to_virt(mem->dma_handle)) instead of problematic
> virt_to_phys(mem->vaddr). I think this should work even if those
> translations would occure inaccurate for DMA addresses, since possible
> errors introduced by both translations, performed in opposite
> directions, should compensate.

> Tested on ARM OMAP1 based Amstrad Delta board.

> Signed-off-by: Janusz Krzysztofik<jkrzyszt@tis.icnet.pl>

WBR, Sergei
