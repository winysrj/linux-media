Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K4MRk-0008RL-DX
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 22:52:33 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 5 Jun 2008 22:52:00 +0200
References: <1212610778l.7239l.1l@manu-laptop>
	<200806052047.30008.ajurik@quick.cz>
	<1212695886l.9365l.0l@manu-laptop>
In-Reply-To: <1212695886l.9365l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806052252.00842.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : No lock on a particular transponder with TT
	S2-3200
Reply-To: ajurik@quick.cz
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

On Thursday 05 of June 2008, manu wrote:
> Well so this would point to a problem involving FEC. But is that a
> problem to get a lock? I mean FEC is just involved after a successful
> tuning, right? So even tuning is a problem IMHO and FEC might be
> another one.
> I hope that someone else can elaborate/confirm or not.
> Bye
> Manu

Well, I've tried to confirm wheather or not some values of FEC disables the 
successful lock. I've found transponder in DVB-S2 which is receivable 
immediately after tuning to with the same FEC (3/4). But I've found that all 
transponders on which I'm not able to get lock have FEC eq to 2/3 or 3/4 and 
modulation of type 8PSK. Transponders with FEC 3/4 and modulation QPSK are 
receivable without problem.

I'll be very glad if someone else could confirm or disagree with my tests as I 
didn't do test tuning on all DVB-S2 channels. 

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
