Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753589AbcJEH0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:26:32 -0400
Date: Wed, 5 Oct 2016 09:26:29 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
In-Reply-To: <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com> <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Oct 2016, Jörg Otte wrote:

> Thanks for the quick response.
> Drivers are:
> dvb_core, dvb_usb, dbv_usb_cynergyT2

This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't seem to be 
able to find it, and the only google hit I am getting is your very mail to 
LKML :)

-- 
Jiri Kosina
SUSE Labs

