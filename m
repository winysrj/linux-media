Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751651Ab0BHS2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 13:28:17 -0500
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter (Was: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	rms@gnu.org, hermann-pitton@arcor.de
In-Reply-To: <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
References: <1265546998.9356.4.camel@localhost>
	 <4B6F72E5.3040905@redhat.com>  <4B700287.5080900@linuxtv.org>
	 <1265636585.5399.47.camel@brian.bconsult.de>
	 <alpine.LFD.2.00.1002080746180.3829@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 19:25:08 +0100
Message-ID: <1265653508.12259.89.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 08.02.2010, 08:14 -0800 schrieb Linus Torvalds:
> 
> On Mon, 8 Feb 2010, Chicken Shack wrote:
> > 
> > This is a SCANDAL, not fun! This is SCANDALOUS!
> 
> I agree that this whole thread has been totally inappropriate from 
> beginning to end. 

Yes, as a matter of frustration and the way some people around here deal
with kernel regressions (shrug shoulders, endless discussions etc.).

> On all sides, btw. I would suggest that somebody who can't even use his 
> own name should be the last to complain about other peoples behavior.

Interesting point of view. Would be valid to critically analyze the
gesture behind. "Arrogance" would be the most harmless word behind it.
Sharper evaluations I better avoid here!

>  I 
> have suspicions that the reason you're not using your own name and instead 
> go by "Chicken Shack" is that you're one of the DVB people that get 
> ignored because everybody knows you always just argue mindlessly, so now 
> you use made-up accounts just to not be immediately ignored.

Richard Stallman told me:

"Banning you as a punishment seems foolishly harsh, too."

It's you, Linus Torvalds who makes those foolishly harsh punishments
possible. They are very equivalent to a fallback in the middle ages when
a term called "bourgeois rights" wasn't even utopic.

> And if that is the case, you should take a hard look at your _own_ 
> behavior, and ask yourself why you get ignored on multiple accounts. When 
> people ignore your bug reports, maybe it's because they know that the pain 
> of interacting with you is simply NOT WORTH IT?

Well thanks for the flowers, from somebody who goes like "I see that
there is an issue, but I do not comprehend or know the what and why."

Very helpful, very intelligent, isn't it? And how constructive!?

> Anyway, the amount of just this kind of pure _crap_ in the whole DVB 
> development environment is scary. There are no other areas of Linux kernel 
> development where we see this kind of personal and _pointless_ invective.

It was not not pointless at all. It was a kernel regression, and I found
the kernel patch responsive for that.
The way this regression is dealt with here is the only thing that is
"pointless".

> I realize that I probably see the absolute sewer of the whole discussion, 
> since people seem to Cc me only when things are going badly, but _still_. 
> I don't see that kind of childish behavior anywhere else in kernel 
> development.
> 
> Guys, get a f*cking grip already.
> 
> Here's the rule:
> 
>  - if somebody reports a regression, IT MUST BE FIXED. Not "discussed" for 
>    two weeks. Not talked around. If we have a bisected commit that starts 
>    oopsing with an existing setup that used to work, there is no 
>    discussion. That commit absolutely _has_ to be reverted or fixed. No 
>    ifs, buts, or maybes about it.

Go tell that to guys like Devin Heitmueller. Not me!

I really do not know for what kind of ideas or ideals people like him do
struggle for when they start hacking here.
But the "standard" answers you get when you come up with that first rule
above, are:
1. Sorry, I am doing this only in my spare time, without getting paid.
2. Variation of 1.: Sorry, I am short in time.
3. You cannot expect anything unless you pay with a cheque.

I am really wondering for what goddamn reason they keep on repeating
this continuously.
But when it's personally THEM to cause regressions, to fuck up the code,
to break peripheral compatibilities, THEN, YES, THEN you do not hear any
excuses for being short in time, or for being paid.

I call that behaviour asocial, irresponsible, inacceptable.
How would you call it, Linus Torvalds?

Read Heitmueller's contribution and you know what this kiddy thinks and
does not think.

>    Anybody who argues anything else is simply totally wrong. And 
>    discussing various semantic changes or asking people to use other 
>    programs instead of the one that causes the problem is totally 
>    irrelevant until the oops has been fixed.

Here we are! Fully accepted!

>    An oops is not acceptable in _any_ situation, and saying that the user 
>    program is doing something wrong is totally ludicrous. So is breaking a 
>    program that used to work.
> 
> The fix, btw, for those that haven't seen it, seems to be here:
> 
> 	http://patchwork.kernel.org/patch/77615/
> 
> and people should look at that fix, the explanation, and feel embarrassed 
> about th pure crazy invective that has been going on in this thread. It 
> was a simple bug, nothing more. It was not worth the intense level of 
> craziness seen in this thread.

Yes, that is really a shame.

> Btw, there's a very real reason I haven't replied to this thread before: I 
> don't like the DVB development process. I've seen the crazyness before, 
> and I don't know where it comes from.

I am breathless. I simply cannot believe it!
Ok! You like strict guidelines?

Here they are:

1. There is one guy for instance who, from time to time, really manages
to develop something valid: for instance a "Mantis" driver.
But behind the guidelines this man is doing nothing but pure agitation
of the worst kind: throwing stones and preparing flame wars. Insane!

2. Mauro maybe well in V4l terms, his coding experience I would call
mediocre, but as a maintainer of it all hemixes his hands in affairs
that he has no idea about. And that's DVB.

There should be a second maintainer for DVB only like it was
traditionally when this whole stuff was nearly completely in German
hands (I am talking about the convergence aera).

Mauro as the only one for all - that is highly insane.
It simply does not work!

>  Some people blame Mauro, but the 
> thing is, this whole problem with the DVB development tone used to be 
> _worse_. 

When was it _worse_? What do you mean?

> It's likely some deep social reason. I have a few suspicions, but they are 
> just guesses. For example, I suspect it's partly because DVB gets a much 
> less wide development audience - there are clearly some people in the DVB 
> driver area that are totally unable to see anything but their own small 
> area, and they are too focused on just some detail, and then they get 
> upset when others care about other details or about the big picture.

Sounds warm, but isn't hot at all. One possible reason, not more.

> I admit that I used to think that it was because a lot of the people 
> involved were Germans, and that the whole mindless bickering was somehow 
> cultural. A _lot_ of the worst invective comes from exactly places like 
> 'gmx.de', which seems to be one of the big mail servers in Germany. But 
> there are lots of _good_ developers with that address too, so I suspect my 
> "Oh, it's the Germans" explanation was just a funny/sad prejudice.

Yes it is. Guess it's _your_ personal mind a point of view which is
short-minded here. And if especially you regard "Mister Mantis" from
India you should be clear that "mindless bickering" is not something
specifically German out of _cultural_ terms.

I do not say either that a _social competence below zero_ is something
typical appearing very often within Swedish minorities who are growing
up in some very provincial angle of Finland, or do I say that, little
boy?


> Why can't DVB people be sane? Please, guys?
> 
> And btw, don't in any way think that I think that the problem has just 
> been that people have had a hard time just admitting that that commit 
> that caused the oops need to be fixed. One of the reasons I think people 
> had a hard time fixing the regression was that the original bug report, 
> and all the invective was all just totally hiding the real issue.

Pure nonsense.
I was reporting the symptoms of the crash - but noone listened.
I was again reporting the crash plus the patch that caused it - this
time a little louder, because noone listened at the first time. And then
it was Andy Walls asking me to send in a complete syslog.
So Andy Walls was nearly the only one here reacting as expected.
Picking up the issue, at least trying to perceive the technical problem.

There were, among my personal entries, two user requests:

Emil Meyer and Thomas Voegtle.
Emil Meyer's was completely ignored.

> Instead of making a nice bugzilla and talking about the technical problem, 
> the whole beginning of this thread from Chicken Shack has been all about 
> shouting at people.

That has perhaps to do with my kind of approach:
I directly mailed Andreas Oberritter, the author of the patch causing
the regression in 2.6.32.
His response was one of these typical asocial and insane behaviour types
of disgusting and polluted persons:
_Promises are made not to be kept_
He went. I am short in time. If I do not get a notice from me during the
next 2 weeks please mail me again.

5 mails followed - unanswered. Too lazy and not willing to take the
responsibility - that's the insane state of mind behind.

Hope you comprehend now how foolish and nasty your "scapegoat theory_
is, Mister Torvalds!!!

> I'm perfectly happy with shouting at people (I'm doing it right now), but 
> damn, this thread has just been totally incoherent and stupid. Put some 
> real _technical_ reasoning in your crazy rants. 

