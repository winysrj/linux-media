Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03B1C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 23:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98EF821873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 23:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKGsdMA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbeLRXq6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 18:46:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41504 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbeLRXq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 18:46:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so17670877wrs.8;
        Tue, 18 Dec 2018 15:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KbmkHVRR2T41BCclyrdnoNUHVR6lfV8Mv4qBYZSJXaY=;
        b=bKGsdMA49097yQ0c8X3OH/vGy5FKHvkg0zw+LhC08YbF/jLkO+/4Vjutg5Yi34S0hR
         HzbxYuOAj1Kpm2md8dRXQSBbNxBC60wA1QFm85r8g88EnWeJ3UX0Bqmm2FA174LW4+de
         8YymjzgsZeNFnCzos0aEgx8afiRNenUTf3yCZn7wrMxMBpT6hLXMPeoNa4Q2vqomb+6s
         OvZ1oVLkEm5Bg1vs1Tr0dul9gBSalOkpbFshGZ0lfSxW3wYTr0OcXCwzZE9CodAle7JD
         A26qENOS0zKvBpQJQbwckfxVcN5IWbs9ThGtonByUmgRzt3hAkYOkb9N1nwN9yA+Qf17
         G2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KbmkHVRR2T41BCclyrdnoNUHVR6lfV8Mv4qBYZSJXaY=;
        b=PyxqvCiHs6yD45m+Fr4w+KueoJGCQKJfvc+GkAv7YTZ9vejy0QgHONP29txlOHZvbe
         RX+sZLeAVBbPLNeYNArvUuvUDnsIeju8nT6nwjL/MU4ddzdh0lLZQunfNp9kuHCNQGYv
         pqJvLdBilFgNsGFjNtarrAl/+Mscot0eLFDWR5lt7rTSWGqeBHk1CG9Nr8oRUIS22BJE
         vILKKoGJzUwVpBo6/EJfaGx5tJuZmnz/1ONvSzVYlqNo7Hjq88/cZ8crMI00gt7w0mg2
         aeF5bdcQuHON+mqsIEHaAxGQqYpO4EsyD4Qh+AyGOPqWf2I2Hl4BywAaxEQgxZJdl7sD
         fK7g==
X-Gm-Message-State: AA+aEWYZvTDuV1CUuZ/ij1umnWUZuaDOlA/dEQ0pBadUsJ12kpKWlHrE
        pB5neeG6nase+THHLiUn90L5SsRAvpjXXhpeO/4=
X-Google-Smtp-Source: AFSGD/XZkI8DvNAYyr8AEpyUTsMy7ssfAauePRecuoqF4ZE1eihrvpOqqMPbwoDOM8XTDK8o2uyBS/oXwTFqPE1OU8s=
X-Received: by 2002:a5d:5351:: with SMTP id t17mr16420976wrv.288.1545176814507;
 Tue, 18 Dec 2018 15:46:54 -0800 (PST)
MIME-Version: 1.0
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc> <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan> <8858694d5934ce78e46ef48d6f90061a@gmx.de>
 <20181216122315.2539ae80@coco.lan> <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
 <20181218104503.7ae94dd1@coco.lan>
In-Reply-To: <20181218104503.7ae94dd1@coco.lan>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 18 Dec 2018 18:46:40 -0500
Message-ID: <CADnq5_NWjA3J9__+rQ6yo9j_Gre7N+R==HyJHr0jT1d6vGr=Ow@mail.gmail.com>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     mchehab@kernel.org
Cc:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Markus Dobel <markus.dobel@gmx.de>,
        Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 18, 2018 at 7:45 AM Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
