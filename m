Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62050 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1DOM1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 08:27:25 -0400
Received: by wwa36 with SMTP id 36so3147412wwa.1
        for <linux-media@vger.kernel.org>; Fri, 15 Apr 2011 05:27:24 -0700 (PDT)
Message-ID: <4DA8394D.80405@ru.mvista.com>
Date: Fri, 15 Apr 2011 16:25:49 +0400
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
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <4DA5DF1E.1040302@ru.mvista.com> <201104132301.56210.jkrzyszt@tis.icnet.pl> <201104132316.01922.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201104132316.01922.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 14-04-2011 1:16, Janusz Krzysztofik wrote:

>>> Janusz Krzysztofik wrote:
>>>>>> After switching from mem->dma_handle to
>>>>>> virt_to_phys(mem->vaddr) used for obtaining page frame number
>>>>>> passed to remap_pfn_range() (commit
>>>>>> 35d9f510b67b10338161aba6229d4f55b4000f5b),
>>>>>> videobuf-dma-contig

>>>>>      Please specify the commit summary -- for the human readers.

>>>> Hi,
>>>> OK, I'll try to reword the summary using a more human friendly
>>>> language as soon as I have signs that Mauro (who seemed to
>>>> understand the message well enough) is willing to accept the
>>>> code.

>>>      I wasn't asking you to rework your summary but to specify the

>>> summary of the commit you've mentioned (in parens).

>> Ah, I see. How about just reordered wording:

>> After commit 35d9f510b67b10338161aba6229d4f55b4000f5b (switching from
>> mem->dma_handle to virt_to_phys(mem->vaddr) used for obtaining page
>> frame number passed to remap_pfn_range()), ....

>> Do you think this would be clear enough?

> Oh no, I probably missed your point again.

> You meant just quoting the commit original summary line, didn't you?

    Yes.

> Thanks,
> Janusz

WBR, Sergei
