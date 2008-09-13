Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KebRY-00047z-Jg
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 22:10:10 +0200
Date: Sat, 13 Sep 2008 13:09:33 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808300017o1e571cddse38aceeb9ce7df8f@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <594291.64273.qm@web46113.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

--- On Sat, 8/30/08, Beth <beth.null@gmail.com> wrote:

> I had been doing some tests this morning on XP and why I
> didn't made them before?.
> 
> I think that I have two problems, first one is the signal quality, I
> have 65% of level and 98% of quality, 65% maybe the problem of the
> impossibility of tunning certain transponders, I had tried some of the
> problematic ones and the can't lock and scan on XP probrams like
> ProgDVB. So first thing I need to increase the signal level.

Hola Beth!  Sorry for the late reply, but I do not have
too much that is new to add...  :-(


> Second, the incorrect vid&aid, really I don't know what is happening

I took a look at your `scan' results.  But first, ...

You have told me (in personal mail) that your location is
such that you should be well within the 80cm sat dish
area of Astra 19E2.  So, if you have problems with particular
transponders -- and the lack of the german ARD 11836 was very
obvious to me -- then I would look at your satellite dish
installation.

You are not in the centre of the beam, but close to the
border, where reception will be not perfect, yet quite
possible.  Here, it is actually a good thing to check
whether you can receive certain weak transponders, such as
ARD -- if you can move your satellite dish for a strong
signal on this (which previously never appeared on your
scans), then you should get a strong signal on everything.

If you cannot get a strong signal on every transponder, then
I would wonder about your satellite dish -- but as you are
mostly interested in the D+ Espana stations, which you can
receive most of the time, that is not so much a problem.

(Also, Hispasat at 30E should carry most of the same channels,
plus many extra that are not at 19E2...)

You have probably already done this now  :-)



Anyway, I looked at your `scan' results, and, while you still
are missing certain transponders/frequencies, what I did 
notice was that every time you got audio+video PIDs of :0:0: ,
there were always the services from the previously-scanned
transponder -- the problem which I hoped I had `fixed' with
my hack.

The biggest difference between your `scan' and mine, is that
I start a new `scan' for each frequency -- so I need to let
my `scan' check all the transponders at once, to see if what
I thought was a ``fix'' really works, or not...



On the third hand, your satellite card is one of these
new-fangled ones that needs to be supported by either the
multiproto or the new S2API ... um ... driver API thingy.
So there may be some unresolved issues there.  Or not.
I really can't say.  Perhaps things will be better soon.

In any case, you should be able to get a strong signal
from the D+ channels of particular interest to you, and
at the least, the `scan' results you have with correct
PIDs are not likely to change too much soon, so this
should help you receive the stations of interest, and get
better reception of all others...


If I see the same problem again with my receiver, and
find a fix for it, I will let you (and the list) know...


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
