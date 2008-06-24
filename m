Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from olammi.iki.fi ([217.112.242.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <olammi@olammi.iki.fi>) id 1KB9Pz-00008C-Cf
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 16:22:48 +0200
Date: Tue, 24 Jun 2008 17:22:42 +0300 (EEST)
From: Olli Lammi <olammi@olammi.iki.fi>
To: Robert Schedel <r.schedel@yahoo.de>
In-Reply-To: <484EB8BC.5060604@yahoo.de>
Message-ID: <Pine.LNX.4.64.0806241719090.16776@zil.olammi.iki.fi>
References: <Pine.LNX.4.64.0806101259050.6742@zil.olammi.iki.fi>
	<484EB8BC.5060604@yahoo.de>
MIME-Version: 1.0
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

On Tue, 10 Jun 2008, Robert Schedel wrote:

> Olli Lammi wrote:
>> Hello!
>> ------
>> 
>> I recently moved to area where only DVB-T is available and changed my
>> DVB-C-cards to two Terratec Cinergy 1200 DVB-T cards. However adding
>> one card lifted the load of my server to approx 0.8 and adding the
>> second card to approx 1.6. No processes are consuming the processor time so 
>> I think the high load is due to dvb driver or kernel.
>
> Please see: <http://bugzilla.kernel.org/show_bug.cgi?id=10459>
>
>> Is this a known problem and is there a workaround available?. I tried to 
>> search the net for answers but found none.
>
> The last email for this was just three days ago, titled "[linux-dvb] 
> budget_av,  high cpuload with kncone tvstar".


Hello again!

I have now first tried the saa7146_sleep-patch as the thread above 
suggests adapted to the 2.6.22.14-72.fc6-kernel. There was no change in 
the load.

Today I upgraded the entire server kernel to kernel.org 2.6.28.5-version 
and applied the Oliver Endriss saa7147_sleep-patch to it. Still my two 
Terratec cards produce approx 1.5 load when system is about idle.

Any suggestions how to debug or try to solve the problem?

Olli Lammi

--------------------------------------------------------------------------
Olli Lammi                    olammi@iki.fi                   040 580 7666
--------------------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
