Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:59181 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab0BGD6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Feb 2010 22:58:20 -0500
Subject: Re: "However, if you don't want to lose your freedom, you had
 better not follow him." (Re: Videotext application crashes the kernel due
 to DVB-demux patch)
From: hermann pitton <hermann-pitton@arcor.de>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <1265446554.1733.36.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>
	 <1265397736.6310.98.camel@palomino.walls.org>
	 <4B6C7F1B.7080100@linuxtv.org>  <4B6C88AD.4010708@redhat.com>
	 <1265409155.2692.61.camel@brian.bconsult.de>
	 <1265411523.4064.23.camel@localhost>
	 <1265413149.2063.20.camel@brian.bconsult.de>
	 <1265415910.2558.17.camel@localhost>
	 <1265446554.1733.36.camel@brian.bconsult.de>
Content-Type: text/plain
Date: Sun, 07 Feb 2010 04:58:03 +0100
Message-Id: <1265515083.2666.139.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 06.02.2010, 09:55 +0100 schrieb Chicken Shack:
> Am Samstag, den 06.02.2010, 01:25 +0100 schrieb hermann pitton:
> > Am Samstag, den 06.02.2010, 00:39 +0100 schrieb Chicken Shack:
> > > Am Samstag, den 06.02.2010, 00:12 +0100 schrieb hermann pitton:
> > > > Am Freitag, den 05.02.2010, 23:32 +0100 schrieb Chicken Shack:
> > > > > Am Freitag, den 05.02.2010, 19:07 -0200 schrieb Mauro Carvalho Chehab:
> > > > > > Andreas Oberritter wrote:
> > > > > > > Andy Walls wrote:
> > > > > > 
> > > > > > >>> As Honza noted, these ioctls are used by enigma2 and, in general, by
> > > > > > >>> software running on Dream Multimedia set top boxes.
> > > > > > >> Right, so reverting the patch is not an option.
> > > > > > >>
> > > > > > >> It also makes implementing multiple dvr0.n nodes for a demux0 device
> > > > > > >> node probably a waste of time at this point.
> > > > > > > 
> > > > > > > I think so, too. But I guess it's always worth discussing alternatives.
> > > > > > 
> > > > > > If this discussion happened before 2.6.32 release, and provided that a different
> > > > > > implementation were agreed, things would be easier, as a different solution like
> > > > > > your proposal could be decided and used.
> > > > > 
> > > > > 
> > > > > You cannot expect people reacting immediately if something is wrong.
> > > > > There are and do exist enormous delays between publishing a new kernel
> > > > > and the decision to use it after appropriate system or distro update.
> > > > > So your expectation level is simply wrong.
> > > > > 
> > > > > 
> > > > > > Now, we have already a regression on a stable kernel, and solving it by
> > > > > > creating another regression is not something smart to do.
> > > > > 
> > > > > 
> > > > > Yes. Trivial!
> > > > > 
> > > > > 
> > > > > > >From what I understood, the regression appeared on an old, orphan
> > > > > > application with a non-official patch applied on it. Other applications with
> > > > > > similar features weren't affected. On the other hand, if the patch got reverted, 
> > > > > > we'll break a maintained application that is used on a great number of devices,
> > > > > > and whose features depend on the new ioctls.
> > > > > 
> > > > > 
> > > > > It's truly amazing how the filter system of your perception works, isn't
> > > > > it? :)
> > > > > 
> > > > > It's not just "an old, orphaned application with a non-official patch on
> > > > > it." That's nonsense!
> > > > > 
> > > > > a. As I stated already, there do exist several patched versions of
> > > > > alevt-dvb. For instance the one that Herman Pitton tested here in public
> > > > > causes a closed demux device error on my machine. That means that it
> > > > > does not run because xine-ui is already using the demux device.
> > > > > And this phenomenon has got nothing to do with the kernel headers!
> > > > > I've tried all possibilities (old kernel headers and actual ones) so I
> > > > > know better than Hermann Pitton does!
> > > > > 
> > > > > And my version (and obviously the ones of Thomas Voegtle and Emil Meier
> > > > > whom I helped with my tip to revert that patch) cause a kernel crash
> > > > > with the actual kernel.
> > > > > 
> > > > > b. As I also stated already the other teletext application called mtt
> > > > > does officially not exist except for Novell / OpenSuSe distros (at least
> > > > > as far as I have seen and found out). And this one
> > > > > is, as I also stated, not affected by the kernel patch. It's part of a
> > > > > discontinued program suite called xawtv-4.0 pre with a very complex
> > > > > infrastructure behind.
> > > > > 
> > > > > Please do not ask me why this one runs without noise - I do not know.
> > > > > 
> > > > > So AFAICS alevt-dvb is the ONLY teletext application for Linux which is
> > > > > available in almost all Gnu/Linux distros.
> > > > > 
> > > > > "Other applications with similar features weren't affected."
> > > > > 
> > > > > >From where do you know that the features are "similar"?
> > > > > 
> > > > > This is a 100 % phantasy product of your mind that has got nothing to do
> > > > > with existing reality, man!
> > > > > 
> > > > > Just one example: alevt-dvb has got an excellent html export filter
> > > > > which makes it possible to export teletext pages as graphical html
> > > > > files.
> > > > > I do not know any other teletext application offering that.
> > > > > 
> > > > > 
> > > > > > We are too late in -rc cycle, so probably there's not enough time for
> > > > > > writing, test, validate any new API in time for 2.6.33 and write some compat
> > > > > > layer to emulate those two ioctls with a different implementation.
> > > > > 
> > > > > Who says that a new API or an overworked API must be ready for 2.6.33?
> > > > > When do you think the correct starting point must be set?
> > > > > When the merge window for 2.6.34 opens or when?
> > > > > Absurd argument! Not valid at all!
> > > > > 
> > > > > 
> > > > > > So, removing those two ioctls is not an option anymore.
> > > > > 
> > > > > Yes. Conclusion??? None!
> > > > > 
> > > > > So if everybody wants to close down this discussion with that output
> > > > > then you must admit (if you want it or not) that you de facto bury
> > > > > teletext usage in the mud for the majority of Gnu/Linux DVB users.
> > > > > 
> > > > > So the output is more than badly disappointing.
> > > > > Bye bye Teletext. Nothing for future kernels, huh?
> > > > 
> > > > Yes, you say it. It definitely will go away and we do have not any
> > > > influence on that! Did you not notice the very slow update rate these
> > > > days?
> > > 
> > > a. NOTHING "will go away". This is empty rant, nothing else it is!
> > > In US teletext is dead, yes. In Europe analogue television is close to
> > > dead. Yes.
> > > But I have found no information source that teletext will disappear in
> > > general. At least not in Europe or Germany.
> > > So if you keep that up then prove the assertion please.
> > 
> > In the UK too. And after world war II we always followed BBC.
> > Not that bad ...
> > 
> > http://pressetext.com/news/090720037/nutzung-von-teletext-hat-den-zenit-erreicht
> > 
> > > What slow update rate please?
> > > What the hell are you talking about, man?
> > 
> > Previously information available there was updated within minutes, now
> > in best case every six hours it seems to me.
> > 
> > > > > Regards
> > > > > 
> > > > > CS
> > > > > 
> > > > > P. S.: If you continue like that you make people run away.
> > > > > Instead you better should try to win people, shouldn't you?
> > > > > 
> > > > > Just see how many volunteers are here to help and then reflect
> > > > > why that manpower is missing, Mauro!
> > > > > Your gesture being expressed above does a lot, but it is definitely NOT
> > > > > motivating to change that precarious situation.
> > > > 
> > > > Then maybe better tell what you tried already, instead leaving others
> > > > behind doing the same in vain again?
> > > 
> > > Goddamn! I've investigated a lot, and I have written down everything I
> > > did.
> > > See, even if you are too lazy to read all that go blame yourself for
> > > that lazyness, but not me, OK?
> > 
> > My, I see a difficult to identify something of code around, not in any
> > major distribution. One can link to any headers wanted, and scripts seem
> > to be wrapped around too as liked ...
> > 
> > > > Mauro always did try to keep backward compat as much as possible and
> > > > others had to tell him better not to waste his time on it.
> > > > 
> > > > You hit the wrong guy again and he can't even test anything.
> > > 
> > > 
> > > All I want him is to immediately and forever stop spreading nonsense and
> > > demotivate people and offer us all that propagandist style that I and
> > > others do not appreciate at all.
> > > 
> > > Unfortunately I am missing the American English equivalent for
> > > "Differenziertheit". Is it "straightforwardness"?
> > > 
> > > This is what I am missing when you start to express yourself.
> > > 
> > > Your "test" of alevt-dvb-t may serve as an example:
> > > 
> > > Noone knows your card type, noone knows your reception area,
> > > transponder, channel. All we know from you is a pid.
> > 
> > You did report all that? The pid is from ZDF DVB-T from
> > Frankfurt/Main/Feldberg on a saa7134 Medion Quadro, should not matter at
> > all.
> 
> I was stating 2 things for several times:
> 
> a. I am working with DVB-S equipment (Flexcop Rev. 2.8, sold as
> Technisat Skystar).
> 
> b. It is not impossible to adjust the application (alevt-dvb) to the new
> needs of the current demux device.
> 
> This important aspect was simply bypassed and ignored.
> There is no need to bury its compatibility right into the mud.
> 
> 
> Instead of that everybody talks about possible kernel alternatives, time
> factors, incompatibilities etc. And then everybody concludes that it's
> better not to change anything and buries the discussion.
> And buries the teletext compatibility of future kernels without any
> perspective.
> 
> 
> I scratch my head reading all that!
> How absurd! What the hell is going on in your minds?
> 
> 
> > > And that there are versions of alevt-dvb who are incapable for parallel
> > > tasking due to a wrong DVB patch you simply missed as a matter of fact.
> > > So what the hell did you get at all, man?
> > 
> > They really do exist, or only the sripts around?
> 
> 
> I'll attach an overworked version with all available patches that make
> sense applied. This version is free from cruft and it is capable of
> parallel tasking (i. e. DVB-S playback and recording plus teletext at
> the same time without kernel complaints). The parallel tasking
> capability has got NOTHING to do with any "scripts around".
> It really sucks to put facts against written nonsense of you, Hermann,
> and of MCC of course.
> This is not the level of constructive elaborated discussion at all!
> 
> 
> Some people sampled around here should _urgently_ reflect the ideals
> they stand for when they perform kernel or application hacking here.
> 
> To produce kernel regressions without taking the responsibility for the
> consequences is simply an intolerable behaviour.
> 
> 
> I've always thought that Stallman hopelessly exaggerates when he is
> beating his _marketing drum_ for his ideas - 
> exaggeration as stylistic device.
> 
> But I have changed my mind - I think this guy is right. there is no
> exaggeration at all.
> 
> And here is the link to read the context:
> 
> http://www.webmonkey.com/blog/Richard_Stallman_On_Novell__The_GPL_and_Linus_Torvalds
> 
> The _blind followers_ seem to grow instead of vanishing!
> 
> Cheers
> 
> CS
> 

Hi,

I agree with much above, not all. 

1.
That previous version I tested on DVB-T, and DVB-S should not be
different here, did work on a unpatched recent F11 2.6.30, but _also_
with quite _latest_ v4l-dvb installed on a vanilla 2.6.30 something.

2.
Agreed also, one seems not to be able to escape from the hard oops by
exchanging headers on your latest version with current. Even with latest
v4l-dvb headers, which would/should come with any newer kernel in
question, it still happens. 

As long you set the -t teletext pid, your later revision 1.7.0 works for
all teletext available on the DVB-T transponder tuned in at once with
multiple instances of alevt against also latest headers.

3.
Also confirmed, your 1.7.0 version did work on a latest unpatched F11
2.6.30 without setting the teletext pid explicitly, providing the
information what else is around there, and next should allow switching
through all teletext stuff with the UI I guess.

Taking the oopses now, you are likely right, that we have a backward
compat regression here and should try to fix it.

I'm at least still available for reproducing oopses ;)

And, an app, which ever, should not to be able to get all down.

Cheers,
Hermann






