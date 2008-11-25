Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1L52k0-0003Y5-JA
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 19:34:30 +0100
Received: by an-out-0708.google.com with SMTP id b38so49351ana.41
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 10:34:23 -0800 (PST)
Message-ID: <3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
Date: Tue, 25 Nov 2008 18:34:23 +0000
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "VDR User" <user.vdr@gmail.com>
In-Reply-To: <a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
	<492BBFD9.50909@cadsoft.de>
	<a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

> I find it a completely unacceptable thing to have the user tell
> the application what type of DVB devices the hardware provides.
> This is pretty much the first and simplest thing the *DRIVER* has
> to do. If a driver (API) doesn't allow this in a clean way, it's
> worthless!

I think you are overreacting here. Worthless is a strong word. Yes, it
imo also a major flaw, but it does not make the driver worthless, just
more cumbersome to use. In all honesty, having this as a user setting,
it would only need to be set once, which hardly qualify as hard work.
Try being a bit more friendly. Calling something worthless because of
a relatively small feature-lack is not.

> I don't care if this is a specific or a general flag, as long as
> it allows the application to clearly find out the kind of hardware
> that's available. It leaves me dumbfounded that this is suddenly
> such a big problem...

This has not suddenly become a big problem. The problem has been there
the whole time, it's just you and others making this into a big
problem. Really it is not. Of course everyone this fixed. Having a
good discussion about it is the best way of achieving that.

> You are not alone in that boat my friend.  Especially after reading
> the comments about how "thought out" the api is.  How could you
> possibly miss such a fundamental element?!

Stuff gets left out sometimes. I bet you forgot something sometime as
well. This is done by humans.

>> <conspiracy_theory><sarcasm>
>> Or is the S2API already "dead", and it's sole purpose was to
>> prevent "multiproto" to make its way into the kernel? And now that
>> this has been achieved, nodody really cares whether it can be used
>> in real life?
>> </sarcasm></conspiracy_theory>
>
> Hey, stranger things have happened.  Not much surprised me these days.
>  Hopefully somebody will get this sorted out and fixed very soon as it
> shouldn't even be an issue at this point!!

This is just ridiculous and has no place on this mailing list. I hope
that if you think about it, you will agree.

> From my personal POV. I think S2API isn't missing something concerning
> tuning.

If someone is missing a feature that obviously should be supported,
then something is missing. If you do not need that feature I guess
that is good for you :-)


Regarding the actual problem, I have never been happy with the
"FE_QPSK" and "FE_OFDM" enum fe_types. This imho does not make much
sense. I would like to know what a card is supposed to receive. One
modulation type is not locked to a transmission medium, nor frequency
range, and QPSK can easily be used in a cable network if one wished to
do so. I second the proposed solution of Artem, but I would do it with
a twist.

If possible, I would keep the old system for backwards compatibility,
and create a different command where this confusing QPSK/OFDM/QAM gets
removed altogether. I would have a enum frontend type that would
indicate what standard is being followed, if any. An additional
indication of all the different modulation types that is supported is
a must. In addition to what Artem proposed, I would like to be able to
read a supported frequency range ( i.e 950-2150 for satellite tuners
), and supported symbol rates. The last part there about symbol rate
could be different for different modulation types. Most people would
not need this, but some do. I don't think I have a good solution for
how one would solve that, but one way would be if you could do as with
the ca_types supported that is returned from different CAMs. One could
return a list of stucts with modulation types and their respective
limits and parameters. I don't know if this is really useful, but I
remember that on some of the satellite modems we used, the symbol rate
was limited by the center frequency of the carrier. If you got to
close to the max and min, the carrier bandwidth would have to be
reduced. There might be some equipment out there that has such
limitations, and it could be worth adding support for that I guess.

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
