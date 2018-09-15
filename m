Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f177.google.com ([209.85.214.177]:36876 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725754AbeIOF7l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 01:59:41 -0400
Received: by mail-pl1-f177.google.com with SMTP id f1-v6so4898871plt.4
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 17:42:51 -0700 (PDT)
Date: Sat, 15 Sep 2018 10:42:39 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: David R <david@unsolicited.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        kungfujesus06@gmail.co
Subject: Re: cx23885 - regression between 4.17.x and 4.18.x
Message-ID: <20180915004236.GA15913@shambles.windy>
References: <47a0c36e-3247-bae4-674d-d8ae7d503a40@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47a0c36e-3247-bae4-674d-d8ae7d503a40@unsolicited.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2018 at 06:39:57PM +0100, David R wrote:
> Hi
> 
> Just a heads up. I'm having to revert cx23885-core.c to the 4.17 version
> to obtain stability with my old AMD Phenom/ASUS M4A785TD and Hauppauge
> WinTV-HVR-5525. The latest code drops out and refuses to return video
> streams in hours or a few days max. The 4.17 version is fine and stable
> over weeks/months.
> 
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
> PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)
>     Subsystem: Hauppauge computer works Inc. Device f038
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 0, Cache Line Size: 64 bytes
>     Interrupt: pin A routed to IRQ 17
>     Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
>     Capabilities: <access denied>
>     Kernel driver in use: cx23885

Interesting. cx88 also seems to have regressed.
Are you able to give a git commit range for what works & doesn't work?

I asked Adam to try building the modules with media-build
but have not heard anything further.

    Date: Sat, 8 Sep 2018 20:49:22 -0400
    From: Adam Stylinski <kungfujesus06@gmail.com>
    To: linux-media@vger.kernel.org
    Subject: 4.18 regression

    Hello,

    I haven't done a thorough bisection of kernel revisions, but moving from kernel 4.17.19
    to 4.18.6 results in mythtv being unable to tune in any channel with a pic hdtv 5500
    tuner (cx88 based device with an LG frontend). I get an error back from the channel
    scanner about not being able to measure signal strength and getting back an error unknown
    (errno 254).

    I was able to use dvbtools with get-atsc to get a channel, but I don't think any of the
    forward error correction was applied to it.

    Let me know if you need more details.

Vince
