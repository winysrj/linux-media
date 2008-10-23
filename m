Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n23.bullet.mail.ukl.yahoo.com ([87.248.110.140])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <btanastasov@yahoo.co.uk>) id 1KsyG7-0001GJ-1f
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 13:21:46 +0200
Message-ID: <49005E1C.3010104@yahoo.co.uk>
Date: Thu, 23 Oct 2008 14:21:00 +0300
From: Boyan <btanastasov@yahoo.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [REGRESSION] - Cable2PC/CableStar 2 DVB-C not detected
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


Hello,

There is a regression regarding this DVB-C card from the subject, which 
as it looks is not very new, but nobody noticed the problem.
After bisecting I've found the commit which is responsible for this 
problem - that the card is not detected.
By the way mercurial bisect was not very useful because some commits 
does not compile or load, so I had to "simulate" bisecting.

Bad version:

changeset:   7484:0b82bb67fb80
parent:      7482:4fcb2ce44347
parent:      7483:13244661a8df
user:        Mauro Carvalho Chehab <mchehab@infradead.org>
date:        Tue Apr 01 18:59:34 2008 -0300
summary:     merge: http://linuxtv.org/hg/~mkrufky/tuner


b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded 
successfully
flexcop-pci: will use the HW PID filter.
flexcop-pci: card revision 2
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 22
DVB: registering new adapter (FlexCop Digital TV device)
b2c2-flexcop: MAC address = 00:d0:d7:13:c4:e4
b2c2-flexcop: i2c master_xfer failed
CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
CX24123: wrong demod revision: 87
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
mt352_read_register: readreg error (reg=127, ret==-121)
b2c2-flexcop: i2c master_xfer failed
nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -121)
Unknown/Unsupported NXT chip: 00 00 00 00 00
b2c2-flexcop: i2c master_xfer failed
lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02 error (ret == -121)
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
stv0297_readreg: readreg error (reg == 0x80, ret == -121)
b2c2-flexcop: i2c master_xfer failed
mt312_read: ret == -121
b2c2-flexcop: no frontend driver found for this B2C2/FlexCop adapter
ACPI: PCI interrupt for device 0000:06:00.0 disabled


Good version:

changeset:   7483:13244661a8df
parent:      7442:b7bb2b116cbb
user:        Michael Krufky <mkrufky@linuxtv.org>
date:        Sun Mar 30 13:00:45 2008 -0400
summary:     tuner-simple: fix broken build dependency


b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded 
successfully
flexcop-pci: will use the HW PID filter.
flexcop-pci: card revision 2
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 22
DVB: registering new adapter (FlexCop Digital TV device)
b2c2-flexcop: MAC address = 00:d0:d7:13:c4:e4
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: i2c master_xfer failed
mt352_read_register: readreg error (reg=127, ret==-121)
b2c2-flexcop: i2c master_xfer failed
nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -121)
Unknown/Unsupported NXT chip: 00 00 00 00 00
b2c2-flexcop: i2c master_xfer failed
lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02 error (ret == -121)
b2c2-flexcop: i2c master_xfer failed
b2c2-flexcop: found the stv0297 at i2c address: 0x1c
DVB: registering frontend 0 (ST STV0297 DVB-C)...
b2c2-flexcop: initialization of 'Cable2PC/CableStar 2 DVB-C' at the 
'PCI' bus controlled by a 'FlexCopIIb' complete


The changeset 7484:0b82bb67fb80 is rather big, but I'm just guessing 
that removing/integrating of this file with other flexcop files is the 
cause:

linux/drivers/media/dvb/b2c2/stv0297_cs2.c

Kernel version 2.6.23. Currently can't test with newer kernel on this 
computer.
I can give more info if needed.


Regards


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
