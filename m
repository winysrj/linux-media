Return-path: <linux-media-owner@vger.kernel.org>
Received: from dangerbird.closetothewind.net ([82.134.87.117]:57136 "EHLO
	dangerbird.closetothewind.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933536AbZLFACJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 19:02:09 -0500
Received: from [192.168.1.22] ([213.153.15.207])
	by dangerbird.closetothewind.net (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id nB602E6q006876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 6 Dec 2009 01:02:14 +0100
Message-ID: <4B1AF486.7080908@closetothewind.net>
Date: Sun, 06 Dec 2009 01:02:14 +0100
From: Jonas Kvinge <linuxtv@closetothewind.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Technisat SkyStar2 DVB card (rev 02)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Does this card require additional non-GPL binary driver?

According to the Wiki it does, whats the kernel to use with it? It does
not compile with 2.6.31

02:0c.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII
DVB chip / Technisat SkyStar2 DVB card (rev 02)

It does not load the frontend:


<6>[   13.055957] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
receiver chip loaded successfully
<6>[   13.099612] flexcop-pci: will use the HW PID filter.
<6>[   13.117656] flexcop-pci: card revision 2
<6>[   13.135722] b2c2_flexcop_pci 0000:02:0c.0: enabling device (0004
-> 0007)
<7>[   13.154137]   alloc irq_desc for 20 on node -1
<7>[   13.154143]   alloc kstat_irqs on node -1
<6>[   13.154156] b2c2_flexcop_pci 0000:02:0c.0: PCI INT A -> GSI 20
(level, low) -> IRQ 20
<6>[   13.190184] DVB: registering new adapter (FlexCop Digital TV device)
<6>[   13.210549] b2c2-flexcop: MAC address = 00:08:c9:e0:96:ff
<3>[   13.229739] CX24123: wrong demod revision: 62
<4>[   13.524474] mt352_read_register: readreg error (reg=127, ret==-121)
<4>[   13.555822] nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a,
err == -121)
<4>[   13.574430] Unknown/Unsupported NXT chip: 00 00 00 00 00
<4>[   13.611181] lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02
error (ret == -121)
<4>[   13.669970] stv0297_readreg: readreg error (reg == 0x80, ret == -121)
<7>[   13.708395] mt312_read: ret == -121
<3>[   13.708549] b2c2-flexcop: no frontend driver found for this
B2C2/FlexCop adapter
<6>[   13.728109] b2c2_flexcop_pci 0000:02:0c.0: PCI INT A disabled

Jonas
