Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49977 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754235Ab0BGMOV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 07:14:21 -0500
Subject: Re: "However, if you don't want to lose your freedom, you had
 better not follow him." (Re: Videotext application crashes the kernel due
 to DVB-demux patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <1265515083.2666.139.camel@localhost>
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
	 <1265515083.2666.139.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Feb 2010 13:11:20 +0100
Message-ID: <1265544680.1733.120.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, den 07.02.2010, 04:58 +0100 schrieb hermann pitton:
> Am Samstag, den 06.02.2010, 09:55 +0100 schrieb Chicken Shack:
> > Am Samstag, den 06.02.2010, 01:25 +0100 schrieb hermann pitton:
> > > Am Samstag, den 06.02.2010, 00:39 +0100 schrieb Chicken Shack:
> > > > Am Samstag, den 06.02.2010, 00:12 +0100 schrieb hermann pitton:
> > > > > Am Freitag, den 05.02.2010, 23:32 +0100 schrieb Chicken Shack:
> > > > > > Am Freitag, den 05.02.2010, 19:07 -0200 schrieb Mauro Carvalho Chehab:
> > > > > > > Andreas Oberritter wrote:
> > > > > > > > Andy Walls wrote:
> > > > > > > 
> > > > > > > >>> As Honza noted, these ioctls are used by enigma2 and, in general, by
> > > > > > > >>> software running on Dream Multimedia set top boxes.
> > > > > > > >> Right, so reverting the patch is not an option.
> > > > > > > >>
> > > > > > > >> It also makes implementing multiple dvr0.n nodes for a demux0 device
> > > > > > > >> node probably a waste of time at this point.
> > > > > > > > 
> > > > > > > > I think so, too. But I guess it's always worth discussing alternatives.
> > > > > > > 
> > > > > > > If this discussion happened before 2.6.32 release, and provided that a different
> > > > > > > implementation were agreed, things would be easier, as a different solution like
> > > > > > > your proposal could be decided and used.
> > > > > > 
> > > > > > 
> > > > > > You cannot expect people reacting immediately if something is wrong.
> > > > > > There are and do exist enormous delays between publishing a new kernel
> > > > > > and the decision to use it after appropriate system or distro update.
> > > > > > So your expectation level is simply wrong.
> > > > > > 
> > > > > > 
> > > > > > > Now, we have already a regression on a stable kernel, and solving it by
> > > > > > > creating another regression is not something smart to do.
> > > > > > 
> > > > > > 
> > > > > > Yes. Trivial!
> > > > > > 
> > > > > > 
> > > > > > > >From what I understood, the regression appeared on an old, orphan
> > > > > > > application with a non-official patch applied on it. Other applications with
> > > > > > > similar features weren't affected. On the other hand, if the patch got reverted, 
> > > > > > > we'll break a maintained application that is used on a great number of devices,
> > > > > > > and whose features depend on the new ioctls.
> > > > > > 
> > > > > > 
> > > > > > It's truly amazing how the filter system of your perception works, isn't
> > > > > > it? :)
> > > > > > 
> > > > > > It's not just "an old, orphaned application with a non-official patch on
> > > > > > it." That's nonsense!
> > > > > > 
> > > > > > a. As I stated already, there do exist several patched versions of
> > > > > > alevt-dvb. For instance the one that Herman Pitton tested here in public
> > > > > > causes a closed demux device error on my machine. That means that it
> > > > > > does not run because xine-ui is already using the demux device.
> > > > > > And this phenomenon has got nothing to do with the kernel headers!
> > > > > > I've tried all possibilities (old kernel headers and actual ones) so I
> > > > > > know better than Hermann Pitton does!
> > > > > > 
> > > > > > And my version (and obviously the ones of Thomas Voegtle and Emil Meier
> > > > > > whom I helped with my tip to revert that patch) cause a kernel crash
> > > > > > with the actual kernel.
> > > > > > 
> > > > > > b. As I also stated already the other teletext application called mtt
> > > > > > does officially not exist except for Novell / OpenSuSe distros (at least
> > > > > > as far as I have seen and found out). And this one
> > > > > > is, as I also stated, not affected by the kernel patch. It's part of a
> > > > > > discontinued program suite called xawtv-4.0 pre with a very complex
> > > > > > infrastructure behind.
> > > > > > 
> > > > > > Please do not ask me why this one runs without noise - I do not know.
> > > > > > 
> > > > > > So AFAICS alevt-dvb is the ONLY teletext application for Linux which is
> > > > > > available in almost all Gnu/Linux distros.
> > > > > > 
> > > > > > "Other applications with similar features weren't affected."
> > > > > > 
> > > > > > >From where do you know that the features are "similar"?
> > > > > > 
> > > > > > This is a 100 % phantasy product of your mind that has got nothing to do
> > > > > > with existing reality, man!
> > > > > > 
> > > > > > Just one example: alevt-dvb has got an excellent html export filter
> > > > > > which makes it possible to export teletext pages as graphical html
> > > > > > files.
> > > > > > I do not know any other teletext application offering that.
> > > > > > 
> > > > > > 
> > > > > > > We are too late in -rc cycle, so probably there's not enough time for
> > > > > > > writing, test, validate any new API in time for 2.6.33 and write some compat
> > > > > > > layer to emulate those two ioctls with a different implementation.
> > > > > > 
> > > > > > Who says that a new API or an overworked API must be ready for 2.6.33?
> > > > > > When do you think the correct starting point must be set?
> > > > > > When the merge window for 2.6.34 opens or when?
> > > > > > Absurd argument! Not valid at all!
> > > > > > 
> > > > > > 
> > > > > > > So, removing those two ioctls is not an option anymore.
> > > > > > 
> > > > > > Yes. Conclusion??? None!
> > > > > > 
> > > > > > So if everybody wants to close down this discussion with that output
> > > > > > then you must admit (if you want it or not) that you de facto bury
> > > > > > teletext usage in the mud for the majority of Gnu/Linux DVB users.
> > > > > > 
> > > > > > So the output is more than badly disappointing.
> > > > > > Bye bye Teletext. Nothing for future kernels, huh?
> > > > > 
> > > > > Yes, you say it. It definitely will go away and we do have not any
> > > > > influence on that! Did you not notice the very slow update rate these
> > > > > days?
> > > > 
> > > > a. NOTHING "will go away". This is empty rant, nothing else it is!
> > > > In US teletext is dead, yes. In Europe analogue television is close to
> > > > dead. Yes.
> > > > But I have found no information source that teletext will disappear in
> > > > general. At least not in Europe or Germany.
> > > > So if you keep that up then prove the assertion please.
> > > 
> > > In the UK too. And after world war II we always followed BBC.
> > > Not that bad ...
> > > 
> > > http://pressetext.com/news/090720037/nutzung-von-teletext-hat-den-zenit-erreicht
> > > 
> > > > What slow update rate please?
> > > > What the hell are you talking about, man?
> > > 
> > > Previously information available there was updated within minutes, now
> > > in best case every six hours it seems to me.
> > > 
> > > > > > Regards
> > > > > > 
> > > > > > CS
> > > > > > 
> > > > > > P. S.: If you continue like that you make people run away.
> > > > > > Instead you better should try to win people, shouldn't you?
> > > > > > 
> > > > > > Just see how many volunteers are here to help and then reflect
> > > > > > why that manpower is missing, Mauro!
> > > > > > Your gesture being expressed above does a lot, but it is definitely NOT
> > > > > > motivating to change that precarious situation.
> > > > > 
> > > > > Then maybe better tell what you tried already, instead leaving others
> > > > > behind doing the same in vain again?
> > > > 
> > > > Goddamn! I've investigated a lot, and I have written down everything I
> > > > did.
> > > > See, even if you are too lazy to read all that go blame yourself for
> > > > that lazyness, but not me, OK?
> > > 
> > > My, I see a difficult to identify something of code around, not in any
> > > major distribution. One can link to any headers wanted, and scripts seem
> > > to be wrapped around too as liked ...
> > > 
> > > > > Mauro always did try to keep backward compat as much as possible and
> > > > > others had to tell him better not to waste his time on it.
> > > > > 
> > > > > You hit the wrong guy again and he can't even test anything.
> > > > 
> > > > 
> > > > All I want him is to immediately and forever stop spreading nonsense and
> > > > demotivate people and offer us all that propagandist style that I and
> > > > others do not appreciate at all.
> > > > 
> > > > Unfortunately I am missing the American English equivalent for
> > > > "Differenziertheit". Is it "straightforwardness"?
> > > > 
> > > > This is what I am missing when you start to express yourself.
> > > > 
> > > > Your "test" of alevt-dvb-t may serve as an example:
> > > > 
> > > > Noone knows your card type, noone knows your reception area,
> > > > transponder, channel. All we know from you is a pid.
> > > 
> > > You did report all that? The pid is from ZDF DVB-T from
> > > Frankfurt/Main/Feldberg on a saa7134 Medion Quadro, should not matter at
> > > all.
> > 
> > I was stating 2 things for several times:
> > 
> > a. I am working with DVB-S equipment (Flexcop Rev. 2.8, sold as
> > Technisat Skystar).
> > 
> > b. It is not impossible to adjust the application (alevt-dvb) to the new
> > needs of the current demux device.
> > 
> > This important aspect was simply bypassed and ignored.
> > There is no need to bury its compatibility right into the mud.
> > 
> > 
> > Instead of that everybody talks about possible kernel alternatives, time
> > factors, incompatibilities etc. And then everybody concludes that it's
> > better not to change anything and buries the discussion.
> > And buries the teletext compatibility of future kernels without any
> > perspective.
> > 
> > 
> > I scratch my head reading all that!
> > How absurd! What the hell is going on in your minds?
> > 
> > 
> > > > And that there are versions of alevt-dvb who are incapable for parallel
> > > > tasking due to a wrong DVB patch you simply missed as a matter of fact.
> > > > So what the hell did you get at all, man?
> > > 
> > > They really do exist, or only the sripts around?
> > 
> > 
> > I'll attach an overworked version with all available patches that make
> > sense applied. This version is free from cruft and it is capable of
> > parallel tasking (i. e. DVB-S playback and recording plus teletext at
> > the same time without kernel complaints). The parallel tasking
> > capability has got NOTHING to do with any "scripts around".
> > It really sucks to put facts against written nonsense of you, Hermann,
> > and of MCC of course.
> > This is not the level of constructive elaborated discussion at all!
> > 
> > 
> > Some people sampled around here should _urgently_ reflect the ideals
> > they stand for when they perform kernel or application hacking here.
> > 
> > To produce kernel regressions without taking the responsibility for the
> > consequences is simply an intolerable behaviour.
> > 
> > 
> > I've always thought that Stallman hopelessly exaggerates when he is
> > beating his _marketing drum_ for his ideas - 
> > exaggeration as stylistic device.
> > 
> > But I have changed my mind - I think this guy is right. there is no
> > exaggeration at all.
> > 
> > And here is the link to read the context:
> > 
> > http://www.webmonkey.com/blog/Richard_Stallman_On_Novell__The_GPL_and_Linus_Torvalds
> > 
> > The _blind followers_ seem to grow instead of vanishing!
> > 
> > Cheers
> > 
> > CS
> > 
> 
> Hi,
> 
> I agree with much above, not all. 
> 
> 1.
> That previous version I tested on DVB-T, and DVB-S should not be
> different here, did work on a unpatched recent F11 2.6.30, but _also_
> with quite _latest_ v4l-dvb installed on a vanilla 2.6.30 something.
> 
> 2.
> Agreed also, one seems not to be able to escape from the hard oops by
> exchanging headers on your latest version with current. Even with latest
> v4l-dvb headers, which would/should come with any newer kernel in
> question, it still happens. 
> 
> As long you set the -t teletext pid, your later revision 1.7.0 works for
> all teletext available on the DVB-T transponder tuned in at once with
> multiple instances of alevt against also latest headers.
> 
> 3.
> Also confirmed, your 1.7.0 version did work on a latest unpatched F11
> 2.6.30 without setting the teletext pid explicitly, providing the
> information what else is around there, and next should allow switching
> through all teletext stuff with the UI I guess.
> 
> Taking the oopses now, you are likely right, that we have a backward
> compat regression here and should try to fix it.
> 
> I'm at least still available for reproducing oopses ;)
> 
> And, an app, which ever, should not to be able to get all down.
> 
> Cheers,
> Hermann

