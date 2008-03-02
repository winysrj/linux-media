Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVwvr-0000P2-0E
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:45:23 +0100
Message-ID: <47CB2DF6.9070703@gmail.com>
Date: Mon, 03 Mar 2008 02:45:10 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: e9hack <e9hack@googlemail.com>
References: <BAY118-W56E0462131FD39ABADE685BF150@phx.gbl>
	<47C95DAC.1020301@gmail.com>
In-Reply-To: <47C95DAC.1020301@gmail.com>
Cc: linux-dvb@linuxtv.org
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

e9hack wrote:
> Rikard Wissing schrieb:
> 
>> [ 4022.656841] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>> [ 4022.658236] TDA10021: i2c-addr = 0x0c, id = 0x7d
>> [ 4022.658238] mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10021) @ 0x0c
>> [ 4022.658240] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
>> [ 4022.658243] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
> 
> The chip ID is 0x7d. Probably, your card uses a CU1216-3 with a TDA10023. There are 
> differences between the TDA10021 and the TDA10023.

Yep, it is. The 10021 based tuners are out of stock at least.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
