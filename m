Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:55894 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab0LSXpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 18:45:54 -0500
Date: Sun, 19 Dec 2010 18:21:57 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Andy Walls <awalls@md.metrocast.net>,
	Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Power frequency detection.
In-Reply-To: <201012192332.38060.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1012191814240.24101@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com> <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu> <201012192332.38060.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On Sun, 19 Dec 2010, Adam Baker wrote:

> On Sunday 19 Dec 2010, Theodore Kilgore wrote:
> > Finally, one concern that I have in the back of my mind is the question of 
> > control settings for a camera which streams in bulk mode and requires the 
> > setup of a workqueue. The owner of the camera says that he has 
> > "encountered no problems" with running the two controls mentioned above. 
> > Clearly, that is not a complete answer which overcomes all possible 
> > objections. Rather, things are OK if and only if we can ensure that these 
> > controls can be run only while the workqueue that does the streaming is 
> > inactive. Somehow, I suspect that the fact that a sensible user would only 
> > run such commands at camera setup is an insufficient guarantee that no 
> > problems will ever be encountered.
> > 
> > So, as I said, the question of interaction of a control and a workqueue is 
> > another problem interesting little problem. Your thoughts on this 
> > interesting little problem would be appreciated.
> 
> I don't think you can assume a user won't try to adjust such controls while 
> streaming - 

what I said, actually

if I had one I'd certainly want to try swapping the control while 
> streaming to see if I could see any affect on the output. 

Yeah, I tell people that I like to see if I can hook things together and 
make something go "bang." Or, that I do research about locating that 
elusive magic smoke in the hardware, which makes it run. So maybe I 
would try that too, just for the pure hell of it. But I did say 
something about a "sensible user"? Neither of us, apparently. And come 
down to it, if one cannot trust you, and cannot trust me, as much work as 
we did together, then nobody can be trusted at all. :-}

Even though sq905.c 
> doesn't have any controls on the camera it still ended up needing the locking 
> that would make this safe. See the header comment on sq905_dostream

If the controls are locked while the workqueue is doing the streaming, 
then probably that does fix the problem? Most likely, that is the simplest 
thing to do. 

Theodore Kilgore
