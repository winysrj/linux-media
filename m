Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LATC3-000300-Tp
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 18:49:52 +0100
Received: by ug-out-1314.google.com with SMTP id x30so150013ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 10 Dec 2008 09:49:48 -0800 (PST)
Date: Wed, 10 Dec 2008 18:49:38 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Jordi Moles Blanco <jordi@cdmon.com>
In-Reply-To: <493FFD3A.80209@cdmon.com>
Message-ID: <alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>
References: <493FFD3A.80209@cdmon.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working through
 diseqc anymore
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

On Wed, 10 Dec 2008, Jordi Moles Blanco wrote:

> here's what i got from scanning........
> 
> switch 1 (astra 28.2E)
> 
> ********
> scan -s 1 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E
> >>> tune to: 10729:v:1:22000
> 0x0000 0x206c: pmt_pid 0x0100 BSkyB -- E4+1 (running)

> 
> switch 2 (astra 19E)
> ********
> scan -s 2 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
> >>> tune to: 10788:v:2:22000
> 0x0000 0x283d: pmt_pid 0x0100 BSkyB -- BBC 1 W Mids (running)

You are correct, this is a transponder at 28E2 which
shares freq,pol+sr with 19E2...


> And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
> 3", it will always scan from "switch 1"

Try with -s 0; I'm not sure if it is always the case,
but my unhacked `scan' uses 0-3 for DiSEqC positions
1/4 to 4/4 -- I've hacked this to use the range of 1-4
on all my `scan' and related tuning/streaming utilities.


Personally, I prefer `0' to mean no DiSEqC at all, A/B
as appropriate, and 1-4 to match all consumer equipment
I've got my hands on (or A-D), but that's me...


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
