Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43384 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871AbZJODKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 23:10:53 -0400
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
From: Andy Walls <awalls@radix.net>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4AD5AFA6.8080401@onelan.com>
References: <4AD591BB.80607@onelan.com>
	 <1255516547.3848.10.camel@palomino.walls.org> <4AD5AFA6.8080401@onelan.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 23:12:32 -0400
Message-Id: <1255576352.5829.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-10-14 at 12:01 +0100, Simon Farnsworth wrote:
> Andy Walls wrote:
> > Have your remote user read
> > 
> > http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
> > 
> > and take any actions that seem appropriate/easy.
> > 
> I'll try that again - they're grouching, because their TV is fine, and
> the same card in a Windows PC is also fine. It's just under Linux that
> they're seeing problems, so I may not be able to get them to co-operate.


Right, the windows driver code for the mxl5005s is better.  Inform him
that the linux driver for the mxl5005s could be better.  If he has any
contacts at MaxLinear to get the datasheet and programming manual
released to me, I can make the linux driver better.


> > The in kernel mxl5005s driver is known to have about 3 dB worse
> > performance for QAM vs 8-VSB (Steven Toth took some measurements once).
> > 
> Am I misunderstanding dmesg here? I see references to a Samsung S5H1409,

The S5H1409 refers to the CX24227 ATSC/QAM demodulator chip (Conexant
bought the rights to the S5H1409 from Samsung).  That chip is where the
analog waveform actually gets demodulated down to digital data bits.
.

> not to an mxl5005s;

The MXL5005s is the silicon tuner chip on the Digital TV side of the
HVR-1600.  A simple picture for you:

 Cable ---| MXL5005s |----| CX24227 |----| CX23418 |--- PCI bus

---- Analog Waveform-----------|--------Digital Data--------------



>  if I've read the driver code correctly, I'd see a
> KERN_INFO printk for the mxl5005s when it comes up.

Here's my HVR-1600 related entries from dmesg on startup.  I have the
MXL5005S showing up at 9.510:

[    8.779549] cx18:  Start initialization, version 1.2.0
[    9.042096] cx18-0: Initializing card 0
[    9.042099] cx18-0: Autodetected Hauppauge card
[    9.042128] ivtv: End initialization
[    9.042433] cx18 0000:02:02.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.044796] cx18-0: cx23418 revision 01010000 (B)
[    9.287165] tveeprom 2-0050: Hauppauge model 74551, rev C1A3, serial# 1845764
[    9.287169] tveeprom 2-0050: MAC address is 00-0D-FE-1C-2A-04
[    9.287172] tveeprom 2-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
[    9.287175] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)
[    9.287177] tveeprom 2-0050: audio processor is CX23418 (idx 38)
[    9.287179] tveeprom 2-0050: decoder processor is CX23418 (idx 31)
[    9.287181] tveeprom 2-0050: has radio
[    9.287183] cx18-0: Autodetected Hauppauge HVR-1600
[    9.287185] cx18-0: Simultaneous Digital and Analog TV capture supported
[    9.402274] tuner 3-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
[    9.402351] tda9887 3-0043: creating new instance
[    9.402353] tda9887 3-0043: tda988[5/6/7] found
[    9.405781] tuner 3-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[    9.418329] cs5345 2-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[    9.421205] tuner-simple 3-0061: creating new instance
[    9.421208] tuner-simple 3-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or FM1236/F))
[    9.423993] cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
[    9.423997] DVB: registering new adapter (cx18)
[    9.510767] MXL5005S: Attached at address 0x63
[    9.510774] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[    9.510855] cx18-0: DVB Frontend registered
[    9.510858] cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
[    9.510892] cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
[    9.510922] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
[    9.510946] cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)
[    9.510970] cx18-0: Registered device radio0 for encoder radio
[    9.510973] cx18-0: Initialized card: Hauppauge HVR-1600
[    9.510997] cx18:  End initialization


