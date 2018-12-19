Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E241CC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 19:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860B520874
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 19:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwPt8q9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbeLSTHk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 14:07:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46337 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbeLSTHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 14:07:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id l9so20587715wrt.13;
        Wed, 19 Dec 2018 11:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LG8RBAmRqUr8QBOsRSilDFqKF7a4Sr1DM90aap+gX4E=;
        b=fwPt8q9Wh8YiTFs2N1Ys1kutyQPfykpcpiRMQdpumXtv29MJXeMDWWANtQU1+Xw0PO
         U5H3HgF5FhONl7ko1bczUoLHBhAYcEQGrSMUHUiaAtNlKYK/pKqnZ8hVDICKSoERzdpL
         DGNgJcLKHgVKhaKXhhJM1FbwMaGMbmHpurkaT9QyMTi2jW3YToBebLOt7E5UqpcxJxRj
         tW9TPaBkzlVGDGIncjAWUJGgI7lLHfb0LMd0yQ/1X4lETbDKPomTFFp66TNoMjo1tccW
         CfbTPvbHaWKlmK6Z6fv9yZF/pHgPdXvbLi7RM5YmLuSqmcgyutNIN3xu7tpFJ0xIlS+4
         kL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LG8RBAmRqUr8QBOsRSilDFqKF7a4Sr1DM90aap+gX4E=;
        b=TSAVZhj5lI62oo5zun3Wxjb6JgFPE4m7pM4jXoUJym9EzWEn0i1RCSed4DAiiyVHkb
         4VN73RjEcD6DCEdIuEz8RShwsU6ZAfe2kOlN/ssMZDzGolDc+nR/Uw02KZuSZDwTkpTb
         j2iUIFnM0DprGMbvcSNIvNnV32MJerPaf2NVNzL7GSVGcjUBf2W9CKOGXRctOa5n7NJD
         6f8pKwENDOs8KKykWEClmYIm9vFfL8hK6Pc3ypoStcErw0zh2MKilw5zwryfrsNA6E5c
         bG26z/1JJyswxgCYrB/dy/oJBdhv8nDUhW+7wtlg4fyyWfo06I5nOm/UR1bjUzDAKSEY
         7x7w==
X-Gm-Message-State: AA+aEWa3EtbcV5RerAUQ3vqVqNpiWtJovMqYyqGBO+vCeTIpS+vbII3I
        Nx2VubeFEAtbn3RH0Zp54aSaDYzTiqZPaLre+E8=
X-Google-Smtp-Source: AFSGD/WBMu8yrx9esOgSrXFCFSbjKW0IwrQsFTjY2UWfdFVb+rkS/eNxlM0Qwb6dj9RQvF/TL3DX6HbNAsZZM7AnkG8=
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr18977003wrh.317.1545246456609;
 Wed, 19 Dec 2018 11:07:36 -0800 (PST)
MIME-Version: 1.0
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc> <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan> <8858694d5934ce78e46ef48d6f90061a@gmx.de>
 <20181216122315.2539ae80@coco.lan> <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
 <20181218104503.7ae94dd1@coco.lan> <CADnq5_NWjA3J9__+rQ6yo9j_Gre7N+R==HyJHr0jT1d6vGr=Ow@mail.gmail.com>
 <c985e00a-2fe7-f89a-7993-6efb2158611e@nextdimension.cc> <009e4b20-4872-60f5-de6f-ebd4711fea5f@nextdimension.cc>
In-Reply-To: <009e4b20-4872-60f5-de6f-ebd4711fea5f@nextdimension.cc>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 19 Dec 2018 14:07:24 -0500
Message-ID: <CADnq5_Op3uQNAKaKAisOLBfY7+tp4ZkwdjCBtbCLh-77j5fOjw@mail.gmail.com>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     Brad Love <brad@nextdimension.cc>
Cc:     mchehab@kernel.org,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Markus Dobel <markus.dobel@gmx.de>,
        linux-media <linux-media@vger.kernel.org>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 18, 2018 at 7:08 PM Brad Love <brad@nextdimension.cc> wrote:
