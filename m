Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glenn.l.mcgrath@gmail.com>) id 1KkeDJ-0001U7-Nx
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 14:20:26 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1357747tib.13
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 05:20:19 -0700 (PDT)
Message-ID: <141058d50809300520s2a959e06xd48dca4822f8d62d@mail.gmail.com>
Date: Tue, 30 Sep 2008 22:20:19 +1000
From: "Glenn McGrath" <glenn.l.mcgrath@gmail.com>
To: "Alex Ferrara" <alex@receptiveit.com.au>
In-Reply-To: <03391629-289E-4635-B6D6-2E72E1C8206A@receptiveit.com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080921104125.3218916429C@ws1-4.us4.outblaze.com>
	<6894A2D0-2EC8-4C49-8D63-FA66CCA16E01@receptiveit.com.au>
	<03391629-289E-4635-B6D6-2E72E1C8206A@receptiveit.com.au>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Dvico dual digital express - Poor tuner
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

How did you generate your channels.conf ?

Ive started working on a new app called utuner
(http://gna.org/projects/utuner) it attempts to generate the initial
tuning data that is input to scan, similar to w_scan.

If you want to give it a try id appreciate some feedback, its only a
few weeks old and i dont think anyone except me has tried it.

It uses a frequency table to isolate what frequency bands to test, it
works by looking for the shoulders of firstly the carrier and then the
lock band.

Example of usage is

dtv-scan -t <some path>/channels/Australia.center generated-initial-tuning-data

If you dont have a frequency table it will scan the entire spectrum
that the card can go to, it uses a step of 500kHz to detect a carrier
and a card might have a range of 500MHz, so it means it has to take
about 2500 samples this way, currently it takes multiple samples, one
every 500ms or so and or's them to overcome inconsistent signals. This
means it can take 2 hours to do a complete scan, this is a long time,
but its faster than the week it took me to work it out... and it can
be greatly reduced by having a frequency table of authorized broadcast
bands (such as i have done for australia) for different
regions/countries.

There are a few other utilities that i have used for testing my card
in there as well.



Glenn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
