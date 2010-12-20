Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:9021 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab0LTAVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 19:21:07 -0500
Subject: Re: Power frequency detection.
From: Andy Walls <awalls@md.metrocast.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1012191759030.24101@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
	 <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
	 <1292796033.2052.111.camel@morgan.silverblock.net>
	 <alpine.LNX.2.00.1012191759030.24101@banach.math.auburn.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 19:21:42 -0500
Message-ID: <1292804502.3710.22.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-12-19 at 18:13 -0600, Theodore Kilgore wrote:
> 
> On Sun, 19 Dec 2010, Andy Walls wrote:

> > The Software for our Sakar branded Jeilin camera was a little smarter.
> 
> Oh. So _you_ had a Sakar branded camera. This was one of the things that 
> causes problems recently. In gspca.txt we have the supported camera listed 
> as 
> 
> jeilinj         0979:0280       Sakar 57379
> 
> which seemed to me to be quite wrong, as (unless I have made a bad 
> mistake) the Sakar 57379 has a Jeilin 2005C or D chip inside (proprietary 
> interface camera, Product number 0x227, definitely not one of these guys) 
> and AFAICT the Jeilin 2005C-D cameras can not be made to stream at all, 
> operating only in stillcam mode. So, when I was contacted about this new 
> camera I saw that listing and thought it had to be wrong!
> 
> Hoping that you still have some way to check what the Sakar product number 
> of your cam really was...

The Internet never forgets:

http://www.spinics.net/lists/linux-media/msg07025.html

http://www.spinics.net/lists/linux-media/msg07127.html

It looks like I hypothesized my camera had a JL2008 chips given the AVI
files it created had "JL2008V2C" in it.

I hope that email thread archive has the information you need.

Also there is this thread where Jean-Francois talked about the contents
of gspca.txt:

http://www.spinics.net/lists/linux-media/msg08477.html


Regards,
Andy

