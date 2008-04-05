Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Ji9uy-0008Vq-Hl
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 17:02:57 +0200
Message-ID: <47F79499.5000004@linuxtv.org>
Date: Sat, 05 Apr 2008 11:02:49 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: aldebaran <aldebx@yahoo.fr>
References: <47F79267.7060307@yahoo.fr>
In-Reply-To: <47F79267.7060307@yahoo.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx23885 and Xc3028 frontend type (ATSC) is not
 compatible with requested tuning type (OFDM)
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

aldebaran wrote:
> Dear linux-dvb developers,
> I own an HP rebranded Hauppauge Express Card shipped with several HP
> laptops.
> I know you recently added support for this device, however I cannot
> manage to make it work.
> Specifically I cannot use the 'scan' utility to generate a channels.conf
> file usable with me-tv, thus I cannot use the tuner.
> I had the same outcomes either with v4l-dvb and patched cx23885 drivers.
> Thank you for your support!
> 
> here is the output of this tool:
> 
>    scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris
>    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>    initial transponder 810000000 0 2 1 3 1 0 0
>    initial transponder 730000000 0 2 1 3 1 0 0
>    initial transponder 626000000 0 2 1 3 1 0 0
>    WARNING: frontend type (ATSC) is not compatible with requested
>    tuning type (OFDM)
>    WARNING: frontend type (ATSC) is not compatible with requested
>    tuning type (OFDM)
>    WARNING: frontend type (ATSC) is not compatible with requested
>    tuning type (OFDM)
>    ERROR: initial tuning failed
>    dumping lists (0 services)
>    Done.
> 
> here are my card specs:
> HP Hauppauge WinTv 885
> model 77001 rev d4c0 (Model 77xxx Analog/ATSC Hybrid, Xc3028)
> tuner: Xceive xc3028 http://www.xceive.com/technology_XC3028.htm
> audio tuner: stereo cx23885
> decoder: cx23885 http://www.conexant.com/products/entry.jsp?id=393
> 
> The card seems correctly recognised, here is my dmesg output:
> 
>    [   34.715408] cx23885 driver version 0.0.1 loaded
>    [   34.715478] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level,
>    low) -> IRQ 17
>    [   34.715495] CORE cx23885[0]: subsystem: 0070:7717, board:
>    Hauppauge WinTV-HVR1500 [card=6,autodetected]
[snip]
>    [   34.826010] cx23885[0]: i2c bus 0 registered
>    [   34.826027] cx23885[0]: i2c bus 1 registered
>    [   34.826041] cx23885[0]: i2c bus 2 registered
>    [   34.853553] tveeprom 0-0050: Hauppauge model 77001, rev D4C0,
>    serial #68766589
>    [   34.853556] tveeprom 0-0050: MAC address is 00-0D-FE-23-A3-DB
>    [   34.853558] tveeprom 0-0050: tuner model is Xceive XC3028 (idx
>    120, type 71)
>    [   34.853561] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB
>    Digital (eeprom 0x88)
>    [   34.853563] tveeprom 0-0050: audio processor is CX23885 (idx 39)
>    [   34.853565] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
>    [   34.853567] tveeprom 0-0050: has no radio, has no IR receiver,
>    has no IR transmitter
>    [   34.853569] cx23885[0]: hauppauge eeprom: model=77001
>    [   34.853571] cx23885[0]: cx23885 based dvb card
>    [   34.980916] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>    [   34.980921] DVB: registering new adapter (cx23885[0])
>    [   34.980924] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
>    Frontend)...
>    [   34.981111] cx23885_dev_checkrevision() Hardware revision = 0xb0
>    [   34.981120] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 17,
>    latency: 0, mmio: 0xbc000000
>    [   34.981128] PCI: Setting latency timer of device 0000:04:00.0 to 64

Aldebaran,

You are using the HVR1500, which is an ATSC-only card.  (not to be confused with the HVR1500Q, which also supports QAM)

However, you are attempting to tune OFDM in Paris, but that will not work with an ATSC card.

A better card for that purpose would be the HVR1400, but that card is not yet supported in linux :-/

Sorry for the bad news.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
