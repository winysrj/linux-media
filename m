Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from angel.comcen.com.au ([203.23.236.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rock_on_the_web@comcen.com.au>) id 1Lcy8x-0004du-At
	for linux-dvb@linuxtv.org; Fri, 27 Feb 2009 09:32:30 +0100
Received: from [192.168.0.192] (unknown [202.172.126.254])
	by angel.comcen.com.au (Postfix) with ESMTP id 993F45C2EC19
	for <linux-dvb@linuxtv.org>; Fri, 27 Feb 2009 19:33:43 +1100 (EST)
From: Da Rock <rock_on_the_web@comcen.com.au>
To: linux-dvb@linuxtv.org
Date: Fri, 27 Feb 2009 18:32:11 +1000
Message-Id: <1235723531.47624.52.camel@laptop1.herveybayaustralia.com.au>
Mime-Version: 1.0
Subject: [linux-dvb] dvb, tzap + output, and signal strength
Reply-To: linux-media@vger.kernel.org
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

I have to ask, I feel like I'm losing the plot here somehow. I have had
trouble with a particular channel in Aust (7 Digital) where the signal
was completely unwatchable and xine would give up and switch channels
(max settings to prevent this in place). SO I bought an amp for the
signal.

I checked the tzap output to come to this conclusion:

Freq 1 (226500000): sig=da00> snr=0 ber=0 unc=0
Freq 2 (177500000): sig=ba00> snr=0 ber=3260> unc=0>
Freq 3 (191625000): sig=cf00> snr=0 ber=0 unc=0
Freq 4 (219500000): sig=ffff snr=0 ber=0 unc=0
Freq 5 (585625000): sig=ffff snr=0 ber=0 unc=0

My setup is 2 Dvico dual 4 dvb tuners, and a leadtek 2000H hybrid tuner,
totalling 5 tuners in the system. The idea is to have a tuner for each
frequency and stream each channel provided. I also share the antenna
with a split residence, with a masthead amp and my lead is around 10m+
long which I cabled myself (I have a cabling licence).

Based on these outputs I figured an amp for the lower frequencies was in
order. Once I put it in though, several things happened:

1. Signal strengths increased as planned (for eg. increase from bxxx to
cxxx), but so did the ber and unc.
2. Channels which worked fine before suddenly refused to (1 and 3).
3. The second frequency- the one which started this whole fiasco-
stopped working at all.
4. Some tuners failed to work (they were working previously)- errors
were that while signals were registered, fe was not locking. Status was
<1.

Perhaps I'm missing something? I'm not completely au fait with radio
physics, but I have used amps in the past to resolve signal problems
with success- I seem to have no idea here though.

Any ideas here as to what I'm missing/can do?


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
