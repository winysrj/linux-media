Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KfGDM-0007px-A0
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 17:42:15 +0200
Received: by wr-out-0506.google.com with SMTP id c8so1079551wra.13
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 08:42:07 -0700 (PDT)
Message-ID: <37219a840809150842l3a6260j4b57f14026e5c40a@mail.gmail.com>
Date: Mon, 15 Sep 2008 11:42:06 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Julian Scheel" <julian@jusst.de>
In-Reply-To: <48CDF7A1.2020905@jusst.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com>
	<d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
	<48CC4D35.3000003@gmail.com>
	<d9def9db0809140838k2ced5211gc2690e76f53a98be@mail.gmail.com>
	<48CD43C1.2090902@linuxtv.org> <48CD5D19.1070700@gmail.com>
	<1221425146.4278.30.camel@morgan.walls.org>
	<48CDF7A1.2020905@jusst.de>
Cc: linux-dvb@linuxtv.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Mon, Sep 15, 2008 at 1:50 AM, Julian Scheel <julian@jusst.de> wrote:
> Andy,
>
> just to clarify things a bit I'll give a short statement now.
>
> Andy Walls schrieb:
>> Though I can't read much German, after looking at the jusst.de website I
>> can't help but think that you as well have financial interests driving
>> your actions.  If so, then your statements display quite a bit of
>> hypocrisy.
>>
> The role of jusst technologies in the whole multiproto story is as
> following:
> The time when DVB-S2 came up this was of course of major interest for
> jusst technologies, so we searched for people working on drivers. At
> that not many people did seem to care about this stuff - but Manu did.
> So we got in contact and tried to help him as much as we can, which
> included making up connections to KNC1 for technical questions and
> datasheets, provide a KNC1 testing board and later then give free
> web/codespace to Manu.
> Furthermore we of course did lots of testing of multiproto. But never we
> did pay Manu for any of this work.
> Reading that you should recognize that there can't be much financial
> interests for Manu.
>
> Seeing that you impute hyprocrisy to Manu due to "facts" you don't have
> proven in any way makes me a bit contemplative. I don't like being
> political when talking about technical terms (which linuxtv in first
> place should be about imho) - anyway this one time I will give a
> somewhat political statement, too.
> All you guys who are blaming Manu to do some wrong or bad stuff, what is
> your point? - I see you searching quote where Manu did talk in a
> somewhat unpolite manner just to blame him of being the wrong person
> introducing a new API? - I have no interest in doing the same quoting
> with your postings or the so called competitors postings, but I'd bed I
> could quote almost any of you in a not less distracting manner than you
> like to do with Manu.
>> Manipulating (i.e. stalling) the timing of Multiproto being merged into
>> the v4l-dvb tree or kernel, for you or your employer's gain, would be
>> little different from the motivations you allege Steve of having.
>>
>> Since the major gripe I'm reading on the list "is that multiproto has
>> taken too long" and since it seems to me the only thing that shook it
>> loose was a competing proposal, please save the venom for when you
>> actually have some clear moral high-ground to stand on.  I don't see it
>> from here.
>>
> Using "taking too long" as an argument against an API proposal is really
> interesting. What did you expect? - A quick shot which is not well
> thought about wouldn't have be a good thing for anyone.
> I'm absolutely fine if anyone would came up with real technical
> arguments, but reading many postings so far I couldn't find much of such
> statements.
>> As for the technical superiority of either API proposal; that probably
>> just doesn't matter.  I've seen policy/political decisions force
>> suboptimal technical solutions at work time and time again.  If you
>> really believe you have a superior product technically; then perhaps you
>> should work to make it superior politically as well.  Mud-slinging can't
>> be a good long term strategy toward that end.
>>
> To be political again: Thank you for blaming jusst being not interested
> in proper technical solutions. What makes you thinking of this? - Just
> the fact that you recognize jusst as a commercial company? Very interesting.
>
> I really have a feeling that many people here are mostly interested in
> making politics instead of thinking about technical solutions which
> makes all this a horrible topic for all that people who are interested
> in a working solution (which Manu has proven to deliver) - mainly the users.
>
> So far this is my statement (in representation for jusst technologies)
> for the moment.


Julien,

In summary, the bottom line is this:

Manu did a great job with the multiproto API, people were happy using
it, and all of the LinuxDVB developer community was happy with the
work that was done, and we all wanted to merge it ~ two years ago.

Back then, Manu said that it wasnt ready, so for some time we waited
for him in hopes that he would agree that it was ready for merge.

As more months went by, Manu was asked if he would be merging his
changes, and he kept answering to the effect of "it's not ready yet,
but should be in a few weeks"

Months and months and months went by since then, with an occasional
ping to Manu, with the reply "not ready yet" ...

Two years is a very long time to wait for a new API, especially
considering that it was functional from the start.  It was looking
like Manu may not have had any intention at all to merge his work into
the master v4l/dvb development repository --  It should be not be
surprising at all that Steven Toth felt the need to come up with his
own solution.

Steven posted a proposal for his API expansion solution, and he
received positive feedback.  Immediately, Manu broke out of his
silence and sent in a pull request.


Is there malice here??  No.  There is development, and developers
looking to move forward.  Nobody is at fault.


I have posted the above just to clarify what the "politics" actually
are, here.  The only real politics going around are those that are
accusing others of politics themselves.

Had Manu been willing to merge his work earlier, this would have all
been a non-issue.  However, now there is an alternative proposal on
the table, which appears to be more robust and may have more potential
that the multiproto proposal.

Does that mean multiproto is disqualified?   Absolutely not.

Does the fact that multiproto was there first mean that it will be
merged without question now that it is suddenly available?  No, not
necessarily.

What does it mean?  It means that now there are two proposals on the
table.  Two ways to solve a problem using different ideas and methods.

The end users that have piped into the discussion are mostly concerned
with which API demonstration repository already contains support for
their device.  This should have no bearing whatsoever on the decision
of the linuxDVB API extension.  All drivers will be ported to
whichever solution is decided upon.

Now is the time to examine these solutions from a developer point of
view, in terms of how this affects kernel developers and application
developers alike.  There is no reason to rush into things just because
a pull request has been made -- the outcome of this decision is highly
important, and we will have to live with the decision for a good long
time.

Regards,

Michael Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
