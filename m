Return-path: <mchehab@pedra>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:44184 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab0JHAY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 20:24:58 -0400
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: hermann pitton <hermann-pitton@arcor.de>
To: Giorgio <mywing81@gmail.com>
Cc: Dejan Rodiger <dejan.rodiger@gmail.com>,
	linux-media@vger.kernel.org, Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <AANLkTimujmbJEYua6Ezb6zZzvF-WGnorTBGMc2CtrEz7@mail.gmail.com>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
	 <AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
	 <4CA9FCB0.40502@gmail.com> <1286234505.3167.29.camel@pc07.localdom.local>
	 <AANLkTimujmbJEYua6Ezb6zZzvF-WGnorTBGMc2CtrEz7@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Oct 2010 02:09:51 +0200
Message-Id: <1286496591.3135.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Giorgio,

Am Mittwoch, den 06.10.2010, 13:50 +0200 schrieb Giorgio:

[big snip]

> > Likely, I only have to read the LKML daily ...
> >
> > Despite of that, we need a good analysis of course, and a way how to
> > avoid such.
> 
> Maybe we can have some kind of test team? It would help to find
> regressions before it's too late.
> 
> > Cheers,
> > Hermann
> 
> Giorgio Vazzana

Yes, we always need test teams.

And Mauro explicitly did call for testing.

I did, Dmitry did and Mauro.

But we did not find the potential bug, caused by moving some identical
code between saa7134-ts and saa7134-core forth and back.

This was still on hg and I only have _some_ of such cards.

Having this on latest Linus git stuff,

likely only compile fixes on previous -next, can find such ...

;)

I'm sorry for repeating my dumbness on that.

Cheers,
Hermann


