Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Kfw5G-00076U-5r
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 14:24:39 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1811786nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 05:24:34 -0700 (PDT)
Date: Wed, 17 Sep 2008 14:24:31 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809170440g7ed779f9m9331ff9eddb78745@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809171357010.5927@ybpnyubfg.ybpnyqbznva>
References: <786613.55940.qm@web55106.mail.re4.yahoo.com>
	<alpine.DEB.1.10.0809171253300.5927@ybpnyubfg.ybpnyqbznva>
	<d9def9db0809170440g7ed779f9m9331ff9eddb78745@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] software radio
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

On Wed, 17 Sep 2008, Markus Rechberger wrote:

> >> Is it possible to access the sampling subsystem of a dvb card
> >> as like skystar 2 or any other ?

> have you had a look at:
> http://www.gnu.org/software/gnuradio/

I have now  :-)   thanks

And I feel really stupid, thinking this was a beginner question.
And I wish I had been asleep now.  My foot tastes terrible.

As you see, my understanding of the word `sampling' is based
on my understanding and work in radio and telephony some 30 years 
ago, when I didn't even realize that what I was doing would be 
somehow relevant today.

Anyway, I really do not know, but I would imagine that most
current sat devices, including the SkyStar, expect to have a 
hardware demodulator in place, and have no provision to get at
the signal on the other side of that chip.


Which makes me wonder -- the IF of a satellite signal is
typically 1GHz and up.  Is there a standard second IF
frequency that various hardware uses?  Given that it is
possible to have transponders with high symbol rates, I
wonder if satellite software receivers will be pushing too
hard on bandwidth of various busses -- which already seem
to suffer when delivering already-demodulated data.

Those familiar with chip and board design can answer the
original question far better than I ever could.


Then again, I have my head firmly set on 20-year-old
hardware designs...


think i'll quietly close my mailreader
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