Hello all,

let me give you all some last rendering more precisely statements to
sharpen your minds:

1. alevt-dvb and kernel version: To get out all application features of
my last version 1.7.0 without crash there is no need to go back to
2.6.30 final:
Although being a buggy stinker and thus not part of all distros 2.6.31
final is the last official kernel with which everything is fine.

2. Although setting the -t teletext pid is the way to go without kernel
crash, you need to know the couples of teletext pids of the channels
being sampled in one transponder if you want to run multiple instances
of the same program in parallel mode.

As this is normally NOT the case, helper scripts exist who carry the
information of the outfile function (switch -o) into a graphical window
where you can start multiple windows by mouseclick.

This outfile option (-o) does NOT work as long as you are forced to give
the program the long device string (i. e. -vbi /dev/dvb/adapter0/demux0)
plus a teletext pid (f. ex. -t 230 for 3sat).
Don't ask me why this does not work - I do not know!

So in practice, running the application under a current kernel, you are
reduced to the following:

a. mandatory starting the application with the long string plus ttpid:
-vbi /dev/dvb/adapter0/demux0 -pid 230
b. no chance to start it without parameter, or by sid or by channel name
c. one teletext window per one running channel, as the program itself
does not provide you a graphical menu to allow you switching several
channels within the currently switched transponder.

