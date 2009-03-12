Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53030 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZCLXtd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 19:49:33 -0400
Subject: Re: Fwd: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
 video_open
From: Andy Walls <awalls@radix.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <49B99828.3090002@linuxtv.org>
References: <200902241700.56099.jarod@redhat.com>
	 <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
	 <1236899033.3261.7.camel@palomino.walls.org> <49B99828.3090002@linuxtv.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 19:49:47 -0400
Message-Id: <1236901787.3715.23.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-12 at 19:18 -0400, Michael Krufky wrote:
> Andy Walls wrote:
> > On Thu, 2009-03-12 at 16:24 -0400, Michael Krufky wrote:
> >   
> >> Can we have this merged into -stable?  Jarod Wilson sent this last
> >> month, but he left off the cc to stable@kernel.org
> >>
> >> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> >>     
> >
> > Mike,
> >
> > A version of this is already in the v4l-dvb hg development repository:
> >
> > hg log -vp --limit 1 linux/drivers/media/video/cx23885/cx23885-417.c
> > hg log -vp --limit 2 linux/drivers/media/video/cx23885/cx23885-video.c 
> >
> > I helped Mark work through the solution: I coded some of it, he coded
> > some of it and he also tested it.
> >
> > Regards,
> > Andy
> 
> I'm aware of that, Andy -- That's why I am sending this off to the 
> -stable team for 2.6.27.y

Ooops. Sorry for my cluelessness. :)

Regards,
Andy


> Thanks & regards,
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

