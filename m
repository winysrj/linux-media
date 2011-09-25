Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43523 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376Ab1IYMVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 08:21:06 -0400
Subject: Re: RC6 decoding
From: Andy Walls <awalls@md.metrocast.net>
To: Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Date: Sun, 25 Sep 2011 08:22:36 -0400
In-Reply-To: <1316882573.1681.40.camel@gagarin>
References: <1316430722.1656.16.camel@gagarin> <4E7D199F.1000908@redhat.com>
	 <1316870206.2234.7.camel@palomino.walls.org>
	 <1316871545.2234.8.camel@palomino.walls.org>
	 <1316882573.1681.40.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1316953357.2242.7.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-09-24 at 18:42 +0200, Lawrence Rust wrote:
> On Sat, 2011-09-24 at 09:39 -0400, Andy Walls wrote:
> > On Sat, 2011-09-24 at 09:16 -0400, Andy Walls wrote:
> > > On Fri, 2011-09-23 at 20:43 -0300, Mauro Carvalho Chehab wrote:
> > > > Em 19-09-2011 08:12, Lawrence Rust escreveu:
> > > > > The current decoder for the RC6 IR protocol supports mode 0 (16 bit) and
> > > > > mode 6A.  In mode 6A the decoder supports either 32-bit data (for
> > > > > Microsoft's MCE RC) or 24 bit.
> > > > > 
> > > > > I would like to support a Sky/Sky+ standard RC which transmits RC6-6-20
> > > > > i.e. 20 bit data.  The transmitted frame format is identical to the 24
> > > > > bit form so I'm curious as to what remotes transmit 24 bit data or was
> > > > > this an error and it should be 20?
> > > > > 
> > > > > RC6-6-20 is explained here:
> > > > > http://www.guiott.com/wrc/RC6-6.html
> > > > > 
> > > > > If 24-bit mode is in use, is there a way to select between 20 and 24 bit
> > > > > operation?
> > > > 
> > > > You'll need to figure out a way to detect between them. It is probably not
> > > > hard to detect, and add support for both at the decider.
> > > > Maybe you can find something useful here:
> > > > 	http://www.sbprojects.com/knowledge/ir/rc6.php
> > > 
> > > Lawrence:
> > > 
> > > Some RC-6 explanations with more detail could be found here:
> > >  
> > > http://slycontrol.ru/scr/kb/rc6.htm (dead; not in the Wayback machine :( )
> > 
> > I found where the above website moved: :)
> > 
> > http://slydiman.narod.ru/scr/kb/rc6.htm
> > 
> > -Andy
> > 
> > > http://www.picbasic.nl/info_rc6_uk.htm
> > > 
> > > You might also find this thread of interest for some history:
> > > http://www.spinics.net/lists/linux-input/msg07983.html
> > > 
> > > The take away is that the data length is, in theory, OEM dependent for
> > > RC-6 Mode 6A, limited to a max of 24 bits (3 bytes) after a short
> > > customer code and 128 bits (16 bytes) after a long customer code.
> > > 
> > > In that previous thread, I suggested it might be better to look for the
> > > signal free time of 6 RC6_UNITs to declare the end of reception, instead
> > > of a bit count.  Maybe that is a way to deal with the current problem.
> 
> Andy,
> 
> Many thanks for the pointers - they confirm that the Sky RC is just
> using a shortened but permissible form of 24 bit.  So your suggestion of
> looking for a stop sequence is probably the only/best way.  In fact it
> would actually correct the current implementation which assumes a fixed
> length of 24 or 32 bits.
> 
> If I wrote a patch that handles variable data lengths (up to 24 or 128
> bits) would you be willing to review it?

Yes, I can.  Review will probably need to include a quick skim of all
the current IR hardware drivers and RC infrastructure, to ensure a final
space is propagated to the RC-6 decoder.

Today I'll have time.

My next available date for doing Linux stuff will likely be on 10
October and then 15 October.  (A benefit of a very full schedule is
knowing when I won't have time for things. :P )

Regards,
Andy

> I can test with a Sky RC and I also have a MCEUSB RC on order which
> should hopefully arrive next week.  So that should test the current
> 32-bit case.



