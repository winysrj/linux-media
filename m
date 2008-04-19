Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n40.bullet.mail.ukl.yahoo.com ([87.248.110.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JnMBI-00019e-FV
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 01:09:18 +0200
Date: Sat, 19 Apr 2008 13:50:55 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <1207866617l.6780l.0l@manu-laptop>
	<1207967191l.6061l.0l@manu-laptop>
In-Reply-To: <1207967191l.6061l.0l@manu-laptop> (from eallaud@yahoo.fr on
	Fri Apr 11 22:26:31 2008)
Message-Id: <1208627455l.18445l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: [linux-dvb] [SOLVED] TT-3200 (DVB-S/S2) bad reception/no lock issue
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

On 04/11/2008 10:26:31 PM, manu wrote:
> On 04/10/2008 06:30:17 PM, manu wrote:
> > 	Hi all,
> > I already reported on that sooner, but now I have a log (with
> stb0899 
> > verbose=5) so I hope it makes it a bit easier to debug.
> > Still the same behaviour: one transponder (freq=11093 MHz) is 
> ALWAYS
> 
> > perfect (fast lock perfect picture even with bad weather) and for 3 
> > other transponders (11555 MHz as in the log, 11635 Mhz and 11675
> MHz) 
> > the lock is much less frequent and if it locks the picture is much 
> > worse even in not so cloudy weather. It is as if the card was much
> > more 
> > picky with the other 3 transponders. Is it normal to have such 
> > discrepancies on the same sat?
> > Sometimes just locking on the "good" transponder and then switching 
> > back to a bad one gives good results: good lock and better SNR and 
> > picture (seen in mythtv).
> > Anyway here is the log, I hope this is of some help.
> 

Finally someone gave me the good idea (thanks Dominik): I added 4MHz to 
the tuning frequency and now, AFAICT every transponder works great. I 
must also say that I have patched my multiproto tree with Dominik's 
patch, but I am not sure that it changes results by so much.
Anyway, things now look much better!
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
