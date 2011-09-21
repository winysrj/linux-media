Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 08:04:54 -0400
Received: by bkbzt4 with SMTP id zt4so1389369bkb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 05:04:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110921135604.64363a2e@skate>
References: <20110921135604.64363a2e@skate>
Date: Wed, 21 Sep 2011 08:04:52 -0400
Message-ID: <CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
Subject: Re: cx231xx: DMA problem on ARM
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 21, 2011 at 7:56 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Hello,
>
> On an x86 platform, we have managed to use a Hauppauge USB Live 2
> capture device with the cx231xx on a 3.0 kernel with the patch at [1].
> Things work nicely.
>
> However, using a similar 3.0 kernel with the exact same device on an
> ARM platform (BeagleBoard-XM), starting a V4L application to capture
> the video immediately triggers the following BUG_ON in
> arch/arm/mm/dma-mapping.c:
>
> 429 void ___dma_single_cpu_to_dev(const void *kaddr, size_t size,
> 430         enum dma_data_direction dir)
> 431 {
> 432         unsigned long paddr;
> 433
> 434         BUG_ON(!virt_addr_valid(kaddr) || !virt_addr_valid(kaddr + size - 1));
>
> This problem looks similar to the problem fixed on the gspca driver by:
>
> commit 882787ff8fdeb0be790547ee9b22b281095e95da
> Author: Jason Wang <jason77.wang@gmail.com>
> Date:   Fri Sep 3 06:57:19 2010 -0300
>
>    V4L/DVB: gspca - main: Fix a crash of some webcams on ARM arch
>
>    When plugging some webcams on ARM, the system crashes.
>    This is because we alloc buffer for an urb through usb_buffer_alloc,
>    the alloced buffer is already in DMA coherent region, so we should
>    set the flag of this urb to URB_NO_TRANSFER_DMA_MAP, otherwise when
>    we submit this urb, the hcd core will handle this address as an
>    non-DMA address and call dma_map_single/sg to map it. On arm
>    architecture, dma_map_single a DMA coherent address will be catched
>    by a BUG_ON().
>
>    Signed-off-by: Jason Wang <jason77.wang@gmail.com>
>    Signed-off-by: Jean-François Moine <moinejf@free.fr>
>    Cc: stable@kernel.org
>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> I guess the cx231xx driver is trying to DMA-map buffers whose location
> is not appropriate for DMA-mapping, because they are already in an DMA
> coherent region. Is the fix just to add the same
> URB_NO_TRANSFER_DMA_MAP to the urb->transfer_flags ? Or is it something
> completely different ?

Hi Thomas,

I ran into the same issue on em28xx in the past (which is what those
parts of cx231xx are based on).  Yes, just adding
URB_NO_TRANSFER_DMA_MAP should result in it starting to work.  Please
try that out, and assuming it works feel free to submit a patch which
can be included upstream.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
