Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KkqiR-0004r9-TA
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 03:41:31 +0200
Received: by ey-out-2122.google.com with SMTP id 25so125313eya.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 18:41:20 -0700 (PDT)
Date: Wed, 1 Oct 2008 03:40:59 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1222821078.5209.11.camel@pc10.localdom.local>
Message-ID: <alpine.DEB.2.00.0810010313370.4242@ybpnyubfg.ybpnyqbznva>
References: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
	<alpine.DEB.2.00.0809302137380.4242@ybpnyubfg.ybpnyqbznva>
	<4FEC93ECE8%linux@youmustbejoking.demon.co.uk>
	<1222821078.5209.11.camel@pc10.localdom.local>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Trouble with tuning on Lifeview FlyDVB-T
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

On Wed, 1 Oct 2008, hermann pitton wrote:

> Also above we see a tuning attempt to 562000000 Hz and previously we saw
> already a positive offset added 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ

> usually a negative offset like this is reported more regularly?

The original poster was able to quickly obtain lock in both
cases -- plus I would imagine that a tuner able to receive
signals 4MHz either side of the centre frequency can handle
a couple hundred kHz offset automagically -- certainly my
sat set-top-boxen handle typically a ten MHz range with most
full transponders...

In any case, the hg repository copy I have of uk-Rowridge
matches what I find with a quick giggle search:
   Rowridge DVB-T Info
   0 (zero)
   - (minus) 167000 Hz
   + (plus) 167000 Hz
   Mux 1 BBC    channel 23 freq 490000000 - offset = 489833000
   Mux 5 C      channel 26 freq 514000000 - offset = 513833000
   Mux 2 ITV/C4 channel 28 freq 530000000 0 offset = 530000000
   Mux 3 A      channel 30 freq 546000000 - offset = 545833000
   Mux 4 B      channel 32 freq 562000000 + offset = 562167000
   Mux 6 D      channel 33 freq 570000000 + offset = 570167000


However, as the original poster's frequency data shows
two additional significant figures not present in
either of these (in addition to the LP code rate that
differs), it obviously isn't the same source as the hg
repository -- whether obtained by parsing NIT data or
based on user-specified input frequencies or whatever...

Not that either one is guaranteed 100% reliable, though


(hope I make sense, when I should be sleeping)
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
