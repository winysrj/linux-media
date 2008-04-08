Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n22.bullet.mail.ukl.yahoo.com ([87.248.110.139])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1Jj8Fi-0007fI-2z
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 09:28:24 +0200
Message-ID: <47FB1E3B.2000307@yahoo.de>
Date: Tue, 08 Apr 2008 09:26:51 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F9E95D.6070705@yahoo.de>
In-Reply-To: <47F9E95D.6070705@yahoo.de>
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
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

Hello all,

meanwhile I also found old threads from August 2007 and earlier, named 
"System load raises when budget_av is loaded" and "System load raises 
when budget_av is loaded", which describe exactly the same issue. 
However, both were written before the latest code changes.

The latest debi_done code change from November 2007 does not use any 
DEBI_E checks anymore. To my understanding this SAA7146 event indicates 
  DEBI errors like timeout via PCI and should be received by the driver 
  much earlier than those 250ms (=end of cycle). Seems like I have to 
play around with this myself.

Time for a bugzilla ticket?

Regards,
Robert Schedel




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