>
>
> On 18/12/2018 18.05, Brad Love wrote:
> > On 18/12/2018 17.46, Alex Deucher wrote:
> >> On Tue, Dec 18, 2018 at 7:45 AM Mauro Carvalho Chehab
> >> <mchehab@kernel.org> wrote:
> >>> Em Mon, 17 Dec 2018 21:05:11 -0500
> >>> Alex Deucher <alexdeucher@gmail.com> escreveu:
> >>>
> >>>> On Sun, Dec 16, 2018 at 9:23 AM Mauro Carvalho Chehab
> >>>> <mchehab@kernel.org> wrote:
> >>>>> Em Sun, 16 Dec 2018 11:37:02 +0100
> >>>>> Markus Dobel <markus.dobel@gmx.de> escreveu:
> >>>>>
> >>>>>> On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
> >>>>>>> Em Thu, 06 Dec 2018 18:18:23 +0100
> >>>>>>> Markus Dobel <markus.dobel@gmx.de> escreveu:
> >>>>>>>
> >>>>>>>> Hi everyone,
> >>>>>>>>
> >>>>>>>> I will try if the hack mentioned fixes the issue for me on the weekend
> >>>>>>>> (but I assume, as if effectively removes the function).
> >>>>>>> It should, but it keeps a few changes. Just want to be sure that what
> >>>>>>> would be left won't cause issues. If this works, the logic that would
> >>>>>>> solve Ryzen DMA fixes will be contained into a single point, making
> >>>>>>> easier to maintain it.
> >>>>>> Hi,
> >>>>>>
> >>>>>> I wanted to have this setup running stable for a few days before
> >>>>>> replying, that's why I am answering only now.
> >>>>>>
> >>>>>> But yes, as expected, with Mauro's hack, the driver has been stable for
> >>>>>> me for about a week, with several
> >>>>>> scheduled recordings in tvheadend, none of them missed.
> >>>>>>
> >>>>>> So, adding a reliable detection for affected chipsets, where the `if
> >>>>>> (1)` currently is, should work.
> >>>>> Markus,
> >>>>>
> >>>>> Thanks for testing!
> >>>>>
> >>>>> Brad/Alex,
> >>>>>
> >>>>> I guess we should then stick with this patch:
> >>>>>         https://patchwork.linuxtv.org/patch/53351/
> >>>>>
> >>>>> The past approach that we used on cx88, bttv and other old drivers
> >>>>> were to patch drivers/pci/quirks.c, making them to "taint" DMA
> >>>>> memory controllers that were known to bad affect on media devices,
> >>>>> and then some logic at the drivers to check for such "taint".
> >>>>>
> >>>>> However, that would require to touch another subsystem, with
> >>>>> usually cause delays. Also, as Alex pointed, this could well
> >>>>> be just a matter of incompatibility between the cx23885 and
> >>>>> the Ryzen DMA controller, and may not affect any other drivers.
> >>>>>
> >>>>> So, let's start with a logic like what I proposed, fine
> >>>>> tuning it to the Ryzen DMA controllers with we know have
> >>>>> troubles with the driver.
> >>>>>
> >>>>> We need to list the PCI ID of the memory controllers at the
> >>>>> device ID table on that patch, though. At the RFC patch,
> >>>>> I just added an IOMMU PCI ID from a randon Ryzen CPU:
> >>>>>
> >>>>>         +static struct {
> >>>>>         +       int vendor, dev;
> >>>>>         +} const broken_dev_id[] = {
> >>>>>         +       /* According with
> >>>>>         +        * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
> >>>>>         +        * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
> >>>>>         +        */
> >>>>>         +       { PCI_VENDOR_ID_AMD, 0x1451 },
> >>>>>         +};
> >>>>>         +
> >>>>>
> >>>>> Ideally, the ID for the affected Ryzen DMA engines should be there at
> >>>>> include/linux/pci_ids.h, instead of hard-coded inside a driver.
> >>>>>
> >>>>> Also, we should, instead, add there the PCI IDs of the DMA engines
> >>>>> that are known to have problems with the cx23885.
> >>>> These aren't really DMA engines.  Isn't this just the pcie bridge on the CPU?
> >>> Yeah, it is not the DMA engine itself, but the CPU/chipset support for it.
> >>>
> >>> Let me be a little clearer. The Conexant chipsets for PCI/PCIe engines
> >>> have internally a RISC CPU that it is programmed, in runtime, to do
> >>> DMA scatter/gather. The actual DMA engine is there. For it to work, the
> >>> Northbridge (or the CPU chipset - as nowadays several chipsets integrated
> >>> the Northbridge inside an IP block at the CPU) has to do the counter part,
> >>> by allowing the board's DMA engine to access the mainboard's main memory,
> >>> usually via IOMMU, in a safe way[1].
> >>>
> >>> [1] preventing memory corruption if two devices try to do DMA to the
> >>> same area, or if the DMA from the board tries to write at the same
> >>> time the CPU tries to access it.
> >>>
> >>> Media PCI boards usually push the DMA logic to unusual conditions, as
> >>> a large amount of data is transferred, in a synchronous way,
> >>> between the PCIe card and memory.
> >>>
> >>> If the video stream is recorded, the same physical memory DMA mapped area
> >>> where the data is written by the video board could be used on another DMA
> >>> transfer via the HD disk controller.
> >>>
> >>> It is even possible to setup the Conexant's DMA engine to do transfers
> >>> directly to the GPU's internal memory, causing a PCI to PCI DMA transfer,
> >>> using V4L2 API overlay mode.
> >> Is this supported today?  I didn't think all of the PCI and DMA API
> >> changes had gone upstream yet for PCIe p2p support.  I think you'd
> >> need to disable the IOMMU to work correctly.
> >>
> >>> There was a time where it used to be common to have Intel CPUs (or
> >>> Intel-compatible CPUs) using non-Intel North Bridges. On such time,
> >>> we've seen a lot of troubles with PCI to PCI transfers most of them
> >>> when using non-Intel north bridges.
> >> Well p2p was problematic in general in the early days of pcie since it
> >> wasn't part of the spec.  Things are only recently improving in that
> >> regard.  Linux doesn't even have good pcie p2p support yet.
> >>
> >>> With some north bridges, having the same block of memory mapped
> >>> for two DMA operations (where memory writes come from the video
> >>> card and memory reads from the HD disk controller) was also
> >>> problematic, as the IOMMU had issues on managing two kinds of
> >>> transfer for the same physical memory block.
> >>>
> >>> The report we have on the 95f408bb commit is:
> >>>
> >>>    "media: cx23885: Ryzen DMA related RiSC engine stall fixes
> >>>
> >>>     This bug affects all of Hauppauge QuadHD boards when used on all Ryzen
> >>>     platforms and some XEON platforms. On these platforms it is possible to
> >>>     error out the RiSC engine and cause it to stall, whereafter the only
> >>>     way to reset the board to a working state is to reboot.
> >>> ...
> >>>     [  255.663598] cx23885: cx23885[0]: mpeg risc op code error"
> >>>
> >>> Brad could fill more details here, but I've seen the "risc op code
> >>> error" before with bt878 and cx88 chipsets (with use a similar RISC).
> >>> We usually get such error when there's a problem with the North Bridge
> >>> that was not capable of doing their part at the DMA transfer.
> >>>
> >> What worries me is that the cx DMA engine seems to get into this state
> >> even on non-Ryzen boards and in that case it doesn't seem to recover.
> >> Hence Markus seeing hangs on his board with the workaround enabled
> >> unconditionally.  Shouldn't it not get into that state in the first
> >> place if the bridge is not problematic?  I'm concerned the we are just
> >> papering over the real issue and we may end up causing stability
> >> issues for platforms that are added to the list.
> >
> > This issue was never reported to Hauppauge until the release of Ryzen
> > platform. The company support received lots of tickets and my github
> > page also got issues reported. The issue was only seen on the products
> > with 4 tuner/decoders. Those issues were tested and investigated on
> > github, and I had to source a Ryzen platform to do testing on my own. I
> > definitely saw this issue before the "fix". With this fix in place, the
> > stability that was seen on previous platforms was then seen on Ryzen
> > platforms. It is just after some time, now we see that the method used
> > on ryzen has adverse effects on other platforms.
> >
> > The possibility of adversely affecting various platforms is why I added
> > the three-way option. What I found in all of the reports I received was
> > some motherboard manufacturers released BIOS updates with workarounds.
> > Those workarounds fixed this and other issues. The MSI B350M motherboard
> > I have had not received any BIOS workaround fix as of a few months ago.
> > In the case a BIOS update renders this fix unnecessary and causes
> > adverse affects I want the ability to turn it off.
>
> I'd also just like to add, that those few platforms that did receive
> bios updates that addressed this during the period this was under test,
> were not adversely affected by the eventual fix.

