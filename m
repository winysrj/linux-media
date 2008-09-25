Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809241949i5b368f01w5f635d59cd19dd1f@mail.gmail.com>
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48D9F6F3.8090501@gmail.com>
	<alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
	<48DA15A2.40109@gmail.com>
	<alpine.LFD.1.10.0809240942250.28125@areia.chehab.org>
	<a3ef07920809241441gea2c09al6e2ed32589ad6fa4@mail.gmail.com>
	<d9def9db0809241901g56a54750kbfccecc77b111ec7@mail.gmail.com>
	<37219a840809241947w6ca35351xa15920de6ff41aab@mail.gmail.com>
	<d9def9db0809241949i5b368f01w5f635d59cd19dd1f@mail.gmail.com>
Date: Thu, 25 Sep 2008 05:04:37 +0200
Message-Id: <1222311877.3323.101.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: Manu Abraham <abraham.manu@gmail.com>, Greg KH <greg@kroah.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Am Donnerstag, den 25.09.2008, 04:49 +0200 schrieb Markus Rechberger:
> On Thu, Sep 25, 2008 at 4:47 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > On Wed, Sep 24, 2008 at 10:01 PM, Markus Rechberger
> > <mrechberger@gmail.com> wrote:
> >> On Wed, Sep 24, 2008 at 11:41 PM, VDR User <user.vdr@gmail.com> wrote:
> >>> On Wed, Sep 24, 2008 at 8:21 AM, Mauro Carvalho Chehab
> >>> <mchehab@infradead.org> wrote:
> >>>> The decision were already taken by the group.
> >>>>
> >>>> It should be noticed also that the public announcement took some time to
> >>>> be ready, since we all carefully reviewed it to reflect the understanding
> >>>> that the group had.
> >>>>
> >>>> Both API's work, and people needed to choose between one of the proposals.
> >>>>
> >>>> Each one there had enough time to read and understand each proposal, since
> >>>> the patches were available more than one week before the meeting, and
> >>>> everybody were aware that the decision are scheduled to happen during LPC.
> >>>>
> >>>> Each one voted based on their own technical analysis, on a meeting that
> >>>> took about 2:30 hours, on the day after the presentations. People had
> >>>> enough time there to discuss, explain their ideas with the help of a
> >>>> whiteboard, decide and improve the proposal.
> >>>>
> >>>> S2API was choosen, since it was considered the better proposal for
> >>>> everybody there. None of the presents voted for Multiproto.
> >>>>
> >>>> Now that the decision were already taken, it is not time anymore to argue
> >>>> in favor to any other proposals. We need to move ahead and finally add
> >>>> support for DVB-S2 and the remaining missing digital TV's at kernel.
> >>>>
> >>>> Thank you and everyone else involved on adding support for the missing
> >>>> standards.
> >>>>
> >>>> Let's move to the next step: finally add API changes and drivers for
> >>>> DVB-S2 and prepare support for the remaining missing standards.
> >>>
> >>> It's no secret to anyone that there has been foul play, and blatantly
> >>> clear there is bias against Manu himself, and multiproto as a result,
> >>> based on personal differences & past conflicts.  You can't possibly
> >>> expect the dvb community to believe a fair & balanced meeting took
> >>> place to discuss these proposals when half the people there already
> >>> signed on for s2api, and the other half don't have the knowledge &
> >>> experience with dvb to make well-informed decisions.  You can't
> >>> possibly think people will believe any of you (who've openly admitted
> >>> support for s2api) spent 2 seconds defending multiproto, or even
> >>> assessing the proposal from an unbias technical standpoint.
> >>>
> >>> It's very convenient that you've completely ignored multiple requests
> >>> for more in-depth details that actually prove your points have real
> >>> technical merit and aren't just the result of some self-interest
> >>> politics and b.s.  Yet, you had no problem writing paragraphs about
> >>> how the decision has been made and everyone should just accept it.
> >>> Sorry, people aren't going to just accept it because this whole thing
> >>> has been tainted by misleading people, misrepresenting the truth, and
> >>> sometimes flat out lying.
> >>>
> >>> Valuable members of the community have turned, and are turning away
> >>> because of how poorly dvb has been maintained, and how self-serving
> >>> some people act.  I'm thankful that more people are being exposed &
> >>> becoming aware of what's been going on in hopes that at the very least
> >>> some kind of steps will be taken to stop the misuse & abuse of power
> >>> at the front of the dvb train.
> >>>
> >>> Again, if there is truth to your claims that s2api is the best
> >>> technical solution, then convince us all by providing tangible proof
> >>> rather then expecting everyone to take your word for it while ignoring
> >>> our requests for such information.  You have an obligation to the
> >>> community to justify your actions, and be held accountable for them.
> >>>
> >>
> >> There hasn't been much positive feedback here! How about let's talk to split the
> >> v4l and dvb development in order to not give Mauro the full authority
> >> over the whole
> >> 2 subsystems where he hardly anything contributed (to the second part).
> >>
> >> Don't see this as a flamewar, Andrew Morton and a few others are
> >> following that discussion now.
> >>
> >> Mauro as for you try to justify your step technically, the only point
> >> we've seen for now was from
> >> Patrick Boettcher (which was a good one from his side) but also the
> >> other involved people (within that
> >> 8 people group in Portland should point out their opinion and
> >> technical objections/reasons now).
> >>
> >> Officially it looks like you had 3 people supporting the Stevens
> >> proposal and 5 people who didn't know about
> >> the framework at all and explaining them that the DVB-S2 step is the
> >> better one to go whereas you had
> >> noone representing the multiproto path. Such a vote is highly doubtful then.
> >>
> >> Hans Hverkuil:
> >> I saw you in IRC that you support that proposal please also state out
> >> your opinion and/or ask your questions
> >> what/why things have been done like they are done in the multiproto
> >> tree and why you don't support it.
> >>
> >> It finally can really end up with a good solution either multiproto or
> >> S2 but everyone should understand and not only
> >> a few people.
> >>
> >> Markus
> >
> > Markus,
> >
> > After over two years, a decision has been made.  Up until now, many
> > people have been unhappy.  Now less people can be unhappy.  An
> > extension to the api has been merged, and now we can move forward.
> >
> > There have been enough debates on the mailing lists to date, and there
> > is enough information available about each proposal and all of the
> > details surrounding them.  We need not hash this out again here.
> >
> > Nobody wants to debate this any more -- a better use of our time is to
> > start working on userspace applications for the new supported
> > standards.  Please redirect your energy towards something creative.
> >
> > Make love, not war.
> >
> 
> sure state out technical reasons and that's what it is about otherwise
> a serious split should happen asap.
> I personally invite you to be the first one here!
> 
> Markus
> 

Markus,

you can't invite anybody, since you stay out of kernel by your own
decision and because Manu did not let you in the way you came :)

Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
