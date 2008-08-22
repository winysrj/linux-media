Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.koalatelecom.com.au ([202.126.101.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1KWSrC-0000Xy-1h
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 11:22:58 +0200
From: "Peter D." <peter_s_d@fastmail.com.au>
To: Matthias Dahl <mldvb@mortal-soul.de>
Date: Fri, 22 Aug 2008 19:22:45 +1000
References: <200808121443.27020.mldvb@mortal-soul.de>
	<200808221656.53605.peter_s_d@fastmail.com.au>
	<200808220930.39630.mldvb@mortal-soul.de>
In-Reply-To: <200808220930.39630.mldvb@mortal-soul.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808221922.46056.peter_s_d@fastmail.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Possible SMP problems with budget_av/saa7134
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

On Friday 22 August 2008, Matthias Dahl wrote:
> Hello Peter.
>
> On Friday 22 August 2008 08:56:53 Peter D. wrote:
> > That machine now has a vanilla 2.6.26.3 kernel and the
> > "nosmp" flag.  It has been up for two hours now.  If you
> > don't solve this in the next month, I'll post a follow-up.  ;-)
>
> I am sorry to disappoint you but I guess we are talking about different
> problems here. This thread is mainly about problems with concurrent
> access to a ci/cam attached to a budget card. And since you are using
> dvb-t which afaik is always fta, you are experiencing a totally different
> problem. Besides my machine never locked up, the cam just stopped
> decrypting. Otherwise it would really have been quite strange to explain.
> :-)

I was already disappointed in the motherboard.  :-(  

> Have you run some tests on the machine like a memtest and/or processor
> test? 

Overnight runs of memtest have not found a fault with either mem stick.  
Problems have occurred with each stick being the sole stick, and with 
two different processors, both were X2 3600+ AMDs.  I doubt that both 
cpus have the same problem.  sys_basher did not find any faults.  
Do you recommend anything in particular - like cpuburn?

> Faulty memory can causes all sorts of strange problems. If you 
> still suspect the dvb subsystem, compile a kernel without it, test and
> stress it. If it works reliably for a longer period of time, you've
> possibly narrowed the list of suspects down. But I bet it's more like a
> hardware problem... sorry.
>
> So long,
> matthias.

I think that it is a motherboard problem, but I will let it run with 
nosmp for a while and see what happens.  


-- 
sig goes here...
Peter D.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
