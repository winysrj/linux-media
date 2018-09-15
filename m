Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.unsolicited.net ([173.255.193.191]:18007 "EHLO
        mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeIONsn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 09:48:43 -0400
Subject: Re: cx23885 - regression between 4.17.x and 4.18.x
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        kungfujesus06@gmail.co
References: <47a0c36e-3247-bae4-674d-d8ae7d503a40@unsolicited.net>
 <20180915004236.GA15913@shambles.windy>
From: David R <david@unsolicited.net>
Message-ID: <ecf9e315-7daa-f2af-274f-68e054fa631b@unsolicited.net>
Date: Sat, 15 Sep 2018 09:30:30 +0100
MIME-Version: 1.0
In-Reply-To: <20180915004236.GA15913@shambles.windy>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any bisection would take ages, as I need to run for approaching a week
to be sure. There are only 3 commits that are possible.

commit 95f408bbc4e4d46c75da3d2558dd835e56ac7720
Author: Brad Love <brad@nextdimension.cc>
Date:   Tue May 8 17:20:18 2018 -0400

    media: cx23885: Ryzen DMA related RiSC engine stall fixes

commit 3b8315f37d6eaa36f0f2e484eabaef03a7bd1eff
Author: Brad Love <brad@nextdimension.cc>
Date:   Tue May 8 17:20:17 2018 -0400

    media: cx23885: Use PCI and TS masks in irq functions

commit 9a7dc2b064ef7477d4c3a477f4de0a44b3a40cbd
Author: Brad Love <brad@nextdimension.cc>
Date:   Tue May 8 17:20:16 2018 -0400

    media: cx23885: Handle additional bufs on interrupt

Cheers
David

On 15/09/18 01:42, Vincent McIntyre wrote:
> On Thu, Sep 13, 2018 at 06:39:57PM +0100, David R wrote:
>> Hi
>>
>> Just a heads up. I'm having to revert cx23885-core.c to the 4.17 version
>> to obtain stability with my old AMD Phenom/ASUS M4A785TD and Hauppauge
>> WinTV-HVR-5525. The latest code drops out and refuses to return video
>> streams in hours or a few days max. The 4.17 version is fine and stable
>> over weeks/months.
>>
>> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
>> PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)
>>     Subsystem: Hauppauge computer works Inc. Device f038
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR+ FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Interrupt: pin A routed to IRQ 17
>>     Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
>>     Capabilities: <access denied>
>>     Kernel driver in use: cx23885
> Interesting. cx88 also seems to have regressed.
> Are you able to give a git commit range for what works & doesn't work?
>
> I asked Adam to try building the modules with media-build
> but have not heard anything further.
>
>     Date: Sat, 8 Sep 2018 20:49:22 -0400
>     From: Adam Stylinski <kungfujesus06@gmail.com>
>     To: linux-media@vger.kernel.org
>     Subject: 4.18 regression
>
>     Hello,
>
>     I haven't done a thorough bisection of kernel revisions, but moving from kernel 4.17.19
>     to 4.18.6 results in mythtv being unable to tune in any channel with a pic hdtv 5500
>     tuner (cx88 based device with an LG frontend). I get an error back from the channel
>     scanner about not being able to measure signal strength and getting back an error unknown
>     (errno 254).
>
>     I was able to use dvbtools with get-atsc to get a channel, but I don't think any of the
>     forward error correction was applied to it.
>
>     Let me know if you need more details.
>
> Vince
