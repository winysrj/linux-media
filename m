Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KeRmH-0001Sk-M7
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 11:50:58 +0200
Date: Sat, 13 Sep 2008 02:43:37 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux dvb <linux-dvb@linuxtv.org>, Paul Chubb <paulc@singlespoon.org.au>
In-Reply-To: <48CB5D7A.3040403@singlespoon.org.au>
MIME-Version: 1.0
Message-ID: <485872.32367.qm@web46101.mail.sp1.yahoo.com>
Subject: [linux-dvb] Why my binary-only Win95 closed-source drivers trump
	your puny free-as-in-beer etc. [was: Re: why (etc.)]
Reply-To: free_beer_for_all@yahoo.com
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

Bow down before the might of my hardware that I can't use on
anything later than an LSI-11-based machine!  Replies there ------>
plz thx okbye

--- On Sat, 9/13/08, Paul Chubb <paulc@singlespoon.org.au> wrote:

> The third attempt by a Czech programmer succeeded, however it is 
> dependent on the mcentral.de tree and the author appears to

I have a serious question.  Really.  I mean it.

I want factual answers.  No flames.  If your native language
is not english, feel free to reply in personal mail in your
native language, and I will try to make sense of it -- sometimes
I feel that non-english speakers here would be far more effective
in their native language, as anyone who has heard or read me
fumbling through their native languange (english included) will
agree.

I periodically build the drivers from recent em28xx-new against
a recent kernel, and pass the needed patches upstream.  While
I have an EM288x device, it's not yet supported, so I can't
actually test my hacks.

I've just now downloaded the mcentral v4l-dvb source, in an
attempt to compile (notice I said nothing about functionality)
it against a recent kernel.  My observation so far is that it
has heaps of backwards-compatibility, and lacks a few recent
changes that I'm hoping to merge in.  (`Hope' the operative
word)

Otherwise I really don't pay attention to the details of the
drivers and their use, probably the reason for my question.

You can bet that as soon as Markus has time to write support
for the demodulators and such, that I'm going to try my hardest
to get it to work with a stock linux kernel.


Can you, or someone, explain the technical details of what needs
to be done to a random, or a particular driver on mcentral, to
get it into em28xx on linuxtv?  Or why it can't be done as is,
as I see a slow addition of drivers to linuxtv over time?

Or better yet, give me an example of code that won't fit into
linuxtv from mcentral.  That might keep me quiet for a while.

In spite of the fact that I may have the datasheet for one of
the chips in my unsupported device, there is no way I'll be
able to turn that into a driver, no matter how much mentoring
or handholding I get, whereas I might be able to stumble my
way through incompatibility issues with plenty of review.
Maybe in ten years or so, in the event I'm still alive, I'd
be able to whip together a driver free of the enforced DRM
(not the broadcast norm DRM, hmmm, does that deserve a place
in the digital-broadcasting API?)



> I understand from recent posts to this list that many in the community 
> are disturbed by the existence of mcentral.de. Well every person from 
> now on who wants to run the Leadtek Winfast DTV1800H will be using that 
> tree. Since the card is excellent value for what it is,

This is the second time I've read about incompatibility (an
either/or choice) between the trees.  That obviously isn't
acceptable to me.  Can you or someone give a *technical only*
overview of why this should be, so I can motivate myself to
do what I can to make it should not be so?

Again, no flames, minimal opinions, please.  Facts will be
`rewarded' by an `effort' on my part to try to `benefit'
everyone out there who wants additional `functionality', but
no promises.

Disclaimer:  if I don't make much sense, it's due to chronic
sleep deprivation, in part.


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
