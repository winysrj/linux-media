Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1JVS0l-0003OQ-2A
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 14:44:23 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3212512fge.25
	for <linux-dvb@linuxtv.org>; Sat, 01 Mar 2008 05:44:19 -0800 (PST)
Message-ID: <47C95DAC.1020301@gmail.com>
Date: Sat, 01 Mar 2008 14:44:12 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <BAY118-W56E0462131FD39ABADE685BF150@phx.gbl>
In-Reply-To: <BAY118-W56E0462131FD39ABADE685BF150@phx.gbl>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Tuning fails with Twinhan DVB-C AD-CP300 (Mantis
 2033)
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

Rikard Wissing schrieb:

> [ 4022.656841] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
> [ 4022.658236] TDA10021: i2c-addr = 0x0c, id = 0x7d
> [ 4022.658238] mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10021) @ 0x0c
> [ 4022.658240] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
> [ 4022.658243] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...

The chip ID is 0x7d. Probably, your card uses a CU1216-3 with a TDA10023. There are 
differences between the TDA10021 and the TDA10023.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
