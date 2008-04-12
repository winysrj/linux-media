Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JkTLz-0000C3-K5
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 02:12:24 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 12 Apr 2008 02:11:26 +0200
References: <47F9E95D.6070705@yahoo.de> <47FB1E3B.2000307@yahoo.de>
In-Reply-To: <47FB1E3B.2000307@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804120211.27274@orion.escape-edv.de>
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
Reply-To: linux-dvb@linuxtv.org
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

Robert Schedel wrote:
> Hello all,
> 
> meanwhile I also found old threads from August 2007 and earlier, named 
> "System load raises when budget_av is loaded" and "System load raises 
> when budget_av is loaded", which describe exactly the same issue. 
> However, both were written before the latest code changes.
> 
> The latest debi_done code change from November 2007 does not use any 
> DEBI_E checks anymore. To my understanding this SAA7146 event indicates 
>   DEBI errors like timeout via PCI and should be received by the driver 
>   much earlier than those 250ms (=end of cycle). Seems like I have to 
> play around with this myself.

IIRC there was a problem with the DEBI_E flag but I don't remember what
it was exactly.

> Time for a bugzilla ticket?

You can do this if you prefer (but this will neither fix the bug nor
have any other positive effect).

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
