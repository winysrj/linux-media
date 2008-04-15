Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JliYN-0001Jd-FI
	for linux-dvb@linuxtv.org; Tue, 15 Apr 2008 12:38:20 +0200
Message-ID: <48048592.70408@shikadi.net>
Date: Tue, 15 Apr 2008 20:38:10 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: sonofzev@iinet.net.au
References: <37824.1208252766@iinet.net.au>
In-Reply-To: <37824.1208252766@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing to
 help	test e.t.c...
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

> I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as a 
> result of misreading some other posts and sites. I was under the 
> impression that it would work either from the current kernel source or 
> using Chris Pascoe's modules.  Unfortunately I didn't realise that the 
> American and Euro/Australian version were different.

What are the PCI IDs for the card?  I'm not sure what criteria the 
driver uses to detect DVB vs ATSC, but I would guess you could tweak the 
PCI IDs to make the driver detect your card as one of the others that 
supports DVB and has the same cx23885 chipset.

Cheers,
Adam.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
