Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n42.bullet.mail.ukl.yahoo.com ([87.248.110.175])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1K67aT-0003xM-Tk
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 19:24:50 +0200
Message-ID: <484EB8BC.5060604@yahoo.de>
Date: Tue, 10 Jun 2008 19:24:12 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: Olli Lammi <olammi@olammi.iki.fi>
References: <Pine.LNX.4.64.0806101259050.6742@zil.olammi.iki.fi>
In-Reply-To: <Pine.LNX.4.64.0806101259050.6742@zil.olammi.iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] High load with Terratec Cinergy 1200 DVB-T
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

Olli Lammi wrote:
> Hello!
> ------
> 
> I recently moved to area where only DVB-T is available and changed my
> DVB-C-cards to two Terratec Cinergy 1200 DVB-T cards. However adding
> one card lifted the load of my server to approx 0.8 and adding the
> second card to approx 1.6. No processes are consuming the processor time so I 
> think the high load is due to dvb driver or kernel.

Please see: <http://bugzilla.kernel.org/show_bug.cgi?id=10459>

> Is this a known problem and is there a workaround available?. I tried to search 
> the net for answers but found none.

The last email for this was just three days ago, titled "[linux-dvb] 
budget_av,  high cpuload with kncone tvstar".

Regards,
Robert


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
