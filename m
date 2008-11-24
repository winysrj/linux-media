Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L4WkB-0000iQ-Bi
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 09:24:33 +0100
Received: by ug-out-1314.google.com with SMTP id x30so642473ugc.16
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 00:24:27 -0800 (PST)
Date: Mon, 24 Nov 2008 09:24:14 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <492A53C4.5030509@makhutov.org>
Message-ID: <alpine.DEB.2.00.0811240829050.26293@ybpnyubfg.ybpnyqbznva>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
MIME-Version: 1.0
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

On Mon, 24 Nov 2008, Artem Makhutov wrote:

(quoting Klaus...)
> > It is assumed that a device capable of handling "second generation
> > modulation" can implicitly handle "first generation modulation".
> > The flag is not named anything with DVBS2 in order to allow its
> > use with future DVBT2 devices as well (should they ever come).

I am sure than DVB-T2 devices will appear soon enough, as
that's going to go into regular service in the UK in a
year's time.  Other countries will lag, if they even make
the jump at all -- it depends how their plans for signal
delivery via terrestrial matches the frequency allocations
and the demand for these frequencies -- some countries
have explicitly stated their intent to treat DVB-T as an
unwanted child, while in others, HD bandwidth demand
could easily outstrip allocated frequencies and the
political division thereof between broadcasters.  That is,
perhaps outside of the UK one will have to search rather
intensively to find such devices for some time.

My question is about overlapping capability, which I'll try
to explain below:


> Wouldn't it be better to add something like this:
> FE_CAN_8PSK
> FE_CAN_16APSK
> FE_CAN_32APSK

Agreed.  In the case of DVB-T2, which I don't know by
heart, there are additional modulation modes, some of
which are already covered by existing capabilities or
definitions.  But I don't know if there are backwards
incompatibilities that aren't covered by the modulation
methods.

In particular, I'm thinking of DVB-S2 use of QPSK.  This
is something I haven't wrapped my head around, but I do
know that my DVB-S receivers and tuners cannot tune to
those DVB-S2 QPSK frequencies (listed in part in an earlier
mail I sent).


To go off-topic, can someone explain to me, simply, in
words of one syllable, just what it is that differentiates
a DVB-S2 QPSK transponder from a DVB-S QPSK transponder,
and better as something that can be plugged into the
definitions of the existing API -- like, say, rolloff
or something.


Looking at it from the perspective of the UK, where DVB-T
was introduced early using 2k FFT modulation, but as part
of DSO this is being changed to 8k, yet early consumer
equipment cut costs and corners in several ways to make
those devices incompatible (split-NIT, 8k mode) today --
definitions included within the capabilities for devices
under linux-dvb.  Wait, that's not a sentence.  I mean,
`can-dvb-t' for those devices is something like `can-qpsk'
in the dvb-s/s2 case.  Am I making sense?  I need sleep.



> FE_CAN_DVBS2
> Instead of FE_CAN_2ND_GEN_MODULATION ? It is too generic for me.

Maybe also a bit too overbroad/generic?  In the case that
DVB-S2 includes things not supported by existing consumer
products, intended for professional broadcasters, or future
data delivery, or something.


Feel free to ignore me, as I'm sort of commenting from the
sidelines, and I don't know what I'm talking about, and
I'm in desperate need of sleep.


thanks
barry bouwsmna

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