Thanks for clarifying.  I'm ok with the patch.  Although as I
commented on the patch, we might want to use the Host bridge or one of
the pci bridges rather than the IOMMU to detect the platform since the
IOMMU can be disabled.  here's the lspci info for the gen1 ryzen I'm
currently sitting at:

00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Root Complex [1022:1450]
00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Family 17h
(Models 00h-0fh) I/O Memory Management Unit [1022:1451]
00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:01.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe GPP Bridge [1022:1453]
00:01.3 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe GPP Bridge [1022:1453]
00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:03.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:03.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe GPP Bridge [1022:1453]
00:04.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:07.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:07.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B [1022:1454]
00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) PCIe Dummy Host Bridge [1022:1452]
00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B [1022:1454]
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus
Controller [1022:790b] (rev 59)
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC
Bridge [1022:790e] (rev 51)
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0 [1022:1460]
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1 [1022:1461]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2 [1022:1462]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3 [1022:1463]
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4 [1022:1464]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5 [1022:1465]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6 [1022:1466]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7 [1022:1467]
01:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co
Ltd NVMe SSD Controller SM961/PM961 [144d:a804]
02:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset USB 3.1 xHCI Controller [1022:43bb] (rev 02)
02:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset SATA Controller [1022:43b7] (rev 02)
02:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device
[1022:43b2] (rev 02)
03:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset PCIe Port [1022:43b4] (rev 02)
03:01.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset PCIe Port [1022:43b4] (rev 02)
03:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset PCIe Port [1022:43b4] (rev 02)
03:06.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset PCIe Port [1022:43b4] (rev 02)
03:07.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300
Series Chipset PCIe Port [1022:43b4] (rev 02)
04:00.0 Ethernet controller [0200]: Intel Corporation I211 Gigabit
Network Connection [8086:1539] (rev 03)
09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
[AMD/ATI] Tonga PRO [Radeon R9 285/380] [1002:6939]
09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
Tonga HDMI Audio [Radeon R9 285/380] [1002:aad8]
0a:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices,
Inc. [AMD] Device [1022:145a]
0a:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc.
[AMD] Family 17h (Models 00h-0fh) Platform Security Processor
[1022:1456]
0a:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD]
Family 17h (Models 00h-0fh) USB 3.0 Host Controller [1022:145c]
0b:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices,
Inc. [AMD] Device [1022:1455]
0b:00.2 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH
SATA Controller [AHCI mode] [1022:7901] (rev 51)
0b:00.3 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family
17h (Models 00h-0fh) HD Audio Controller [1022:1457]