>
> Em Mon, 17 Dec 2018 21:05:11 -0500
> Alex Deucher <alexdeucher@gmail.com> escreveu:
>
> > On Sun, Dec 16, 2018 at 9:23 AM Mauro Carvalho Chehab
> > <mchehab@kernel.org> wrote:
> > >
> > > Em Sun, 16 Dec 2018 11:37:02 +0100
> > > Markus Dobel <markus.dobel@gmx.de> escreveu:
> > >
> > > > On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
> > > > > Em Thu, 06 Dec 2018 18:18:23 +0100
> > > > > Markus Dobel <markus.dobel@gmx.de> escreveu:
> > > > >
> > > > >> Hi everyone,
> > > > >>
> > > > >> I will try if the hack mentioned fixes the issue for me on the weekend
> > > > >> (but I assume, as if effectively removes the function).
> > > > >
> > > > > It should, but it keeps a few changes. Just want to be sure that what
> > > > > would be left won't cause issues. If this works, the logic that would
> > > > > solve Ryzen DMA fixes will be contained into a single point, making
> > > > > easier to maintain it.
> > > >
> > > > Hi,
> > > >
> > > > I wanted to have this setup running stable for a few days before
> > > > replying, that's why I am answering only now.
> > > >
> > > > But yes, as expected, with Mauro's hack, the driver has been stable for
> > > > me for about a week, with several
> > > > scheduled recordings in tvheadend, none of them missed.
> > > >
> > > > So, adding a reliable detection for affected chipsets, where the `if
> > > > (1)` currently is, should work.
> > >
> > > Markus,
> > >
> > > Thanks for testing!
> > >
> > > Brad/Alex,
> > >
> > > I guess we should then stick with this patch:
> > >         https://patchwork.linuxtv.org/patch/53351/
> > >
> > > The past approach that we used on cx88, bttv and other old drivers
> > > were to patch drivers/pci/quirks.c, making them to "taint" DMA
> > > memory controllers that were known to bad affect on media devices,
> > > and then some logic at the drivers to check for such "taint".
> > >
> > > However, that would require to touch another subsystem, with
> > > usually cause delays. Also, as Alex pointed, this could well
> > > be just a matter of incompatibility between the cx23885 and
> > > the Ryzen DMA controller, and may not affect any other drivers.
> > >
> > > So, let's start with a logic like what I proposed, fine
> > > tuning it to the Ryzen DMA controllers with we know have
> > > troubles with the driver.
> > >
> > > We need to list the PCI ID of the memory controllers at the
> > > device ID table on that patch, though. At the RFC patch,
> > > I just added an IOMMU PCI ID from a randon Ryzen CPU:
> > >
> > >         +static struct {
> > >         +       int vendor, dev;
> > >         +} const broken_dev_id[] = {
> > >         +       /* According with
> > >         +        * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
> > >         +        * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
> > >         +        */
> > >         +       { PCI_VENDOR_ID_AMD, 0x1451 },
> > >         +};
> > >         +
> > >
> > > Ideally, the ID for the affected Ryzen DMA engines should be there at
> > > include/linux/pci_ids.h, instead of hard-coded inside a driver.
> > >
> > > Also, we should, instead, add there the PCI IDs of the DMA engines
> > > that are known to have problems with the cx23885.
> >
> > These aren't really DMA engines.  Isn't this just the pcie bridge on the CPU?
>
> Yeah, it is not the DMA engine itself, but the CPU/chipset support for it.
>
> Let me be a little clearer. The Conexant chipsets for PCI/PCIe engines
> have internally a RISC CPU that it is programmed, in runtime, to do
> DMA scatter/gather. The actual DMA engine is there. For it to work, the
> Northbridge (or the CPU chipset - as nowadays several chipsets integrated
> the Northbridge inside an IP block at the CPU) has to do the counter part,
> by allowing the board's DMA engine to access the mainboard's main memory,
> usually via IOMMU, in a safe way[1].
>
> [1] preventing memory corruption if two devices try to do DMA to the
> same area, or if the DMA from the board tries to write at the same
> time the CPU tries to access it.
>
> Media PCI boards usually push the DMA logic to unusual conditions, as
> a large amount of data is transferred, in a synchronous way,
> between the PCIe card and memory.
>
> If the video stream is recorded, the same physical memory DMA mapped area
> where the data is written by the video board could be used on another DMA
> transfer via the HD disk controller.
>
> It is even possible to setup the Conexant's DMA engine to do transfers
> directly to the GPU's internal memory, causing a PCI to PCI DMA transfer,
> using V4L2 API overlay mode.

Is this supported today?  I didn't think all of the PCI and DMA API
changes had gone upstream yet for PCIe p2p support.  I think you'd
need to disable the IOMMU to work correctly.

>
> There was a time where it used to be common to have Intel CPUs (or
> Intel-compatible CPUs) using non-Intel North Bridges. On such time,
> we've seen a lot of troubles with PCI to PCI transfers most of them
> when using non-Intel north bridges.

Well p2p was problematic in general in the early days of pcie since it
wasn't part of the spec.  Things are only recently improving in that
regard.  Linux doesn't even have good pcie p2p support yet.

