Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1AAC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 00:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438CA21873
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 00:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="tZ9C1jSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbeLSAIc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 19:08:32 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:23071
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbeLSAIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 19:08:32 -0500
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 388A7501D55;
        Wed, 19 Dec 2018 00:08:28 +0000 (UTC)
Received: from pdx1-sub0-mail-a57.g.dreamhost.com (unknown [100.96.19.78])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id B802950270D;
        Wed, 19 Dec 2018 00:08:27 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from pdx1-sub0-mail-a57.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Wed, 19 Dec 2018 00:08:28 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@b-rad.cc
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Abortive: 7c0030f54dadeb8d_1545178108010_3307371121
X-MC-Loop-Signature: 1545178108010:1663786278
X-MC-Ingress-Time: 1545178108010
Received: from pdx1-sub0-mail-a57.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a57.g.dreamhost.com (Postfix) with ESMTP id 6988C81C3B;
        Tue, 18 Dec 2018 16:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=
        nextdimension.cc; bh=MJSxodW8MXlg4gciLGuPBzZR5X4=; b=tZ9C1jSAgCu
        DuEguPTd7MMRYj/BIJztxTXIEGqfkzCyrASMvazjFvESpmPLyOosMeb5s+CSLm9Z
        4g11HKqYMlh7mQdsKkCQYfdTXZz2HnqgM2o9fxsQPJTKT+G/LL9TOmtCtx/LJaS1
        exuZbouHYvLlaBqdyXRTZho3/gdqcd4I=
Received: from [192.168.0.21] (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@b-rad.cc)
        by pdx1-sub0-mail-a57.g.dreamhost.com (Postfix) with ESMTPSA id A8E7D81C1C;
        Tue, 18 Dec 2018 16:08:25 -0800 (PST)
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     Brad Love <brad@nextdimension.cc>,
        Alex Deucher <alexdeucher@gmail.com>, mchehab@kernel.org
Cc:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Markus Dobel <markus.dobel@gmx.de>,
        linux-media <linux-media@vger.kernel.org>,
        linux-media-owner@vger.kernel.org
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
 <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
 <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan> <8858694d5934ce78e46ef48d6f90061a@gmx.de>
 <20181216122315.2539ae80@coco.lan>
 <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
 <20181218104503.7ae94dd1@coco.lan>
 <CADnq5_NWjA3J9__+rQ6yo9j_Gre7N+R==HyJHr0jT1d6vGr=Ow@mail.gmail.com>
 <c985e00a-2fe7-f89a-7993-6efb2158611e@nextdimension.cc>
X-DH-BACKEND: pdx1-sub0-mail-a57
From:   Brad Love <brad@nextdimension.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=brad@nextdimension.cc; prefer-encrypt=mutual; keydata=
 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
