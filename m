Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:50008 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0LTBEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 20:04:54 -0500
Date: Sun, 19 Dec 2010 19:40:58 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@md.metrocast.net>
cc: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Power frequency detection.
In-Reply-To: <1292804502.3710.22.camel@morgan.silverblock.net>
Message-ID: <alpine.LNX.2.00.1012191930020.24263@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>  <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>  <1292796033.2052.111.camel@morgan.silverblock.net>  <alpine.LNX.2.00.1012191759030.24101@banach.math.auburn.edu>
 <1292804502.3710.22.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On Sun, 19 Dec 2010, Andy Walls wrote:

> On Sun, 2010-12-19 at 18:13 -0600, Theodore Kilgore wrote:
> > 
> > On Sun, 19 Dec 2010, Andy Walls wrote:
> 
> > > The Software for our Sakar branded Jeilin camera was a little smarter.
> > 
> > Oh. So _you_ had a Sakar branded camera. This was one of the things that 
> > causes problems recently. In gspca.txt we have the supported camera listed 
> > as 
> > 
> > jeilinj         0979:0280       Sakar 57379
> > 
> > which seemed to me to be quite wrong, as (unless I have made a bad 
> > mistake) the Sakar 57379 has a Jeilin 2005C or D chip inside (proprietary 
> > interface camera, Product number 0x227, definitely not one of these guys) 
> > and AFAICT the Jeilin 2005C-D cameras can not be made to stream at all, 
> > operating only in stillcam mode. So, when I was contacted about this new 
> > camera I saw that listing and thought it had to be wrong!

OK, I looked again more closely in libgphoto2/camlibs/jl2005c/library.c, 
in which one sees 

Sakar no. 75379

If you are my age you _do_ need to look twice. Then three times. Then have 
a friend point out that you did not see something right. In case you are 
missing it, too

57379 != 75379

So, thanks.

At least that is one thing I do not need to fix.

> > 
> > Hoping that you still have some way to check what the Sakar product number 
> > of your cam really was...
> 
> The Internet never forgets:
> 
> http://www.spinics.net/lists/linux-media/msg07025.html
> 
> http://www.spinics.net/lists/linux-media/msg07127.html

Yes, I guess that clears it all up. I _do_ still have those messages 
somewhere, but it is every so much easier to do it this way.

> 
> It looks like I hypothesized my camera had a JL2008 chips given the AVI
> files it created had "JL2008V2C" in it.

This appears to be a very reasonable hypothesis. I never thought the 
camera has a JL2005C chip in it. I just thought I had erroneously listed a 
camera in gspca.txt which was in fact some other kind of camera. But, as I 
said, 57379 != 75379 and they are not the same camera, either.

Thanks again.

Theodore Kilgore
