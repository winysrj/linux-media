Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Kihm6-0000Gr-CQ
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 05:44:19 +0200
Message-ID: <48DB0908.4020207@gmail.com>
Date: Thu, 25 Sep 2008 07:44:08 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
In-Reply-To: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
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

Hans Verkuil wrote:
>> On Wed, Sep 24, 2008 at 11:41 PM, VDR User <user.vdr@gmail.com> wrote:
>>> On Wed, Sep 24, 2008 at 8:21 AM, Mauro Carvalho Chehab
>>> <mchehab@infradead.org> wrote:
>>>> The decision were already taken by the group.
>>>>
>>>> It should be noticed also that the public announcement took some time
>>>> to
>>>> be ready, since we all carefully reviewed it to reflect the
>>>> understanding
>>>> that the group had.
>>>>
>>>> Both API's work, and people needed to choose between one of the
>>>> proposals.
>>>>
>>>> Each one there had enough time to read and understand each proposal,
>>>> since
>>>> the patches were available more than one week before the meeting, and
>>>> everybody were aware that the decision are scheduled to happen during
>>>> LPC.
>>>>
>>>> Each one voted based on their own technical analysis, on a meeting that
>>>> took about 2:30 hours, on the day after the presentations. People had
>>>> enough time there to discuss, explain their ideas with the help of a
>>>> whiteboard, decide and improve the proposal.
>>>>
>>>> S2API was choosen, since it was considered the better proposal for
>>>> everybody there. None of the presents voted for Multiproto.
>>>>
>>>> Now that the decision were already taken, it is not time anymore to
>>>> argue
>>>> in favor to any other proposals. We need to move ahead and finally add
>>>> support for DVB-S2 and the remaining missing digital TV's at kernel.
>>>>
>>>> Thank you and everyone else involved on adding support for the missing
>>>> standards.
>>>>
>>>> Let's move to the next step: finally add API changes and drivers for
>>>> DVB-S2 and prepare support for the remaining missing standards.
>>> It's no secret to anyone that there has been foul play, and blatantly
>>> clear there is bias against Manu himself, and multiproto as a result,
>>> based on personal differences & past conflicts.  You can't possibly
>>> expect the dvb community to believe a fair & balanced meeting took
>>> place to discuss these proposals when half the people there already
>>> signed on for s2api, and the other half don't have the knowledge &
>>> experience with dvb to make well-informed decisions.  You can't
>>> possibly think people will believe any of you (who've openly admitted
>>> support for s2api) spent 2 seconds defending multiproto, or even
>>> assessing the proposal from an unbias technical standpoint.
>>>
>>> It's very convenient that you've completely ignored multiple requests
>>> for more in-depth details that actually prove your points have real
>>> technical merit and aren't just the result of some self-interest
>>> politics and b.s.  Yet, you had no problem writing paragraphs about
>>> how the decision has been made and everyone should just accept it.
>>> Sorry, people aren't going to just accept it because this whole thing
>>> has been tainted by misleading people, misrepresenting the truth, and
>>> sometimes flat out lying.
>>>
>>> Valuable members of the community have turned, and are turning away
>>> because of how poorly dvb has been maintained, and how self-serving
>>> some people act.  I'm thankful that more people are being exposed &
>>> becoming aware of what's been going on in hopes that at the very least
>>> some kind of steps will be taken to stop the misuse & abuse of power
>>> at the front of the dvb train.
>>>
>>> Again, if there is truth to your claims that s2api is the best
>>> technical solution, then convince us all by providing tangible proof
>>> rather then expecting everyone to take your word for it while ignoring
>>> our requests for such information.  You have an obligation to the
>>> community to justify your actions, and be held accountable for them.
>>>
>> There hasn't been much positive feedback here! How about let's talk to
>> split the
>> v4l and dvb development in order to not give Mauro the full authority
>> over the whole
>> 2 subsystems where he hardly anything contributed (to the second part).
>>
>> Don't see this as a flamewar, Andrew Morton and a few others are
>> following that discussion now.
>>
>> Mauro as for you try to justify your step technically, the only point
>> we've seen for now was from
>> Patrick Boettcher (which was a good one from his side) but also the
>> other involved people (within that
>> 8 people group in Portland should point out their opinion and
>> technical objections/reasons now).
>>
>> Officially it looks like you had 3 people supporting the Stevens
>> proposal and 5 people who didn't know about
>> the framework at all and explaining them that the DVB-S2 step is the
>> better one to go whereas you had
>> noone representing the multiproto path. Such a vote is highly doubtful
>> then.
>>
>> Hans Hverkuil:
>> I saw you in IRC that you support that proposal please also state out
>> your opinion and/or ask your questions
>> what/why things have been done like they are done in the multiproto
>> tree and why you don't support it.
>>
>> It finally can really end up with a good solution either multiproto or
>> S2 but everyone should understand and not only
>> a few people.
> 
> These are my reasons for voting in favor of the S2 API. Note that I looked
> at the public API part as that is the hard part of these patches. I've
> created several V4L2 APIs in the past so I know how important that is.


Thanks for the explanation on your position. I should explain some
aspects as well.


> 1) It's pretty much guaranteed to be future proof by its very design. It
> is next to impossible to predict what they will come up with next in the
> future, so this is a very important property.

The multiproto API is just as future proof as S2API. This was the very
basic cause for the evolution of multiproto, if you see the history.

We've had lots of discussions on having it on the same mailing lists abd
is future proof and thus it evolved. All the discussion threads are
archived.


> 2) It makes it easy to set separate properties, so you can 'fine-tune' the
> tuner, so to speak. Or retrieve other tuner properties that way. Basically
> it gives the application fine-grained control of the tuner properties,
> which is rather nice.

You don't manually control a tuner, whereas a demodulator controls a
tuner, for the relevant operation. For analog operations, a tuner is
more important, but we are not dealing with analog operations here, we
are dealing with adding a new Digital standard for user applications to
talk to a frontend: ie a demodulator + tuner. The tuner happens to be
running in tandem to the algorithm which the demodulator is run basically.


> 3) A consideration for me is that this API can be used equally well for
> the V4L2 analog tuner side. There is nothing DVB specific about it. It
> would solve some long-standing issues I have with LNA in analog tuners and
> I'm seriously thinking of adding support for this to V4L2. It's nice to be
> able to use the same external and internal APIs for tuners in both
> subsystems.


An existing API shouldn't be dependant on another API.


> No doubt the discussions would have been more lively had Manu been
> present, but I doubt it would have made any difference. The discussions
> were kept on a technical level, there were no conspiracy plots or any of
> that nonsense. It's an API for crying out loud, not the end of the world.
> Just work with Steve to convert the current devices in the multiproto tree
> to use this API. If there is anything missing kick Steve and he'll have to
> add whatever is needed. That's *his* responsibility and he accepted that
> during the discussions.


It can be the reverse way too ..


> The only reason I replied at all is that I thought it a fair request to
> have more detailed information on the reasoning behind the decision.
> 
> I do not intend to discuss this further, mostly because all this has been
> discussed to death already. Two competing APIs, one 'wins'. That's life
> and it sucks if your API doesn't get in. I can totally understand that
> Manu is unhappy.


True, with all those backstabbing going on.


> Just take a vacation from driver programming for a week
> or so (that worked for me in the past) and when you're over it start
> making sure your drivers are supported by the kernel and your users are
> happy. That's where the real satisfaction of kernel programming comes
> from, after all: that users can just install Fedora or Ubuntu and having
> their hardware supported out of the box thanks to our collective hard
> work.

The same can be said, on the other side as well.

Regards,
Manu




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