This reduction WAS NOT intended.
And a kernel which can be smashed down to a point (in extreme cases,
nota bene) where nothing goes without the _violent_ hard reset button,
is not a kernel. It is a security risk instead.

3. The "discussion" that happened here shows very precisely in how far
this public list conforms to a little village carrying the unofficial
name "Absurdistan".
Yeah, it's really weird and crazy, if not to say completely insane.

It all starts up with a chief maintainer talking and writing a kind of
English which is almost unreadable and highly disgusting sometimes.
Although this chief maintainer has been doing his job for years now,
he still doesn't know what his tasks are.
Instead of trying to win qualified people and / or testers and users he
very often acts as if there would be thousands of volunteers around
stamping down each other in order to receive a chance for doing unpaid
qualified work here.
His utterances very often remind me of "Apparatschniks", who are a
certain kind of people that you very often find in petty bourgeois
politics.

For primitive structured people howling with the wolves counts more than
essence and sophistication of the contribution.


The fact that alevt-dvb crashes the current kernel is definitely a
backward compatibility issue. On the one hand.
On the other hand it is not.

It is a matter on how you define the issue. I stated that several times
- in vain!
To reduce the issue to 50 % of its real essence due to missing
application hacking skills is an insane behaviour.
It's like a row of doctors each giving perfect sounding diagnosis but
noone touching the issue and starting the therapy instead.
The white dressed people endlessly rant while the patient dies...


