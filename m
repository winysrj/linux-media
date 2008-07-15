Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KIb7G-0004Zc-9G
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 05:22:19 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Vladimir Prudnikov <vpr@krastelcom.ru>
In-Reply-To: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
Date: Tue, 15 Jul 2008 05:17:51 +0200
Message-Id: <1216091871.5048.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
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

Hi Vladimir,

Am Montag, den 23.06.2008, 09:53 +0400 schrieb Vladimir Prudnikov:
> Hi!
> 
> I have recently realized that none of the available cards are able to  
> properly lock on Express AM2 11044H 45 MSps . The only one that can is  
> TT-S1401 with buf[5] register corrections.
> 
> I have tried:
> 
> TT S-1500
> TT S2-3200
> Skystar 2.6
> TT S-1401 with non-modified drivers.
> 
> Regards,
> Vladimir
> 

do you mean that, what Hartmut, Manu and Oliver worked out for it for
dynamic bandwidth cutoff adjustment, which is in mercurial v4l-dvb, or
do you still try something different with better results?

Can you make that clear please?

Thanks,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
