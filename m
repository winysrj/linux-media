Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbcJEHup (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:50:45 -0400
Date: Wed, 5 Oct 2016 09:50:42 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
cc: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
In-Reply-To: <20161005093417.6e82bd97@vdr>
Message-ID: <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com> <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com> <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
 <20161005093417.6e82bd97@vdr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Oct 2016, Patrick Boettcher wrote:

> > > Thanks for the quick response.
> > > Drivers are:
> > > dvb_core, dvb_usb, dbv_usb_cynergyT2  
> > 
> > This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't seem
> > to be able to find it, and the only google hit I am getting is your
> > very mail to LKML :)
> 
> It's a typo, it should say dvb_usb_cinergyT2.

Ah, thanks. Same issues there in

	cinergyt2_frontend_attach()
	cinergyt2_rc_query()

I think this would require more in-depth review of all the media drivers 
and having all this fixed for 4.9. It should be pretty straightforward; 
all the instances I've seen so far should be just straightforward 
conversion to kmalloc() + kfree(), as the buffer is not being embedded in 
any structure etc.

-- 
Jiri Kosina
SUSE Labs

