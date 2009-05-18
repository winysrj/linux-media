Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:56339 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbZERXTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 19:19:47 -0400
Subject: Re: Fixed (Was:Re: saa7134/2.6.26 regression, noisy output)
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: Benoit Istin <beistin@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Steven Toth <stoth@linuxtv.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <4A10FB2A.8040601@gmail.com>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
	 <1241389925.4912.32.camel@pc07.localdom.local>
	 <20090504091049.D931B2C4147@tippex.mynet.homeunix.org>
	 <1241438755.3759.100.camel@pc07.localdom.local>
	 <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
	 <1241565988.16938.15.camel@pc07.localdom.local>
	 <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
	 <20090510141614.D4A9C2C416C@tippex.mynet.homeunix.org>
	 <20090515091827.864A12C4167@tippex.mynet.homeunix.org>
	 <1242438418.3813.15.camel@pc07.localdom.local>  <4A10168E.70205@gmail.com>
	 <1242600174.3750.29.camel@pc07.localdom.local> <4A10FB2A.8040601@gmail.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 01:04:49 +0200
Message-Id: <1242687889.5941.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[snip]
> >
> > From: Benoit Istin <beistin@gmail.com>
> >
> > There are several months my hvr1110 stop working.
> > This is very simple to fix, for my card revision at least, by setting a
> > missing field to the hauppauge_hvr_1110_config.
> >   
> Hello
> 
> I see,
> what i don't remember is, when searching for good parameters for this 
> card (1110), AGC and Co was not necessary...
> 
> correct me if i'm wrong :
> 
> patch from Anders impacts cards with .tuner_config=1
> what i can do :
> 
> step 1 :
> see if we really need .tuner_config = 1  on  hvr_1110_config otherwise 
> change to .tuner_config = 0
> 
> step 2 :
> if needed, apply the patch from Anders and look if it's  better or not 
> both on analogic and dvb
> 
> step 3 : report this results
> 
> 
> others ideas ?

Seems I can't find any details about Benoit's eventually different card
version in the mail archives. 

If it turns out we have revisions with LNA and without, we might try to
provide a separate entry for the LNA version. Usually on Hauppauge cards
we find means doing so.

> PS : i need times because my multimedia box is on production and i 
> prefer test this on another pc, you know : why change when all is good ?

Thanks for your time and no need for hurry.

If you keep your old media modules folder, you just can put it back in
place later again and "depmod -a" and you are done. Do "make rmmod" and
delete the new media modules folder previously and you should be 100%
back.

Cheers,
Hermann