>
> With some north bridges, having the same block of memory mapped
> for two DMA operations (where memory writes come from the video
> card and memory reads from the HD disk controller) was also
> problematic, as the IOMMU had issues on managing two kinds of
> transfer for the same physical memory block.
>
> The report we have on the 95f408bb commit is:
>
>    "media: cx23885: Ryzen DMA related RiSC engine stall fixes
>
>     This bug affects all of Hauppauge QuadHD boards when used on all Ryzen
>     platforms and some XEON platforms. On these platforms it is possible to
>     error out the RiSC engine and cause it to stall, whereafter the only
>     way to reset the board to a working state is to reboot.
> ...
>     [  255.663598] cx23885: cx23885[0]: mpeg risc op code error"
>
> Brad could fill more details here, but I've seen the "risc op code
> error" before with bt878 and cx88 chipsets (with use a similar RISC).
> We usually get such error when there's a problem with the North Bridge
> that was not capable of doing their part at the DMA transfer.
>

What worries me is that the cx DMA engine seems to get into this state
even on non-Ryzen boards and in that case it doesn't seem to recover.
Hence Markus seeing hangs on his board with the workaround enabled
unconditionally.  Shouldn't it not get into that state in the first
place if the bridge is not problematic?  I'm concerned the we are just
papering over the real issue and we may end up causing stability
issues for platforms that are added to the list.

> As far as I know, the Hauppauge QuadHD boards can receive 4 different
> HD MPEG-TS streams (either from cable or air transmissions). On cable,
> one transponder can have up to ~40 Mbits/second. So, this board will
> produce 4 streams of up to 40 Mbps each, happening on different times,
> each filled in a synchronous way. As nobody watches 4 channels at
> the same time, it is safe to assume that at least 3 channels will
> be recorded (if not all 4 channels). So, we're talking about 320 MBps
> of traffic that may be competing with other DMA traffic (including
> some from the Kernel itself, in order to handle memory swap).
>
> That can be recording channels for several weeks.
>
> This usually pushes the North Bridge into their limits, and could
> be revealing some North Bridge/IOMMU issues that it would otherwise
> be not noticed under normal traffic.
>

GPUs push a lot of traffic too and we aren't seeing anything like this.


> > >
> > > There one thing that still bothers me: could this problem be due to
> > > some BIOS setup [1]? If so, are there any ways for dynamically
> > > disabling such features inside the driver?
> > >
> > > [1] like this: https://www.techarp.com/bios-guide/cpu-pci-write-buffer/
> > >
> >
> > possibly?  It's still not clear to me that this is specific to ryzen
> > chips rather than a problem with the DMA setup on the cx board.  Is
> > there a downside to enabling the workaround in general?
>
> The problem here is that the code with resets the DMA engine (required
> for it to work with Ryzen) causes trouble with non-Ryzen North Bridges.
>
> So, one solution that would fit all doesn't seem to exist.
>
> > The original commit mentioned that xeon platforms were affected as well.
>
> Xeon uses different chipsets and a different solution for the North
> Bridge functionality, with may explain why some Xeon CPUs have the
> same issue.
>

Shouldn't we add them to the list as well?

> > Is it possible it's just particular platforms with wonky bioses?
>
> Good point. Yeah, it could be triggered by a wonky bios or a bad setup
> (like enabling overclock or activating some chipset-specific feature
> that would increase the chance for a DMA transfer to fail).
>
> > Maybe DMI matching would be better?
>
> Mapping via DMI could work too, but it would be a way harder to map,
> as one would need to have a cx23885 board (if possible one with 4
> tuners) and a series of different machines in order to test it.
>
> Based with previous experiences with bttv and cx88, I suspect that
> we'll end by needing to map all machines with the same chipset.
>

Does anyone have a ryzen and the cx board and can they verify that
they are actually seeing hangs without the special reset code?  So far
I've only see non-Ryzen users complaining about hangs with the
workaround.

Alex

> >
> > > Brad,
> > >
> > > From your reports about the DMA issues, do you know what generations
> > > of the Ryzen are affected?
> > >
> > > Alex,
> > >
> > > Do you know if are there any differences at the IP block for the
> > > DMA engine used on different Ryzen CPUs? I mean: I suspect that
> > > the engine for Ryzen 2nd generation would likely be different than
> > > the one at the 1st generation, but, along the same generation, does
> > > the Ryzen 3, 5, 7 and Threadripper use the same DMA engine?
> >
> > + Suravee.  I'm not really familiar with the changes, if any, that are
> > in the pcie bridges on various AMD CPUs.  Or if there are changes, it
> > would be hard to say whether this issue would affect them or not.
> >
> > Alex
>
>
>
> Thanks,
> Mauro
