Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcDlX-0000kE-By
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 08:28:56 +0200
Message-ID: <48C3749F.10904@gmail.com>
Date: Sun, 07 Sep 2008 10:28:47 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: sacha <sacha@hemmail.se>
References: <1219183334.6734.3.camel@lanbox>
In-Reply-To: <1219183334.6734.3.camel@lanbox>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis loading errors.
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

sacha wrote:
> I have compiled latest Mantis driver on my 64-bit Ubuntu 8.04 and see
> this message from dmesg:
> [   90.229741] mantis: disagrees about version of symbol
> dvb_unregister_frontend
> [   90.229743] mantis: Unknown symbol dvb_unregister_frontend
> [   90.229858] mantis: disagrees about version of symbol
> dvb_register_frontend
> [   90.229860] mantis: Unknown symbol dvb_register_frontend
> 
> what does it mean?


You have loaded the same modules from within kernel also. You can unload
those modules manually and reload them, or simply do a reboot, to reload
the modules.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