Alex

>
>
>
>
> > If you'd like to read the history there is discussion on the open and
> > closed issues here:
> >
> > https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/issues
> >
> >
> >
> >>> As far as I know, the Hauppauge QuadHD boards can receive 4 different
> >>> HD MPEG-TS streams (either from cable or air transmissions). On cable,
> >>> one transponder can have up to ~40 Mbits/second. So, this board will
> >>> produce 4 streams of up to 40 Mbps each, happening on different times,
> >>> each filled in a synchronous way. As nobody watches 4 channels at
> >>> the same time, it is safe to assume that at least 3 channels will
> >>> be recorded (if not all 4 channels). So, we're talking about 320 MBps
> >>> of traffic that may be competing with other DMA traffic (including
> >>> some from the Kernel itself, in order to handle memory swap).
> >>>
> >>> That can be recording channels for several weeks.
> >>>
> >>> This usually pushes the North Bridge into their limits, and could
> >>> be revealing some North Bridge/IOMMU issues that it would otherwise
> >>> be not noticed under normal traffic.
> >>>
> >> GPUs push a lot of traffic too and we aren't seeing anything like this.
> >>
> >>
> >>>>> There one thing that still bothers me: could this problem be due to
> >>>>> some BIOS setup [1]? If so, are there any ways for dynamically
> >>>>> disabling such features inside the driver?
> >>>>>
> >>>>> [1] like this: https://www.techarp.com/bios-guide/cpu-pci-write-buffer/
> >>>>>
> >>>> possibly?  It's still not clear to me that this is specific to ryzen
> >>>> chips rather than a problem with the DMA setup on the cx board.  Is
> >>>> there a downside to enabling the workaround in general?
> >>> The problem here is that the code with resets the DMA engine (required
> >>> for it to work with Ryzen) causes trouble with non-Ryzen North Bridges.
> >>>
> >>> So, one solution that would fit all doesn't seem to exist.
> >>>
> >>>> The original commit mentioned that xeon platforms were affected as well.
> >>> Xeon uses different chipsets and a different solution for the North
> >>> Bridge functionality, with may explain why some Xeon CPUs have the
> >>> same issue.
> >>>
> >> Shouldn't we add them to the list as well?
> >>
> >>>> Is it possible it's just particular platforms with wonky bioses?
> >>> Good point. Yeah, it could be triggered by a wonky bios or a bad setup
> >>> (like enabling overclock or activating some chipset-specific feature
> >>> that would increase the chance for a DMA transfer to fail).
> >>>
> >>>> Maybe DMI matching would be better?
> >>> Mapping via DMI could work too, but it would be a way harder to map,
> >>> as one would need to have a cx23885 board (if possible one with 4
> >>> tuners) and a series of different machines in order to test it.
> >>>
> >>> Based with previous experiences with bttv and cx88, I suspect that
> >>> we'll end by needing to map all machines with the same chipset.
> >>>
> >> Does anyone have a ryzen and the cx board and can they verify that
> >> they are actually seeing hangs without the special reset code?  So far
> >> I've only see non-Ryzen users complaining about hangs with the
> >> workaround.
> >
> > See above. I'm the Hauppauge engineer that worked on this.
> >
> >
> >
> >
> >
> >> Alex
> >>
> >>>>> Brad,
> >>>>>
> >>>>> From your reports about the DMA issues, do you know what generations
> >>>>> of the Ryzen are affected?
> >>>>>
> >>>>> Alex,
> >>>>>
> >>>>> Do you know if are there any differences at the IP block for the
> >>>>> DMA engine used on different Ryzen CPUs? I mean: I suspect that
> >>>>> the engine for Ryzen 2nd generation would likely be different than
> >>>>> the one at the 1st generation, but, along the same generation, does
> >>>>> the Ryzen 3, 5, 7 and Threadripper use the same DMA engine?
> >>>> + Suravee.  I'm not really familiar with the changes, if any, that are
> >>>> in the pcie bridges on various AMD CPUs.  Or if there are changes, it
> >>>> would be hard to say whether this issue would affect them or not.
> >>>>
> >>>> Alex
> >>>
> >>> Thanks,
> >>> Mauro