Here is the path to resolve the alevt-dvb issue without changing the
kernel at all:

As I stated already there is a teletext application written by Gerd
Knorr in about 2004. That was Gerd's SuSE-Novell-Phase, when he was MCCs
precedent here, v4l maintainer.

This product called mtt is worth to be examined a bit.

When you start it with -d 10 (debug) it first automatically probes all
available dvb devices to see where the card is.
Its ioctls do not imply the two new calls introduced by Andreas
Oberritters patch (how could it -> anachronism?), but I have seen stuff
like "STRUCT LIST HEAD" etc.
Having found the card it is added to the correct device and demux.
Alevt's way of performing the same task is much more primitive.
And thus buggy or, like in our specific case, susceptible to the latest
kernel changes.

To avoid hanging processes a kind of monitoring daemon is working in the
background: It's taking care of the program map table (I wrote "program
management table" in one of my previous postings and that's crap,
sorry!). It somehow (correct me if I am wrong!) makes the demux release
dependent from the current contents of the PMT.
So you can switch the channel AND change the transponder (ex.: ARD ->
ZDF) with an external application, and alevt-dvb will follow the new
transponder by reading and "advertising" the new PMT to the other
components instead of causing a hanging process not knowing how to deal
with the new PMT.


The solution of the problem, without the slightest kernel change, is:

Pump up alevt-dvb with the necessary daemons, system calls and functions
found in mtt.
The question is: Which are necessary, which are redundant?

To accomplish that I need an experienced application programmer coaching
me. I definitely cannot do that on my own. The simpler tasks to do I
already did in my version 1.7.0. But this one is not that trivial.
Without qualified coaching I am lost.

If V4L/DVB weren't a scarcities management (which it will always be as
long as MCC is maintainer here), if it were a melting pot of real
sputtering people instead, it would not be the slightest problem to
ressolve the issue.

But instead there are people here who claim to be short in time on the
one hand but are performing completely effectless "discussions" here.

And that's insane, isn't it?
And the other insane gesture is blindly pushing through kernel
changesets without caring for the consequences at all.

Close your eyes - Signed-off-by - push it through - bunk!
It's the ellbow egoism behind the gesture which is insane here.


RGDS

CS


