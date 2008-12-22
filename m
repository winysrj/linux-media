Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <thomas.creutz@gmx.de>) id 1LEl0d-0007OV-Ef
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 14:39:48 +0100
Message-ID: <494F987F.60707@gmx.de>
Date: Mon, 22 Dec 2008 14:39:11 +0100
From: Thomas Creutz <thomas.creutz@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49293640.10808@cadsoft.de>
	<492A53C4.5030509@makhutov.org>	<492A6E9B.7030906@cadsoft.de>
	<492AC460.1050203@makhutov.org>
In-Reply-To: <492AC460.1050203@makhutov.org>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

Artem Makhutov schrieb:
> I fully understand what you mean. I would also like to adress the
> remarks of Berry:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030539.html
> 
> Here we can define the frontend type and check if it is DVB-S or DVB-S2
> or whatever and also define the modulations that the frontend is capable
> to handle (in case a device won't work with the "professional"
> modulations like 16APSK).
> 
> Applications like VDR can check the fe_type flags, and applications that
> require more info could check fe_caps.
> 
> I am not sure about this all, and I would like to see some comments from
> some people that are more familiar it. Specially changing fe_type looks
> like it will break the binary compatibility, so maybe it would be better
> to define a new enum for this flags...
> 

I think, it can be a (or the) solution. Why nobody answered on this?
Have I not read something? Is a solution found?

Regards,
Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
