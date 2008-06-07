Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from s12.pixelx.de ([80.86.184.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <info@nando-hiller.de>) id 1K55UJ-0007ta-JL
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 22:58:14 +0200
Received: from vdr01 (p5B276D7C.dip.t-dialin.net [91.39.109.124])
	(authenticated (0 bits))
	by s12.pixelx.de (8.13.1/8.11.6) with ESMTP id m57Kw7a5023198
	(using TLSv1/SSLv3 with cipher RC4-SHA (128 bits) verified NO)
	for <linux-dvb@linuxtv.org>; Sat, 7 Jun 2008 22:58:08 +0200
From: Nando Hiller <info@nando-hiller.de>
To: linux-dvb@linuxtv.org
Date: Sat, 7 Jun 2008 22:58:05 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806072258.05914.info@nando-hiller.de>
Subject: [linux-dvb] Technisat DVB-C - "b2c2-flexcop: no frontend driver
	found for this"
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

Hi,
since changeset 7469 the frontend driver of my technisat can't be loaded.
Have someone a solution of this problem?

test:
hg clone http://linuxtv.org/hg/v4l-dvb
hg update 7469 
make && make install
modprobe b2c2-flexcop-pci 

tail -f /log/messages
...
Jun  7 22:43:15 [kernel] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV 
receiver chip loaded successfully
Jun  7 22:43:15 [kernel] flexcop-pci: will use the HW PID filter.
Jun  7 22:43:15 [kernel] flexcop-pci: card revision 2
Jun  7 22:43:15 [kernel] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNK2] -> 
GSI 5 (level, low) -> IRQ 5
Jun  7 22:43:15 [kernel] DVB: registering new adapter (FlexCop Digital TV 
device)
Jun  7 22:43:15 [kernel] b2c2-flexcop: MAC address = 00:d0:d7:08:0d:7f
Jun  7 22:43:15 [kernel] b2c2-flexcop: i2c master_xfer failed
                - Last output repeated 2 times -
Jun  7 22:43:16 [kernel] mt352_read_register: readreg error (reg=127, 
ret==-121)
Jun  7 22:43:16 [kernel] b2c2-flexcop: i2c master_xfer failed
Jun  7 22:43:16 [kernel] nxt200x: nxt200x_readbytes: i2c read error (addr 
0x0a, err == -121)
Jun  7 22:43:16 [kernel] Unknown/Unsupported NXT chip: 00 00 00 00 00
Jun  7 22:43:16 [kernel] b2c2-flexcop: i2c master_xfer failed
Jun  7 22:43:16 [kernel] lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02 
error (ret == -121)
Jun  7 22:43:16 [kernel] b2c2-flexcop: i2c master_xfer failed
                - Last output repeated twice -
Jun  7 22:43:16 [kernel] stv0297_readreg: readreg error (reg == 0x80, ret 
== -121)
Jun  7 22:43:16 [kernel] b2c2-flexcop: i2c master_xfer failed
Jun  7 22:43:16 [kernel] mt312_read: ret == -121
Jun  7 22:43:16 [kernel] b2c2-flexcop: no frontend driver found for this 
B2C2/FlexCop adapter
...

bye,
Nando

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
