Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1DNLSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 07:18:55 -0400
Received: by bwz15 with SMTP id 15so1276855bwz.19
        for <linux-media@vger.kernel.org>; Thu, 14 Apr 2011 04:18:53 -0700 (PDT)
Message-ID: <4DA6D7BE.8070702@ru.mvista.com>
Date: Thu, 14 Apr 2011 15:17:18 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken
 on ARM
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <201104131511.42171.jkrzyszt@tis.icnet.pl> <4DA5DF1E.1040302@ru.mvista.com> <201104132301.56210.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201104132301.56210.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 14-04-2011 1:01, Janusz Krzysztofik wrote:

>>>>> After switching from mem->dma_handle to virt_to_phys(mem->vaddr)
>>>>> used for obtaining page frame number passed to remap_pfn_range()
>>>>> (commit 35d9f510b67b10338161aba6229d4f55b4000f5b),
>>>>> videobuf-dma-contig

>>>>      Please specify the commit summary -- for the human readers.

>>> Hi,
>>> OK, I'll try to reword the summary using a more human friendly
>>> language as soon as I have signs that Mauro (who seemed to
>>> understand the message well enough) is willing to accept the code.

>>      I wasn't asking you to rework your summary but to specify the
>> summary of the commit you've mentioned (in parens).

> Ah, I see. How about just reordered wording:

> After commit 35d9f510b67b10338161aba6229d4f55b4000f5b (switching from
> mem->dma_handle to virt_to_phys(mem->vaddr) used for obtaining page
> frame number passed to remap_pfn_range()), ....

> Do you think this would be clear enough?

    As I can see, the summary of that commit is "[media] V4L: videobuf, don't 
use dma addr as physical". That's what you should have inserted.

> Thanks,
> Janusz

WBR, Sergei
