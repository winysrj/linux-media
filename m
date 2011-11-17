Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35573 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1KQKz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:55:29 -0500
Received: by vcbfk1 with SMTP id fk1so1498122vcb.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 02:55:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111041141.28698.laurent.pinchart@ideasonboard.com>
References: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com>
	<CAGoCfiym+uCKq7ZuxrryO-ofboA2WG_R4JEGZ6AgN18JbX_YQQ@mail.gmail.com>
	<CACKLOr3toejVFDgKzi+=KC6_O5qWaQxcwV6qc3zwK_r2H+mkNw@mail.gmail.com>
	<201111041141.28698.laurent.pinchart@ideasonboard.com>
Date: Thu, 17 Nov 2011 11:55:28 +0100
Message-ID: <CACKLOr0jPK0Oi9yXzZ2Tk-1EM+Pava=qByGCqpT1nuxjmoNMXA@mail.gmail.com>
Subject: Re: UVC with continuous video buffers.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 November 2011 11:41, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Wednesday 02 November 2011 17:33:16 javier Martin wrote:
>> On 2 November 2011 17:12, Devin Heitmueller wrote:
>> > I've actually got a very similar issue and have been looking into it
>> > (an em28xx device on OMAP requiring contiguous physical memory for the
>> > hardware H.264 encoder).  One thing you may definitely want to check
>> > out is the patch sent earlier today with subject:
>>
>> My case is a i.MX27 SoC with its internal H.264 encoder.
>>
>> > [PATCH] media: vb2: vmalloc-based allocator user pointer handling
>> >
> However, the above patch that adds user pointer support in the videobuf2
> vmalloc-based allocator only supports memory backed by pages. If you
> contiguous buffer is in a memory area reserved by the system at boot time, the
> assumption will not be true. Supporting user pointers with no struct page
> backing is possible, but will require a new patch for vb2.
>

Hi Laurent,
thanks for your help.

I am using dma_declare_coherent_memory() at startup to reserve memory.
Then I use dma_alloc_coherent() in my driver through
'videobuf2-dma-contig.h' (emma-PrP I've recently submitted). I
understand these functions provide memory backed by pages and you are
referring to the case where you use the 'mem' argument of the kernel
to leave memory unused. Am I right?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