Message-ID: <009e4b20-4872-60f5-de6f-ebd4711fea5f@nextdimension.cc>
Date:   Tue, 18 Dec 2018 18:08:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c985e00a-2fe7-f89a-7993-6efb2158611e@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -90
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudeikedgudefvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucffohhmrghinhepohhpvghnsggvnhgthhhmrghrkhhinhhgrdhorhhgpdhgihhthhhusgdrtghomhdplhhinhhugihtvhdrohhrghdpthgvtghhrghrphdrtghomhenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgduledvrdduieekrddtrddvudgnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 18/12/2018 18.05, Brad Love wrote:
> On 18/12/2018 17.46, Alex Deucher wrote:
>> On Tue, Dec 18, 2018 at 7:45 AM Mauro Carvalho Chehab
>> <mchehab@kernel.org> wrote:
>>> Em Mon, 17 Dec 2018 21:05:11 -0500
>>> Alex Deucher <alexdeucher@gmail.com> escreveu:
>>>
>>>> On Sun, Dec 16, 2018 at 9:23 AM Mauro Carvalho Chehab
>>>> <mchehab@kernel.org> wrote:
>>>>> Em Sun, 16 Dec 2018 11:37:02 +0100
>>>>> Markus Dobel <markus.dobel@gmx.de> escreveu:
>>>>>
>>>>>> On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
>>>>>>> Em Thu, 06 Dec 2018 18:18:23 +0100
>>>>>>> Markus Dobel <markus.dobel@gmx.de> escreveu:
>>>>>>>
>>>>>>>> Hi everyone,
>>>>>>>>
>>>>>>>> I will try if the hack mentioned fixes the issue for me on the weekend
>>>>>>>> (but I assume, as if effectively removes the function).
>>>>>>> It should, but it keeps a few changes. Just want to be sure that what
>>>>>>> would be left won't cause issues. If this works, the logic that would
>>>>>>> solve Ryzen DMA fixes will be contained into a single point, making
>>>>>>> easier to maintain it.
>>>>>> Hi,
>>>>>>
>>>>>> I wanted to have this setup running stable for a few days before
>>>>>> replying, that's why I am answering only now.
>>>>>>
>>>>>> But yes, as expected, with Mauro's hack, the driver has been stable for
>>>>>> me for about a week, with several
>>>>>> scheduled recordings in tvheadend, none of them missed.
>>>>>>
>>>>>> So, adding a reliable detection for affected chipsets, where the `if
>>>>>> (1)` currently is, should work.
>>>>> Markus,
>>>>>
>>>>> Thanks for testing!
>>>>>
>>>>> Brad/Alex,
>>>>>
>>>>> I guess we should then stick with this patch:
>>>>>         https://patchwork.linuxtv.org/patch/53351/
>>>>>
>>>>> The past approach that we used on cx88, bttv and other old drivers
>>>>> were to patch drivers/pci/quirks.c, making them to "taint" DMA
>>>>> memory controllers that were known to bad affect on media devices,
>>>>> and then some logic at the drivers to check for such "taint".
>>>>>
>>>>> However, that would require to touch another subsystem, with
>>>>> usually cause delays. Also, as Alex pointed, this could well
>>>>> be just a matter of incompatibility between the cx23885 and
>>>>> the Ryzen DMA controller, and may not affect any other drivers.
>>>>>
>>>>> So, let's start with a logic like what I proposed, fine
>>>>> tuning it to the Ryzen DMA controllers with we know have
>>>>> troubles with the driver.
>>>>>
>>>>> We need to list the PCI ID of the memory controllers at the
>>>>> device ID table on that patch, though. At the RFC patch,
>>>>> I just added an IOMMU PCI ID from a randon Ryzen CPU:
>>>>>
>>>>>         +static struct {
>>>>>         +       int vendor, dev;
>>>>>         +} const broken_dev_id[] = {
>>>>>         +       /* According with
>>>>>         +        * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
>>>>>         +        * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
>>>>>         +        */
>>>>>         +       { PCI_VENDOR_ID_AMD, 0x1451 },
>>>>>         +};
>>>>>         +
>>>>>
>>>>> Ideally, the ID for the affected Ryzen DMA engines should be there at
>>>>> include/linux/pci_ids.h, instead of hard-coded inside a driver.
>>>>>
>>>>> Also, we should, instead, add there the PCI IDs of the DMA engines
>>>>> that are known to have problems with the cx23885.
>>>> These aren't really DMA engines.  Isn't this just the pcie bridge on the CPU?
>>> Yeah, it is not the DMA engine itself, but the CPU/chipset support for it.
>>>
>>> Let me be a little clearer. The Conexant chipsets for PCI/PCIe engines
>>> have internally a RISC CPU that it is programmed, in runtime, to do
>>> DMA scatter/gather. The actual DMA engine is there. For it to work, the
>>> Northbridge (or the CPU chipset - as nowadays several chipsets integrated
>>> the Northbridge inside an IP block at the CPU) has to do the counter part,
>>> by allowing the board's DMA engine to access the mainboard's main memory,
>>> usually via IOMMU, in a safe way[1].
>>>
>>> [1] preventing memory corruption if two devices try to do DMA to the
>>> same area, or if the DMA from the board tries to write at the same
>>> time the CPU tries to access it.
>>>
>>> Media PCI boards usually push the DMA logic to unusual conditions, as
>>> a large amount of data is transferred, in a synchronous way,
>>> between the PCIe card and memory.
>>>
>>> If the video stream is recorded, the same physical memory DMA mapped area
>>> where the data is written by the video board could be used on another DMA
>>> transfer via the HD disk controller.
>>>
>>> It is even possible to setup the Conexant's DMA engine to do transfers
>>> directly to the GPU's internal memory, causing a PCI to PCI DMA transfer,
>>> using V4L2 API overlay mode.
>> Is this supported today?  I didn't think all of the PCI and DMA API
>> changes had gone upstream yet for PCIe p2p support.  I think you'd
>> need to disable the IOMMU to work correctly.
>>
>>> There was a time where it used to be common to have Intel CPUs (or
>>> Intel-compatible CPUs) using non-Intel North Bridges. On such time,
>>> we've seen a lot of troubles with PCI to PCI transfers most of them
>>> when using non-Intel north bridges.
>> Well p2p was problematic in general in the early days of pcie since it
>> wasn't part of the spec.  Things are only recently improving in that
>> regard.  Linux doesn't even have good pcie p2p support yet.
>>
>>> With some north bridges, having the same block of memory mapped
>>> for two DMA operations (where memory writes come from the video
>>> card and memory reads from the HD disk controller) was also
>>> problematic, as the IOMMU had issues on managing two kinds of
>>> transfer for the same physical memory block.
>>>
>>> The report we have on the 95f408bb commit is:
>>>
>>>    "media: cx23885: Ryzen DMA related RiSC engine stall fixes
>>>
>>>     This bug affects all of Hauppauge QuadHD boards when used on all Ryzen
>>>     platforms and some XEON platforms. On these platforms it is possible to
>>>     error out the RiSC engine and cause it to stall, whereafter the only
>>>     way to reset the board to a working state is to reboot.
>>> ...
>>>     [  255.663598] cx23885: cx23885[0]: mpeg risc op code error"
>>>
>>> Brad could fill more details here, but I've seen the "risc op code
>>> error" before with bt878 and cx88 chipsets (with use a similar RISC).
>>> We usually get such error when there's a problem with the North Bridge
>>> that was not capable of doing their part at the DMA transfer.
>>>
>> What worries me is that the cx DMA engine seems to get into this state
>> even on non-Ryzen boards and in that case it doesn't seem to recover.
>> Hence Markus seeing hangs on his board with the workaround enabled
>> unconditionally.  Shouldn't it not get into that state in the first
>> place if the bridge is not problematic?  I'm concerned the we are just
>> papering over the real issue and we may end up causing stability
>> issues for platforms that are added to the list.
>
> This issue was never reported to Hauppauge until the release of Ryzen
> platform. The company support received lots of tickets and my github
> page also got issues reported. The issue was only seen on the products
> with 4 tuner/decoders. Those issues were tested and investigated on
> github, and I had to source a Ryzen platform to do testing on my own. I
> definitely saw this issue before the "fix". With this fix in place, the
> stability that was seen on previous platforms was then seen on Ryzen
> platforms. It is just after some time, now we see that the method used
> on ryzen has adverse effects on other platforms.
>
> The possibility of adversely affecting various platforms is why I added
> the three-way option. What I found in all of the reports I received was
> some motherboard manufacturers released BIOS updates with workarounds.
> Those workarounds fixed this and other issues. The MSI B350M motherboard
> I have had not received any BIOS workaround fix as of a few months ago.
> In the case a BIOS update renders this fix unnecessary and causes
> adverse affects I want the ability to turn it off.

