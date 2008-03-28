Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.elion.ee ([88.196.160.58] helo=mail1.elion.ee)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kasjas@hot.ee>) id 1JfC6K-0005s8-4e
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 11:46:25 +0100
Message-ID: <47ECCC5D.6080100@hot.ee>
Date: Fri, 28 Mar 2008 12:45:49 +0200
From: Arthur Konovalov <kasjas@hot.ee>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200803212024.17198.christophpfister@gmail.com>
In-Reply-To: <200803212024.17198.christophpfister@gmail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Christoph Pfister wrote:
> Hi,
> 
> Can somebody please pick up those patches (descriptions inlined)?
> 
> Thanks,
> 
> Christoph

Hi!
I tried those patches, but got no picture and audio with my Terratec Cinergy 
1200 DVB-C and TechniCAM CX Conax CAM (either FTA or scrambled).

After modules loading dmesg output (I have 2 cards: DVB-T and DVB-C):

b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
flexcop-pci: will use the HW PID filter.
flexcop-pci: card revision 2
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 17 (level, low) -> IRQ 20
DVB: registering new adapter (FlexCop Digital TV device)
b2c2-flexcop: MAC address = 00:d0:d7:09:e0:87
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: found the mt352 at i2c address: 0x0f
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
b2c2-flexcop: initialization of 'Air2PC/AirStar 2 DVB-T' at the 'PCI' bus 
controlled by a 'FlexCopIIb' complete
Linux video capture interface: v2.00
saa7146: register extension 'budget_av'.
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem e0f26000 (revision 1, irq 22) (0x153b,0x1156).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-C)
adapter failed MAC signature check
encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-1: MAC addr = 00:0a:ac:11:00:21
TDA10021: i2c-addr = 0x0c, id = 0x7c
DVB: registering frontend 1 (Philips TDA10021 DVB-C)...
budget-av: ci interface initialised.
budget-av: cam inserted A


Now, when trying to run vdr it seems like loop in budget-av module:

budget-av: cam inserted A
DVB: TDA10021(1): _tda10021_writereg, writereg error (reg == 0x00, val == 0x73, 
ret == -121)
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully
budget-av: cam inserted A
dvb_ca adapter 1: DVB CAM detected and initialised successfully


Corresponding log file:

Mar 28 12:15:36 vdr kernel: budget-av: cam inserted A
Mar 28 12:16:09 vdr last message repeated 9 times

Any idea to fix this?
Please...



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
