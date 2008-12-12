Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LB3Dq-0005Jt-N1
	for linux-dvb@linuxtv.org; Fri, 12 Dec 2008 09:18:08 +0100
Received: by ug-out-1314.google.com with SMTP id x30so259146ugc.16
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 00:18:03 -0800 (PST)
Date: Fri, 12 Dec 2008 09:17:52 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Jordi Molse <jordi.moles@gmail.com>
In-Reply-To: <4941A076.3060107@gmail.com>
Message-ID: <alpine.DEB.2.00.0812120822530.989@ybpnyubfg.ybpnyqbznva>
References: <493FFD3A.80209@cdmon.com>
	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>
	<4940032D.90106@cdmon.com>
	<alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>
	<49401C73.1010208@gmail.com>
	<1228955664.3468.21.camel@pc10.localdom.local>
	<494066C2.90105@gmail.com>
	<1228958740.3468.28.camel@pc10.localdom.local>
	<4940C9D6.2020704@cdmon.com>
	<alpine.DEB.2.00.0812111415560.989@ybpnyubfg.ybpnyqbznva>
	<49411A6E.2020107@gmail.com> <49412BF9.5010401@cdmon.com>
	<alpine.DEB.2.00.0812111626260.989@ybpnyubfg.ybpnyqbznva>
	<4941A076.3060107@gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working through
 diseqc anymore
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

On Fri, 12 Dec 2008, Jordi Molse wrote:

> However, i haven't been able to get diseqc working and i don't think i
> will....

It is too early to give up now!!1!  At least, I shall not
give up until the sun melts away enough of the snow, so that
I can go out and get more beer, though the melted snow
will probably freeze into slick ice, and I'll probably
end up hurting more than last time, this time with broken
glass embedded into my body...  A direct infusion of that
evil alcohol into by bloodstream without the middleman of
passing the lips, gums, tongue, nose -- heck, why bother
searching to find excellent-tasting beer when I won't notice
and appreciate the difference anyway...


> i used to have this card running in a dual boot with windows xp, where
> everything worked like a charm, and another one where i kept installing linux
> distros without any luck until "kubuntu hardy" came out. At that point, as the
> card with diseqc worked "out of the box", i decided to erase all data and move

One card, worked in two boxes; the first box a 'doze box,
the second box Kubuntu Hardy...  (unsupported before then)


> then i upgraded the system and also moved the tower from its place to next to
> the tv (to be a medicenter computer :) ). Then i couldn't view the channels
> anymore. I tried to retune with no luck... I check all the cables, just in
> case one of them was in bad shape. I even replaced the T connectors, just in

System `upgraded' and stopped DiSEqC working; but also,
system moved.  No success since then.

Question:

When you moved the system, did you have to add new cable?
If so, how long was the length of cable from your machine
to the DiSEqC switch before you moved it, and how long is
this cable now, or is it the same length and same cable?

Other question, what do you mean by a `T connector'?
For satellite, I am familiar with the `F' connector, and
I am also familiar with other types of `T' connector,
but they should have no place in a satellite system...



> so... is it possible that somehow i've broken the card someone? the truth is

Not too likely -- DiSEqC switching is basically the same
as a modulated version of the 22kHz tone which is used to
switch between low (below 11700) and high (above 11700)
frequencies by the LNB.

However, I have had experience with several different
2/1 and 4/1 DiSEqC switches at the end of long cable
runs, which could not be properly switched by some DVB-S
cards, but could -- or could not be switched by a consumer
satellite receiver, but which worked flawlessly when located
a few metres from the receiver, instead of nearly 100m away.
The cable length attenuated or otherwise corrupted the
DiSEqC bursts from some devices so that they failed to work.


> that what used to work in windows... doesn't work anymore... this evening i
> went back to windows just to check if the card, the diseqc and everything was
> fine... and i had so many problems to get the satellite working as before. i
> used to use progdvb, which supported diseqc for my card and now it just can't
> tune through diseqc, none of the two satellites. other software does know how
> to get through diseqc, but only switch 1.

So, the same setup, apart from being moved, now no longer
works the same as it used to work with 'doze, and 'doze
either no longer works at all, or fails to switch DiSEqC?

Note that a typical DiSEqC switch will simply pass along
its 1/2 or 1/4 or 1/8 or 1/whatever input, when it does
not receive the switching signal to select 2/2 or whatever.



> i've checked cables and i don't think it's an issue from the diseq thing,
> cause i've got two and both give the same problem.

Two?  Two what -- DiSEqC switches, two cables to switches?

Do you have a normal consumer satellite receiver, as well
as your different computer boxes?


I'm going to guess based on where I think you are located,
that you have something like the following -- please correct
me where I ass-u-me wrong, and add any additional info that
is missing from this...

Dish+LNB pointed at 28E, large enough to receive BBC/ITV/etc
Dish+LNB pointed at 19E (or offset mounted on 28E dish)
DiSEqC switch(es) located near dishes -- or near your tuner
so you can connect directly from each LNB as a test?
Single cable run from switch to computer, or two cable runs
from two switches?

LNB19E--
        \               long cable run
         2/1 DiSEqC----------------------------Computer
        /
LNB28E--

You also mention DVB-T/radio from this card; if you could
mention how that affects the above, if at all (it should
not, but I never know for sure)

Also, if you have any spares (a pile of DiSEqC switches,
other DVB-S capable cards, etc), it would be handy for me
to know -- in the case of my 4/1 switches located more
than 50m from my tuners, it was partially a case of
swapping in other switches from my pile of them until
finding a working combination, or running an additional
several hundred metres of cable to permit me to switch
the four positions close to the tuners...


thanks,
barry bouwsma
not an expert, by any means

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
