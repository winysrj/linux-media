Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <whauger@gmail.com>) id 1KYQqo-0007Hd-3b
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 21:38:45 +0200
Received: by rv-out-0506.google.com with SMTP id b25so14866rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 12:38:36 -0700 (PDT)
Message-ID: <6f94e1a00808271238q1d42e219t9d2b6c493d056b0c@mail.gmail.com>
Date: Wed, 27 Aug 2008 21:38:36 +0200
From: "Werner Hauger" <whauger@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48B5A157.1080206@beardandsandals.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080825122741.GB17421@optima.lan>
	<48B2E1DC.2080605@beardandsandals.co.uk>
	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
	<48B525F4.50004@beardandsandals.co.uk>
	<48B5A157.1080206@beardandsandals.co.uk>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
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

Hi

2008/8/27 Roger James <roger@beardandsandals.co.uk>:
> Roger James wrote:
>
> Do you ( or anyone) know of any source of information on the software
> interface to these boards? The guys who wrote the original code must have
> had some. Is Andrew de Quincey still active on the list?

Unfortunately not. Andrew had documentation from TT/Hauppauge but
under NDA.  I did not see anything from him on the list after he added
support for the then new 1.1 version.

> Hooray,
>
> I have got it working. I took out the TT3200 and the CI board to check their
> versions. Before putting them back in I cleaned and reseated the DEBI

So what revision of the CI board do you have ?

> interface cable connections. Whilst I was playing with some more diagnostics
> I noticed I was getting back a 0x1d (CISTPL_DEVICE_OA) code from the call
> the read_attribute_memory in the call to ciintf_poll_status I had put into
> the "PC card not responding" path. I put back the change to use polling mode
> for firmware version 0xa0 that I had tried and failed with before, and lo
> and behold it all burst into life. Well at least it appears to have
> intiailised, whether it will decrypt is for another day.
>

I'm glad you got it working. I wonder if that means there we indeed
have different CI firmware on new CI boards that need to be catered
for in the driver.

> Here is the dmesg output now for information.
>
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 12 (level, low) ->
> IRQ 12
> saa7146: found saa7146 @ mem e0a42000 (revision 1, irq 12) (0x13c2,0x1019).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:68:34:04
> input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> budget_ci: Slot status d587c000 set to NONE 3 ci_version a0
> budget_ci: Slot status d587c000 set to PRESENT
> dvb_ca_en50221_init
> budget_ci: CI interface initialised
> dvb_ca_en50221_thread
> budget_ci: Slot status d587c000 set to RESET
> budget_ci: Slot status d587c000 set to READY
> budget_ci: read_attribute 1d
> TUPLE type:0x1d length:4
>   0x00: 0x00 .
>   0x01: 0x61 a
>   0x02: 0x00 .
>   0x03: 0xff .
> TUPLE type:0x1c length:4
>   0x00: 0x00 .
>   0x01: 0xd3 .
>   0x02: 0x00 .
>   0x03: 0xff .
> TUPLE type:0x15 length:27
>   0x00: 0x05 .
>   0x01: 0x00 .
>   0x02: 0x54 T
>   0x03: 0x2d -
>   0x04: 0x52 R
>   0x05: 0x45 E
>   0x06: 0x58 X
>   0x07: 0x58 X
>   0x08: 0x00 .
>   0x09: 0x54 T
>   0x0a: 0x52 R
>   0x0b: 0x45 E
>   0x0c: 0x58 X
>   0x0d: 0x20
>   0x0e: 0x43 C
>   0x0f: 0x41 A
>   0x10: 0x4d M
>   0x11: 0x00 .
>   0x12: 0x52 R
>   0x13: 0x45 E
>   0x14: 0x56 V
>   0x15: 0x00 .
>   0x16: 0x32 2
>   0x17: 0x2e .
>   0x18: 0x32 2
>   0x19: 0x00 .
>   0x1a: 0xff .
> TUPLE type:0x20 length:4
>   0x00: 0xc9 .
>   0x01: 0x02 .
>   0x02: 0x01 .
>   0x03: 0x01 .
> TUPLE type:0x1a length:21
>   0x00: 0x01 .
>   0x01: 0x39 9
>   0x02: 0x00 .
>   0x03: 0x02 .
>   0x04: 0x03 .
>   0x05: 0xc0 .
>   0x06: 0x0e .
>   0x07: 0x41 A
>   0x08: 0x02 .
>   0x09: 0x44 D
>   0x0a: 0x56 V
>   0x0b: 0x42 B
>   0x0c: 0x5f _
>   0x0d: 0x43 C
>   0x0e: 0x49 I
>   0x0f: 0x5f _
>   0x10: 0x56 V
>   0x11: 0x31 1
>   0x12: 0x2e .
>   0x13: 0x30 0
>   0x14: 0x30 0
> TUPLE type:0x1b length:42
>   0x00: 0xf9 .
>   0x01: 0x04 .
>   0x02: 0x09 .
>   0x03: 0x7f .
>   0x04: 0x55 U
>   0x05: 0xcd .
>   0x06: 0x19 .
>   0x07: 0xd5 .
>   0x08: 0x19 .
>   0x09: 0x3d =
>   0x0a: 0x9e .
>   0x0b: 0x25 %
>   0x0c: 0x26 &
>   0x0d: 0x54 T
>   0x0e: 0x22 "
>   0x0f: 0xc0 .
>   0x10: 0x09 .
>   0x11: 0x44 D
>   0x12: 0x56 V
>   0x13: 0x42 B
>   0x14: 0x5f _
>   0x15: 0x48 H
>   0x16: 0x4f O
>   0x17: 0x53 S
>   0x18: 0x54 T
>   0x19: 0x00 .
>   0x1a: 0xc1 .
>   0x1b: 0x0e .
>   0x1c: 0x44 D
>   0x1d: 0x56 V
>   0x1e: 0x42 B
>   0x1f: 0x5f _
>   0x20: 0x43 C
>   0x21: 0x49 I
>   0x22: 0x5f _
>   0x23: 0x4d M
>   0x24: 0x4f O
>   0x25: 0x44 D
>   0x26: 0x55 U
>   0x27: 0x4c L
>   0x28: 0x45 E
>   0x29: 0x00 .
> TUPLE type:0x14 length:0
> END OF CHAIN TUPLE type:0xff
> Valid DVB CAM detected MANID:2c9 DEVID:101 CONFIGBASE:0x200
> CONFIGOPTION:0x39
> dvb_ca_en50221_set_configoption
> Set configoption 0x39, read configoption 0x39
> DVB CAM validated successfully
> dvb_ca_en50221_link_init
> dvb_ca_en50221_wait_if_status
> dvb_ca_en50221_wait_if_status succeeded timeout:0
> dvb_ca_en50221_read_data
> Received CA packet for slot 0 connection id 0x0 last_frag:0 size:0x2
> Chosen link buffer size of 255
> dvb_ca_en50221_wait_if_status
> dvb_ca_en50221_wait_if_status succeeded timeout:0
> dvb_ca_en50221_write_data
> Wrote CA packet for slot 0, connection id 0x0 last_frag:0 size:0x2
> dvb_ca adapter 0: DVB CAM detected and initialised successfully
> stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100
> DVB: registering frontend 0 (STB0899 Multistandard)...

That looks perfect.

Werner

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
