Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:37555 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1DMVQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 17:16:37 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Wed, 13 Apr 2011 23:16:01 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <4DA5DF1E.1040302@ru.mvista.com> <201104132301.56210.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201104132301.56210.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104132316.01922.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia środa 13 kwiecień 2011 o 23:01:55 Janusz Krzysztofik napisał(a):
> Dnia środa 13 kwiecień 2011 o 19:36:30 Sergei Shtylyov napisał(a):
> > Hello.
> > 
> > Janusz Krzysztofik wrote:
> > >>> After switching from mem->dma_handle to
> > >>> virt_to_phys(mem->vaddr) used for obtaining page frame number
> > >>> passed to remap_pfn_range() (commit
> > >>> 35d9f510b67b10338161aba6229d4f55b4000f5b),
> > >>> videobuf-dma-contig
> > >>> 
> > >>     Please specify the commit summary -- for the human readers.
> > > 
> > > Hi,
> > > OK, I'll try to reword the summary using a more human friendly
> > > language as soon as I have signs that Mauro (who seemed to
> > > understand the message well enough) is willing to accept the
> > > code.
> > > 
> >     I wasn't asking you to rework your summary but to specify the
> > 
> > summary of the commit you've mentioned (in parens).
> 
> Ah, I see. How about just reordered wording:
> 
> After commit 35d9f510b67b10338161aba6229d4f55b4000f5b (switching from
> mem->dma_handle to virt_to_phys(mem->vaddr) used for obtaining page
> frame number passed to remap_pfn_range()), ....
> 
> Do you think this would be clear enough?

Oh no, I probably missed your point again.

You meant just quoting the commit original summary line, didn't you?

Thanks,
Janusz
