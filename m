Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KtonV-00046N-LM
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 21:27:43 +0200
Received: by ey-out-2122.google.com with SMTP id 25so616928eya.17
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 12:27:38 -0700 (PDT)
Date: Sat, 25 Oct 2008 21:27:19 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <954863512.20081025153114@ntlworld.com>
Message-ID: <alpine.DEB.2.00.0810252045040.20415@ybpnyubfg.ybpnyqbznva>
References: <200810251101.11569@centrum.cz> <200810251102.1298@centrum.cz>
	<200810251103.27574@centrum.cz> <200810251103.16869@centrum.cz>
	<20081025103126.5524db0f@pedra.chehab.org>
	<20081025170207.492f28bb@bk.ru>
	<954863512.20081025153114@ntlworld.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] S2API: Future support for DVB-T2
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

On Sat, 25 Oct 2008, david may wrote:

> Hello Goga777,
> > I'm wondering where is dvb-t2 broadcasting ? is it in h264 ?

The payload of DVB-T2 is -- at least from the perspective of
linux-dvb -- completely independent.  While Auntie is sending
H.264 in their tests, there is nothing to prevent other types
of payloads to be used with the better modulation ...

Of particular interest is that DVB-T2 allows use of a 1,7MHz
bandwidth channel, which happens to coincide with that of
DAB+ / DAB as currently in use, but with potentially a
greater bitrate (more stations, or possibly better quality
for those suffering from economy pressure) -- possibly making
those who have just binned their DAB boxen in favour of DAB+
once again having to throw their antiquated technology to
the wolves.  Or something.


> its clear we need DVB-T2 ASAP or we in the UK cant see this T2 when

Agreed, but one also needs hardware capable of the exended QAM
and whatnot compared with existing DVB-T (also today existing
with H.264).  'Twould be nice if the underlying support for the
extended modulation techniques were already present ahead of
widespread hardware availability, but often it takes months
after 'Doze supported hardware is available for Linux to be
able to support that hardware.


> it soon moves off the limited Guildford transmitter and on to the
> UK winterhill /NW transmitters later this year.

Sorry, but don't you mean next year (2009) about this time?
That's what I've read for the start of the DVB-T2 mux --
though I've also recently read that the Beeb is intending
to start DVB-T2 ahead of the scheduled DSO in selected
larger towns, thereby making DVB-T2 more widespread earlier
than originally planned, and thus driving up demand for
hardware capable of receiving these broadcasts that will be
widespread in a bit more than a few years...

An' givin' ye sprites the boot up the a*se ye need ta get
DVB-T2 support right 'n' proper, innit?


Chin chin,
beery bouwsma
drunken b'stard

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
