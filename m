Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60297
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752430AbcJGLLo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 07:11:44 -0400
Date: Fri, 7 Oct 2016 08:11:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jiri Kosina <jikos@kernel.org>
Cc: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Johannes Stezenbach <js@linuxtv.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
Message-ID: <20161007081136.1eb8fae9@vento.lan>
In-Reply-To: <alpine.LNX.2.00.1610070952010.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
        <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
        <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
        <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
        <20161005093417.6e82bd97@vdr>
        <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm>
        <20161005060450.1b0f2152@vento.lan>
        <20161005182945.nkpphvd6wtk6kq7h@linuxtv.org>
        <20161005155532.682258e2@vento.lan>
        <CADDKRnCV7YhD5ErkvWSL8P3adymCLqzp5OePYmGp0L=9Dt_=UA@mail.gmail.com>
        <20161006141734.4b2e4880@vento.lan>
        <alpine.LNX.2.00.1610070952010.31629@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 7 Oct 2016 09:52:56 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> escreveu:

> On Thu, 6 Oct 2016, Mauro Carvalho Chehab wrote:
> 
> > I can't see any other obvious error on the conversion. You could try to 
> > enable debug options at DVB core/dvb-usb and/or add some printk's to the 
> > driver and see what's happening.
> 
> Mauro, also please don't forget that there are many more places in 
> drivers/media that still perform DMA on stack, and so have to be fixed for 
> 4.9 (as VMAP_STACK makes that to be immediately visible problem even on 
> x86_64, which it wasn't the case before).

Yes, I'm aware of that. I'm doing the conversion of drivers under dvb-usb,
at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=media_dmastack_fixes

I'll be sending the patches to the ML after ready.

I'll then take a look on other USB drivers that use the stack. I guess
the non-USB media drivers are safe from this issue.

Thanks,
Mauro