What a holy wish. Personal consequences would be more efficient, as you
CANNOT Reduce every issue on a technical one!

When will you get that, Mister Torvalds?

> So damn it, stop cc'ing me on DVB issues. Chicken Shack - I very much 
> mean you. I'm not interested in crazy bickering. If you Cc me, include 
> proper technical details, and keep it at that level.

Is that all??

> And Mauro &co: get me that fix, and stop discussing anything else until 
> the actual oops has been fixed.
> 
> Everybody: start acting like adults, guys.
> 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

CS

P. S.: One last hint for Mister Linus Torvalds, the man with the social
competence below zero:

There are people sampled around here who really think that hacking free
software (drivers, applications, anything else) is adequate to freely
producing crap, rubbish, doing everything they ever want to without
taking responsibility if it breaks or damages hardware or software.
The pure dumbness and thickness, the imbearable primitivity and
superficiality in their brains CANNOT BE evaluated via expressions like
_kiddish_ or _childish_ or similar.

The dumbness and thickness, the destructivity, the primitivity and the
superficiality of them mixes up the term "freedom" with a french term
called "Laissez-Faire" which means something like "Do what you want,
without responsiblities, without limits, without laws, without rules."

"And if it does harm - shrug your shoulders!"

Just to make that one quite clear, Linus Torvalds:
This gesture has got NOTHING to do with _acting kiddish_.
And people with that gesture I do hate like I hate the pest and cholera.

No matter if those fuckers claim to have produced 1000 or 0 drivers, no
matter if those motherfuckers claim to have produced 1000 or 0
regressions:
People with that gesture and attitude should immediately fuck off from
here without return ticket. No project needs them! PERIOD!


