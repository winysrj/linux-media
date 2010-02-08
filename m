Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab0BHQPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 11:15:51 -0500
Date: Mon, 8 Feb 2010 08:14:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chicken Shack <chicken.shack@gmx.de>
cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	rms@gnu.org, hermann-pitton@arcor.de
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter (Was: Videotext application crashes the kernel due to DVB-demux
 patch)
In-Reply-To: <1265636585.5399.47.camel@brian.bconsult.de>
Message-ID: <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
References: <1265546998.9356.4.camel@localhost>  <4B6F72E5.3040905@redhat.com>  <4B700287.5080900@linuxtv.org> <1265636585.5399.47.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Feb 2010, Chicken Shack wrote:
> 
> This is a SCANDAL, not fun! This is SCANDALOUS!

I agree that this whole thread has been totally inappropriate from 
beginning to end. 

On all sides, btw. I would suggest that somebody who can't even use his 
own name should be the last to complain about other peoples behavior. I 
have suspicions that the reason you're not using your own name and instead 
go by "Chicken Shack" is that you're one of the DVB people that get 
ignored because everybody knows you always just argue mindlessly, so now 
you use made-up accounts just to not be immediately ignored.

And if that is the case, you should take a hard look at your _own_ 
behavior, and ask yourself why you get ignored on multiple accounts. When 
people ignore your bug reports, maybe it's because they know that the pain 
of interacting with you is simply NOT WORTH IT?

Anyway, the amount of just this kind of pure _crap_ in the whole DVB 
development environment is scary. There are no other areas of Linux kernel 
development where we see this kind of personal and _pointless_ invective.

I realize that I probably see the absolute sewer of the whole discussion, 
since people seem to Cc me only when things are going badly, but _still_. 
I don't see that kind of childish behavior anywhere else in kernel 
development.

Guys, get a f*cking grip already.

Here's the rule:

 - if somebody reports a regression, IT MUST BE FIXED. Not "discussed" for 
   two weeks. Not talked around. If we have a bisected commit that starts 
   oopsing with an existing setup that used to work, there is no 
   discussion. That commit absolutely _has_ to be reverted or fixed. No 
   ifs, buts, or maybes about it.

   Anybody who argues anything else is simply totally wrong. And 
   discussing various semantic changes or asking people to use other 
   programs instead of the one that causes the problem is totally 
   irrelevant until the oops has been fixed.

   An oops is not acceptable in _any_ situation, and saying that the user 
   program is doing something wrong is totally ludicrous. So is breaking a 
   program that used to work.

The fix, btw, for those that haven't seen it, seems to be here:

	http://patchwork.kernel.org/patch/77615/

and people should look at that fix, the explanation, and feel embarrassed 
about th pure crazy invective that has been going on in this thread. It 
was a simple bug, nothing more. It was not worth the intense level of 
craziness seen in this thread.

Btw, there's a very real reason I haven't replied to this thread before: I 
don't like the DVB development process. I've seen the crazyness before, 
and I don't know where it comes from. Some people blame Mauro, but the 
thing is, this whole problem with the DVB development tone used to be 
_worse_. 

It's likely some deep social reason. I have a few suspicions, but they are 
just guesses. For example, I suspect it's partly because DVB gets a much 
less wide development audience - there are clearly some people in the DVB 
driver area that are totally unable to see anything but their own small 
area, and they are too focused on just some detail, and then they get 
upset when others care about other details or about the big picture.

I admit that I used to think that it was because a lot of the people 
involved were Germans, and that the whole mindless bickering was somehow 
cultural. A _lot_ of the worst invective comes from exactly places like 
'gmx.de', which seems to be one of the big mail servers in Germany. But 
there are lots of _good_ developers with that address too, so I suspect my 
"Oh, it's the Germans" explanation was just a funny/sad prejudice.

Why can't DVB people be sane? Please, guys?

And btw, don't in any way think that I think that the problem has just 
been that people have had a hard time just admitting that that commit 
that caused the oops need to be fixed. One of the reasons I think people 
had a hard time fixing the regression was that the original bug report, 
and all the invective was all just totally hiding the real issue.

Instead of making a nice bugzilla and talking about the technical problem, 
the whole beginning of this thread from Chicken Shack has been all about 
shouting at people.

I'm perfectly happy with shouting at people (I'm doing it right now), but 
damn, this thread has just been totally incoherent and stupid. Put some 
real _technical_ reasoning in your crazy rants. 

So damn it, stop cc'ing me on DVB issues. Chicken Shack - I very much 
mean you. I'm not interested in crazy bickering. If you Cc me, include 
proper technical details, and keep it at that level.

And Mauro &co: get me that fix, and stop discussing anything else until 
the actual oops has been fixed.

Everybody: start acting like adults, guys.

			Linus
