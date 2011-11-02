Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35863 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab1KBQdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 12:33:19 -0400
Received: by faao14 with SMTP id o14so584686faa.19
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2011 09:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiym+uCKq7ZuxrryO-ofboA2WG_R4JEGZ6AgN18JbX_YQQ@mail.gmail.com>
References: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com>
	<CAGoCfiym+uCKq7ZuxrryO-ofboA2WG_R4JEGZ6AgN18JbX_YQQ@mail.gmail.com>
Date: Wed, 2 Nov 2011 17:33:16 +0100
Message-ID: <CACKLOr3toejVFDgKzi+=KC6_O5qWaQxcwV6qc3zwK_r2H+mkNw@mail.gmail.com>
Subject: Re: UVC with continuous video buffers.
From: javier Martin <javier.martin@vista-silicon.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,
thank you for your answer.

On 2 November 2011 17:12, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> I've actually got a very similar issue and have been looking into it
> (an em28xx device on OMAP requiring contiguous physical memory for the
> hardware H.264 encoder).  One thing you may definitely want to check
> out is the patch sent earlier today with subject:

My case is a i.MX27 SoC with its internal H.264 encoder.


> [PATCH] media: vb2: vmalloc-based allocator user pointer handling
>
> While that patch is intended for videobuf2, you might be able to copy
> the core logic into videobuf-vmalloc.

I've seen a recent patch by Laurent Pinchart which provides vb2
support for UVC driver. It might also help:

[PATCH 2/2] uvcvideo: Use videobuf2-vmalloc


> There are other drivers which use USERPTR provided buffers (which are
> allocated as contiguous memory from userland [i.e. vfpe_capture
> accepting buffers from cmemk on the OMAP platform]), but they
> typically do DMA so it's not really useful as an example where you
> have a USB based device.
>
> If you get it working, by all means send the code to the ML so others
> can benefit.

Sure, though I will need some help because it seems some related
frameworks are not ready for what we want to achieve.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
