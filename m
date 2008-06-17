Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K8iFW-0005dt-UG
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 22:57:59 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 17 Jun 2008 22:56:35 +0200
References: <485646D3.6040201@magic.fr> <48566EE7.5030101@magic.fr>
	<48569D96.5050209@magic.fr>
In-Reply-To: <48569D96.5050209@magic.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806172256.35351@orion.escape-edv.de>
Subject: Re: [linux-dvb] SkyStar 2 - rev 2.8A
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

Alexandre Conrad wrote:
> In the worst of the cases, I'll have to return the cards to my vendor as 
> TechniSat might just no longer make 2.6 cards anymore. Then what would 
> be the recommanded alternative hardware that could work for me? A few 
> years back, I've was using a budget Hauppauge Nova-S card. But it might 
> be outdated and/or hard to find in large quantities these days.
>
> Any recommendation for cards that would be well supported by the kernel 
> and are still "comfortably" available? We're doing DVB-IP stuff (no TV 
> watching).

There are tons of well-supported cards. ;-)

For example: http://www.technotrend.com/2762/PRODUCTS_for_PC.html
- Budget DVB-S 1401 (w/o CI connector) --> driver: budget
- Budget DVB-S 1500 (with CI connector) --> driver: budget-ci
(There is also an experimental driver for the DVB-S2 3200)

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
