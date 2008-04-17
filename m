Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n9a.bullet.ukl.yahoo.com ([217.146.183.157])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1JmXya-0003MZ-DN
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 19:32:49 +0200
Message-ID: <48076C7A.7070901@yahoo.de>
Date: Thu, 17 Apr 2008 17:27:54 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F9E95D.6070705@yahoo.de>
	<200804120100.14568@orion.escape-edv.de>
	<48066F62.8000709@yahoo.de>
In-Reply-To: <48066F62.8000709@yahoo.de>
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

Robert Schedel wrote:

> Is the 250ms timeout an approved limit? Decreasing it would push the
> load further down. Probably it still has to cover slow CAMs as well as a
> stressed PCI bus. Unfortunately, without CAM/CI I cannot make any
> statements myself.

Just got another idea to improve the code: Function 
"saa7146_wait_for_debi_done_sleep" could be reworked to use what is 
known as "truncated binary exponential backoff" algorithm. IOW, on each 
sleep duplicate the period from 1ms until a fixed maximum, e.g. 32ms. 
This way polling ends fast for those users with fast bus/CAM, and those 
requiring 200ms due to slow bus/CAM should not worry about e.g. 216ms 
response time.

My first tests look promising (load goes down to 0). However, is not the 
simple BEB algorithm already patented?

Regards,
Robert


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
