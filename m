Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753718AbcJGHw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 03:52:58 -0400
Date: Fri, 7 Oct 2016 09:52:56 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>,
        Johannes Stezenbach <js@linuxtv.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
In-Reply-To: <20161006141734.4b2e4880@vento.lan>
Message-ID: <alpine.LNX.2.00.1610070952010.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com> <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com> <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
 <20161005093417.6e82bd97@vdr> <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm> <20161005060450.1b0f2152@vento.lan> <20161005182945.nkpphvd6wtk6kq7h@linuxtv.org> <20161005155532.682258e2@vento.lan> <CADDKRnCV7YhD5ErkvWSL8P3adymCLqzp5OePYmGp0L=9Dt_=UA@mail.gmail.com>
 <20161006141734.4b2e4880@vento.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 6 Oct 2016, Mauro Carvalho Chehab wrote:

> I can't see any other obvious error on the conversion. You could try to 
> enable debug options at DVB core/dvb-usb and/or add some printk's to the 
> driver and see what's happening.

Mauro, also please don't forget that there are many more places in 
drivers/media that still perform DMA on stack, and so have to be fixed for 
4.9 (as VMAP_STACK makes that to be immediately visible problem even on 
x86_64, which it wasn't the case before).

Thanks,

-- 
Jiri Kosina
SUSE Labs

