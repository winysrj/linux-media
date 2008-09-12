Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Ke6XH-0005qo-0c
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 13:10:00 +0200
Date: Fri, 12 Sep 2008 13:09:25 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <48CA0355.6080903@linuxtv.org>
Message-ID: <20080912110925.325010@gmx.net>
MIME-Version: 1.0
References: <48CA0355.6080903@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Hans Werner sent a large patch for the multifrontend HVR3000/HVR4000 =

> combined DVB-T/DVB-S/S2 support for the S2API tree. (Thanks Hans - this =

> was obviously a lot of manual merge work, it's greatly appreciated.)
> =

> What would everyone like to see happen with this patch?
> =

> Would you prefer to see this dealt with outside of the S2API discussion, =

> or would you like to see this included and merged? Let me know your =

> thoughts. Andreas also has the multifrontend thread running, so comment =

> here if you would like to see this as part of the S2API patches, or =

> comment on the Andreas thread of you want this as a separate patchset at =

> a later date.

Some comments for those who have not been following this story closely. I w=
ill
try to keep this S2API-relevant.

The reason for considering adding multifrontend support to S2API is that S2=
API
will certainly add HVR4000 support, and at that point we need to consider
how to handle the multiple frontends of that card.  The multifrontend patch=
 is quite
orthogonal to the S2API changes, both in the sense that it does not interfe=
re with them,
and in the sense that it is quite a different subject from changing the API.

The updates I made bring the patch right up to date so that it can be merge=
d with
the head of the S2API repository. It is quite general -- it can support all=
 multifrontend
cards (not just HVR3000/4000). It has been around for about 18 months when =
Steve
proposed it. Darron has been maintaining it at dev.kewl.org/hauppauge. I ha=
ve
used it for 9 months or so with (unmodified) Kaffeine. Darron's method for
supporting DVB-S2 features is replaced by the more general S2API.

In the end what the application sees is (for the HVR4000):
/dev/dvb/adapter0/frontend0: DVB-S/S2
/dev/dvb/adapter0/frontend1: DVB-T
Andreas' thread is the place to discuss exactly how this should work. Anywa=
y =

we have here a concrete implementation of one way to do it.

We need to be careful not to confuse the issues to do with the API. The most
important thing is to perfect and debug the design of the S2 API. But I hope
multifrontend support will go in to the kernel when the HVR4000 support is =
added.
Perhaps we shouldn't be too scared of trying to make progress by putting it=
 in S2API
at the most appropriate point in Steve's development schedule.

Regards,
Hans

-- =

Release early, release often.

GMX Kostenlose Spiele: Einfach online spielen und Spa=DF haben mit Pastry P=
assion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/61691=
96

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
