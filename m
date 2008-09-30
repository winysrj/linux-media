Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KklVx-0006N6-G2
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 22:08:12 +0200
Received: by ik-out-1112.google.com with SMTP id c21so172990ika.1
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 13:08:05 -0700 (PDT)
Date: Tue, 30 Sep 2008 22:07:13 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Lee Jones <slothpuck@gmail.com>
In-Reply-To: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0809302137380.4242@ybpnyubfg.ybpnyqbznva>
References: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

On Tue, 30 Sep 2008, Lee Jones wrote:

> The problems seem to occur with scanning, however. While tuning, I get
> several lines which look like this:
> >>> tune to: 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)

Two things:  If you scan with `-v', you should get some
feedback as to how close your receiver is to locking on
the frequency.

Second, it may or may not be a problem, as one of my cards
managed to tune and lock a carrier even when fed totally
wrong tuning data apart from the correct frequency, but
are you sure that FEC_3_4 is correct also for the LP code
rate?  The tuning data I see in recent dvb-apps gives `NONE'
 -- this probably won't affect anything, but in the unlikely 
chance it might...


> After completion, some channels are missing (e.g. BBC1 is there, but
> ITV or BBC4 aren't;

The above frequency is for BBC4; ITV uses 64-QAM unlike the
BBC multiplexes, so I'll assume that is correct in your
initial tuning data (as the above CRLP value doesn't match
that based on the OFCOM data in dvb-apps)...


> This still produced some "WARNING:>>>tuning failed!!!" messages but
> appears to have found the 'missing 'channels. But then using the
> dvbutils' program tzap seemed to tell a different story. Some channels
> existed but yet didn't produce *any* data (I could confirm that they

Can you give the lines with the PIDs of these `missing' channels
which you have found?  Like BBC4 with which you had problems
below...


> $ tzap -r "BBC FOUR"
> tuning to 562000000 Hz
> video pid 0x0000, audio pid 0x0000
              ^^^^              ^^^^
This is wrong -- at least after 19h your-time -- but in case
you did the scan before 19h your-time, you may have gotten
correct PIDs for CBBC+CBeebies -- but not for BBC3+4, as the
correct PIDs are only broadcast during the time those programs
are actually on-air, and `tzap' is not smart enough to take
the Service ID and derive the up-to-date PIDs from that...

So, basically, if you could post what you have for Mux B at
562MHz (ch32), then we can see if you did get correct data
for the radios and the then-active TV services.

Also you said the ITV Mux 2 caused problems in your initial
scan, so if you have problems `tzap'ing those channels, then
posting that data would be useful.


thanks
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
