Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44329 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab1IXNhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 09:37:33 -0400
Subject: Re: RC6 decoding
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Date: Sat, 24 Sep 2011 09:39:05 -0400
In-Reply-To: <1316870206.2234.7.camel@palomino.walls.org>
References: <1316430722.1656.16.camel@gagarin> <4E7D199F.1000908@redhat.com>
	 <1316870206.2234.7.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1316871545.2234.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-09-24 at 09:16 -0400, Andy Walls wrote:
> On Fri, 2011-09-23 at 20:43 -0300, Mauro Carvalho Chehab wrote:
> > Em 19-09-2011 08:12, Lawrence Rust escreveu:
> > > The current decoder for the RC6 IR protocol supports mode 0 (16 bit) and
> > > mode 6A.  In mode 6A the decoder supports either 32-bit data (for
> > > Microsoft's MCE RC) or 24 bit.
> > > 
> > > I would like to support a Sky/Sky+ standard RC which transmits RC6-6-20
> > > i.e. 20 bit data.  The transmitted frame format is identical to the 24
> > > bit form so I'm curious as to what remotes transmit 24 bit data or was
> > > this an error and it should be 20?
> > > 
> > > RC6-6-20 is explained here:
> > > http://www.guiott.com/wrc/RC6-6.html
> > > 
> > > If 24-bit mode is in use, is there a way to select between 20 and 24 bit
> > > operation?
> > 
> > You'll need to figure out a way to detect between them. It is probably not
> > hard to detect, and add support for both at the decider.
> > Maybe you can find something useful here:
> > 	http://www.sbprojects.com/knowledge/ir/rc6.php
> 
> Lawrence:
> 
> Some RC-6 explanations with more detail could be found here:
>  
> http://slycontrol.ru/scr/kb/rc6.htm (dead; not in the Wayback machine :( )

I found where the above website moved: :)

http://slydiman.narod.ru/scr/kb/rc6.htm

-Andy

> http://www.picbasic.nl/info_rc6_uk.htm
> 
> You might also find this thread of interest for some history:
> http://www.spinics.net/lists/linux-input/msg07983.html
> 
> The take away is that the data length is, in theory, OEM dependent for
> RC-6 Mode 6A, limited to a max of 24 bits (3 bytes) after a short
> customer code and 128 bits (16 bytes) after a long customer code.
> 
> In that previous thread, I suggested it might be better to look for the
> signal free time of 6 RC6_UNITs to declare the end of reception, instead
> of a bit count.  Maybe that is a way to deal with the current problem.
> 
> Regards,
> Andy
> 


