Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:51204 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1DMNMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 09:12:22 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Wed, 13 Apr 2011 15:11:41 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <4DA59120.1070402@ru.mvista.com>
In-Reply-To: <4DA59120.1070402@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104131511.42171.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia środa 13 kwiecień 2011 o 14:03:44 Sergei Shtylyov napisał(a):
> Hello.
> 
> On 13-04-2011 1:06, Janusz Krzysztofik wrote:
> > After switching from mem->dma_handle to virt_to_phys(mem->vaddr)
> > used for obtaining page frame number passed to remap_pfn_range()
> > (commit 35d9f510b67b10338161aba6229d4f55b4000f5b),
> > videobuf-dma-contig
> 
>     Please specify the commit summary -- for the human readers.

Hi,
OK, I'll try to reword the summary using a more human friendly language 
as soon as I have signs that Mauro (who seemed to understand the message 
well enough) is willing to accept the code.

Thanks,
Janusz
