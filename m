Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1Kryy7-0000a8-En
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 19:55:05 +0200
Received: from [192.168.178.120] (p508101BD.dip0.t-ipconnect.de [80.129.1.189])
	by dd16712.kasserver.com (Postfix) with ESMTP id 9CEE41805C4B6
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 19:55:02 +0200 (CEST)
Message-ID: <48FCC5FB.1030706@helmutauer.de>
Date: Mon, 20 Oct 2008 19:55:07 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48F9969D.90305@helmutauer.de>
In-Reply-To: <48F9969D.90305@helmutauer.de>
Subject: Re: [linux-dvb] Problems with conexant CX24123/CX24109
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

Helmut Auer schrieb:
> Hi,
>
> I have a Geniatech PCI DVB-s with CX24123/CX24109.
> This card cannot zap to the german ARD transponder, all other channels 
> are running fine.
> The card runs fine under windows .
> dmesg shows at loading:
>
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [LNKC] -> GSI 10 (level, 
> low) -> IRQ 10
> cx88[0]: subsystem: 14f1:0084, board: Geniatech DVB-S [card=52,autodetected]
> cx88[0]: TV tuner type 4, Radio tuner type -1
> cx88[0]/0: found at 0000:01:09.0, rev: 5, irq: 10, latency: 165, mmio: 
> 0xfc000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> cx88[0]/2: cx2388x 8802 Driver Manager
> ACPI: PCI Interrupt 0000:01:09.2[A] -> Link [LNKC] -> GSI 10 (level, 
> low) -> IRQ 10
> cx88[0]/2: found at 0000:01:09.2, rev: 5, irq: 10, latency: 64, mmio: 
> 0xfd000000
> cx88/2: cx2388x dvb driver version 0.0.6 loaded
> cx88/2: registering cx8802 driver, type: dvb access: shared
> cx88[0]/2: subsystem: 14f1:0084, board: Geniatech DVB-S [card=52]
> cx88[0]/2: cx2388x based DVB/ATSC card
> CX24123: detected CX24123
> DVB: registering new adapter (cx88[0])
> DVB: registering frontend 0 (Conexant CX24123/CX24109)...
>
> and when the error occurs:
>
> cx88[0]: irq mpeg [0x100000] ts_err?*
> cx88[0]/2-mpeg: general errors: 0x00100000
>
> Any hints where I can tune some parameters ?
>
>   
No one an idea whats wrong with the driver ?


-- 
Helmut Auer, helmut@helmutauer.de 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