I'd also just like to add, that those few platforms that did receive
bios updates that addressed this during the period this was under test,
were not adversely affected by the eventual fix.




> If you'd like to read the history there is discussion on the open and
> closed issues here:
>
> https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/issues
>
>
>
>>> As far as I know, the Hauppauge QuadHD boards can receive 4 different
>>> HD MPEG-TS streams (either from cable or air transmissions). On cable,
>>> one transponder can have up to ~40 Mbits/second. So, this board will
>>> produce 4 streams of up to 40 Mbps each, happening on different times,
>>> each filled in a synchronous way. As nobody watches 4 channels at
>>> the same time, it is safe to assume that at least 3 channels will
>>> be recorded (if not all 4 channels). So, we're talking about 320 MBps
>>> of traffic that may be competing with other DMA traffic (including
>>> some from the Kernel itself, in order to handle memory swap).
>>>
>>> That can be recording channels for several weeks.
>>>
>>> This usually pushes the North Bridge into their limits, and could
>>> be revealing some North Bridge/IOMMU issues that it would otherwise
>>> be not noticed under normal traffic.
>>>
>> GPUs push a lot of traffic too and we aren't seeing anything like this.
>>
>>
>>>>> There one thing that still bothers me: could this problem be due to
>>>>> some BIOS setup [1]? If so, are there any ways for dynamically
>>>>> disabling such features inside the driver?
>>>>>
>>>>> [1] like this: https://www.techarp.com/bios-guide/cpu-pci-write-buffer/
>>>>>
>>>> possibly?  It's still not clear to me that this is specific to ryzen
>>>> chips rather than a problem with the DMA setup on the cx board.  Is
>>>> there a downside to enabling the workaround in general?
>>> The problem here is that the code with resets the DMA engine (required
>>> for it to work with Ryzen) causes trouble with non-Ryzen North Bridges.
>>>
>>> So, one solution that would fit all doesn't seem to exist.
>>>
>>>> The original commit mentioned that xeon platforms were affected as well.
>>> Xeon uses different chipsets and a different solution for the North
>>> Bridge functionality, with may explain why some Xeon CPUs have the
>>> same issue.
>>>
>> Shouldn't we add them to the list as well?
>>
>>>> Is it possible it's just particular platforms with wonky bioses?
>>> Good point. Yeah, it could be triggered by a wonky bios or a bad setup
>>> (like enabling overclock or activating some chipset-specific feature
>>> that would increase the chance for a DMA transfer to fail).
>>>
>>>> Maybe DMI matching would be better?
>>> Mapping via DMI could work too, but it would be a way harder to map,
>>> as one would need to have a cx23885 board (if possible one with 4
>>> tuners) and a series of different machines in order to test it.
>>>
>>> Based with previous experiences with bttv and cx88, I suspect that
>>> we'll end by needing to map all machines with the same chipset.
>>>
>> Does anyone have a ryzen and the cx board and can they verify that
>> they are actually seeing hangs without the special reset code?  So far
>> I've only see non-Ryzen users complaining about hangs with the
>> workaround.
>
> See above. I'm the Hauppauge engineer that worked on this.
>
>
>
>
>
>> Alex
>>
>>>>> Brad,
>>>>>
>>>>> From your reports about the DMA issues, do you know what generations
>>>>> of the Ryzen are affected?
>>>>>
>>>>> Alex,
>>>>>
>>>>> Do you know if are there any differences at the IP block for the
>>>>> DMA engine used on different Ryzen CPUs? I mean: I suspect that
>>>>> the engine for Ryzen 2nd generation would likely be different than
>>>>> the one at the 1st generation, but, along the same generation, does
>>>>> the Ryzen 3, 5, 7 and Threadripper use the same DMA engine?
>>>> + Suravee.  I'm not really familiar with the changes, if any, that are
>>>> in the pcie bridges on various AMD CPUs.  Or if there are changes, it
>>>> would be hard to say whether this issue would affect them or not.
>>>>
>>>> Alex
>>>
>>> Thanks,
>>> Mauro
