Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [88.151.248.2] (helo=mail.krastelcom.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1KIeRG-00058v-Jq
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 08:55:08 +0200
Message-Id: <609E03B1-0E1A-4FB9-BC5D-B9777BDE2A1C@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080715105147.7b661467@bk.ru>
Mime-Version: 1.0 (Apple Message framework v926)
Date: Tue, 15 Jul 2008 10:55:02 +0400
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
	<1216091871.5048.11.camel@pc10.localdom.local>
	<20080715105147.7b661467@bk.ru>
Cc: linux-dvb@linuxtv.org
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

To be honest, TT S-1500 is able to lock on both transponders with no  
problems if signal quality is extremely good. But not the rest.

P.S. to ibz@ibz.ru I can't answer to your e-mail because your server  
does not accept it from me.

Regards,
Vladimir

On Jul 15, 2008, at 10:51 AM, Goga777 wrote:

> Hi
>
> I have the same problem as Vladimir. I have the hvr4000 and tt2300  
> SS1 cards and I couldn't lock this package with
> extremely high SR . My dreambox 7000 can lock this package without  
> any problem.
>
>>> I have recently realized that none of the available cards are able  
>>> to
>>> properly lock on Express AM2 11044H 45 MSps . The only one that  
>>> can is
>>> TT-S1401 with buf[5] register corrections.
>>>
>>> I have tried:
>>>
>>> TT S-1500
>>> TT S2-3200
>>> Skystar 2.6
>>> TT S-1401 with non-modified drivers.
>>>
>>> Regards,
>>> Vladimir
>>>
>>
>> do you mean that, what Hartmut, Manu and Oliver worked out for it for
>> dynamic bandwidth cutoff adjustment,
>
> sorry, what do you mean ?
>
> Goga
>
>> which is in mercurial v4l-dvb, or
>> do you still try something different with better results?
>>
>> Can you make that clear please?
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
