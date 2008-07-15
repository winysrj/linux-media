Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KIeHq-0004He-7d
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 08:45:23 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id 1F8B319E66C6
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 10:44:48 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id CC46C19E65AF
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 10:44:47 +0400 (MSD)
Date: Tue, 15 Jul 2008 10:51:47 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080715105147.7b661467@bk.ru>
In-Reply-To: <1216091871.5048.11.camel@pc10.localdom.local>
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
	<1216091871.5048.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Express AM2 11044 H 45 MSps
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

Hi

I have the same problem as Vladimir. I have the hvr4000 and tt2300 SS1 cards and I couldn't lock this package with
extremely high SR . My dreambox 7000 can lock this package without any problem. 

> > I have recently realized that none of the available cards are able to  
> > properly lock on Express AM2 11044H 45 MSps . The only one that can is  
> > TT-S1401 with buf[5] register corrections.
> > 
> > I have tried:
> > 
> > TT S-1500
> > TT S2-3200
> > Skystar 2.6
> > TT S-1401 with non-modified drivers.
> > 
> > Regards,
> > Vladimir
> > 
> 
> do you mean that, what Hartmut, Manu and Oliver worked out for it for
> dynamic bandwidth cutoff adjustment, 

sorry, what do you mean ? 

Goga

>which is in mercurial v4l-dvb, or
> do you still try something different with better results?
> 
> Can you make that clear please?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
