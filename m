Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp24.services.sfr.fr ([93.17.128.82]:44367 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1IXQwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 12:52:22 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2409.sfr.fr (SMTP Server) with ESMTP id 44C027000142
	for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 18:42:57 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (98.93.30.93.rev.sfr.net [93.30.93.98])
	by msfrf2409.sfr.fr (SMTP Server) with SMTP id EA2F27000071
	for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 18:42:56 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.93.98] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 18:42:54 +0200
Subject: Re: RC6 decoding
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <1316871545.2234.8.camel@palomino.walls.org>
References: <1316430722.1656.16.camel@gagarin> <4E7D199F.1000908@redhat.com>
	 <1316870206.2234.7.camel@palomino.walls.org>
	 <1316871545.2234.8.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Sep 2011 18:42:53 +0200
Message-ID: <1316882573.1681.40.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-09-24 at 09:39 -0400, Andy Walls wrote:
> On Sat, 2011-09-24 at 09:16 -0400, Andy Walls wrote:
> > On Fri, 2011-09-23 at 20:43 -0300, Mauro Carvalho Chehab wrote:
> > > Em 19-09-2011 08:12, Lawrence Rust escreveu:
> > > > The current decoder for the RC6 IR protocol supports mode 0 (16 bit) and
> > > > mode 6A.  In mode 6A the decoder supports either 32-bit data (for
> > > > Microsoft's MCE RC) or 24 bit.
> > > > 
> > > > I would like to support a Sky/Sky+ standard RC which transmits RC6-6-20
> > > > i.e. 20 bit data.  The transmitted frame format is identical to the 24
> > > > bit form so I'm curious as to what remotes transmit 24 bit data or was
> > > > this an error and it should be 20?
> > > > 
> > > > RC6-6-20 is explained here:
> > > > http://www.guiott.com/wrc/RC6-6.html
> > > > 
> > > > If 24-bit mode is in use, is there a way to select between 20 and 24 bit
> > > > operation?
> > > 
> > > You'll need to figure out a way to detect between them. It is probably not
> > > hard to detect, and add support for both at the decider.
> > > Maybe you can find something useful here:
> > > 	http://www.sbprojects.com/knowledge/ir/rc6.php
> > 
> > Lawrence:
> > 
> > Some RC-6 explanations with more detail could be found here:
> >  
> > http://slycontrol.ru/scr/kb/rc6.htm (dead; not in the Wayback machine :( )
> 
> I found where the above website moved: :)
> 
> http://slydiman.narod.ru/scr/kb/rc6.htm
> 
> -Andy
> 
> > http://www.picbasic.nl/info_rc6_uk.htm
> > 
> > You might also find this thread of interest for some history:
> > http://www.spinics.net/lists/linux-input/msg07983.html
> > 
> > The take away is that the data length is, in theory, OEM dependent for
> > RC-6 Mode 6A, limited to a max of 24 bits (3 bytes) after a short
> > customer code and 128 bits (16 bytes) after a long customer code.
> > 
> > In that previous thread, I suggested it might be better to look for the
> > signal free time of 6 RC6_UNITs to declare the end of reception, instead
> > of a bit count.  Maybe that is a way to deal with the current problem.

Andy,

Many thanks for the pointers - they confirm that the Sky RC is just
using a shortened but permissible form of 24 bit.  So your suggestion of
looking for a stop sequence is probably the only/best way.  In fact it
would actually correct the current implementation which assumes a fixed
length of 24 or 32 bits.

If I wrote a patch that handles variable data lengths (up to 24 or 128
bits) would you be willing to review it?

I can test with a Sky RC and I also have a MCEUSB RC on order which
should hopefully arrive next week.  So that should test the current
32-bit case.

-- 
Lawrence
