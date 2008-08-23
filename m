Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KWyq0-000523-77
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 21:31:53 +0200
Message-ID: <48B065A1.2040007@kolumbus.fi>
Date: Sat, 23 Aug 2008 22:31:45 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: sacha <sacha@hemmail.se>
References: <1219483098.6740.2.camel@lanbox>
In-Reply-To: <1219483098.6740.2.camel@lanbox>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Error loading mantis.
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


Maybe you could try:

make clean
make distclean
make all
make install

reboot.

If your distribution installs a new kernel version,
make distclean should be done to clean up dependencies
to the previous kernel version.


Regards,
Marko Ristola

sacha kirjoitti:
> Hello
>
> Can anyone help me to understand the cause of the error below:
>
> [   57.631053] mantis: disagrees about version of symbol
> dvb_unregister_frontend
> [   57.631054] mantis: Unknown symbol dvb_unregister_frontend
> [   57.631168] mantis: disagrees about version of symbol
> dvb_register_frontend
> [   57.631169] mantis: Unknown symbol dvb_register_frontend
>
> KR
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
