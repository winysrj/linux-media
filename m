Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JWGkx-00033h-MI
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 20:55:28 +0100
Message-ID: <47CC57A9.3060403@gmail.com>
Date: Mon, 03 Mar 2008 23:55:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: David BERCOT <david.bercot@wanadoo.fr>
References: <20080303145054.1ecda583@wanadoo.fr>
In-Reply-To: <20080303145054.1ecda583@wanadoo.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Is my CI broken ?
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

David BERCOT wrote:
> Hi,
> 
> Before buying a new CI for my TT S2-3200, I'd like to know if it is
> really broken...
> 
> After the installation of multiproto, I have this error :
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
> saa7146: found saa7146 @ mem ffffc20001046c00 (revision 1, irq 22) (0x13c2,0x1019).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:0b:a5:8b
> input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> dvb_ca_en50221_init
> budget_ci: CI interface initialised
> CAMCHANGE IRQ slot:0 change_type:1
> dvb_ca_en50221_thread_wakeup
> dvb_ca_en50221_thread
> ...stb0899...
> stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100
> DVB: registering frontend 0 (STB0899 Multistandard)...
> dvb_ca adaptor 0: PC card did not respond :(
> 
> Do you think I have to change my CI or is it an installation error ?

Just check whether it is the cable before going in for a new daughterboard.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
