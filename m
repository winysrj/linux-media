Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1LVnsv-0003Ez-W6
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 15:10:18 +0100
Date: Sat, 7 Feb 2009 15:04:51 +0100
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090207140451.GC19668@raven.wolf.lan>
References: <20090207015744.GA19668@raven.wolf.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090207015744.GA19668@raven.wolf.lan>
Subject: Re: [linux-dvb] Tuning problems with loss of TS packets
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

On Sat, Feb 07, 2009 at 02:57:44AM +0100, Josef Wolf wrote:
> Hello,
> 
> sometimes, I experience non-deterministic problems with tuning on some
> transponders with dvb-s.  For example, on astra-H-11954, I have about
> 50% chance to get a good tune.  If I get a bad tune, I still receive
> TS packets from the chosen transponder, but about 10%..20% of the
> packets are lost.  The (remaining) packets contain PAT/PMT/PES packets
> from the chosen transponder, so it is pretty safe to assume that
> actual tuning worked properly.

I have tried to analyze the cc (continuation counter) field of the TS
packets to get more clue. This is what I found on the astra-H-11954 (zdf)
transponder:

When I get a "bad" tune (that is: mplayer and vlc get stuck), the
cc errors are unsystematic.  All PIDs are affected, and the amount
of lost packets varies.  But from time to time regularities can be
seen:

     cc pid:967 expect:3  got:5   *
     cc pid:970 expect:3  got:5   *
     cc pid:966 expect:3  got:5   *
     cc pid:18  expect:10 got:11
     cc pid:969 expect:5  got:6
     cc pid:131 expect:10 got:9
     cc pid:710 expect:7  got:11
     cc pid:967 expect:13 got:15   *
     cc pid:970 expect:13 got:15   *
     cc pid:966 expect:13 got:15   *
     cc pid:968 expect:11 got:13
     cc pid:230 expect:12 got:15
     cc pid:330 expect:5  got:8
     cc pid:620 expect:1  got:5
     cc pid:130 expect:5  got:9   +
     cc pid:630 expect:5  got:9   +
     cc pid:220 expect:6  got:10
     cc pid:120 expect:14 got:2
     cc pid:968 expect:4  got:6
     cc pid:967 expect:7  got:9   *
     cc pid:970 expect:7  got:9   *
     cc pid:966 expect:7  got:9   *

I have marked the interesting lines.  Most interesting are the lines
marked with stars.  This is the same sequence of PIDs in the same
order and with the same amount of lost packets.  This does not look
like a coincidence to me.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
