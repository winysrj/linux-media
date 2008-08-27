Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx00.csee.securepod.com ([66.232.128.196]
	helo=cseeapp00.csee.securepod.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KYQ49-00043z-SM
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 20:48:26 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	by smtp00.csee.securepod.com (Postfix) with ESMTP id C75EA22C6C0
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 19:47:50 +0100 (BST)
Message-ID: <48B5A157.1080206@beardandsandals.co.uk>
Date: Wed, 27 Aug 2008 19:47:51 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080825122741.GB17421@optima.lan>	<48B2E1DC.2080605@beardandsandals.co.uk>	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
	<48B525F4.50004@beardandsandals.co.uk>
In-Reply-To: <48B525F4.50004@beardandsandals.co.uk>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0351040032=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0351040032==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Roger James wrote:
<blockquote cite="mid:48B525F4.50004@beardandsandals.co.uk" type="cite">
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
Werner Hauger wrote:
  <blockquote
 cite="mid:6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com"
 type="cite">
    <pre wrap="">Hi Guys

What is the hardware revision of your CI board (printed on the bottom
of the PCB just above the PCI connector)?

I have a Rev 1.1 on my TT S2-3200 which requires polling, as well a
Rev 1.0 on an old NOVA-S card which provides an interrupt, both of
which work with the current driver. The version testing code was added
to the driver to handle these two boards. Maybe there is a new
revision out that the driver does not yet cater for.

A working CI and CAM combination should produce the following output
when the driver loads:

Linux video capture interface: v2.00
saa7146: register extension 'dvb'.
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:09.0[A] -&gt; Link [LNKB] -&gt; GSI 5 (level,
low) -&gt; IRQ 5
saa7146: found saa7146 @ mem d8ae8000 (revision 1, irq 5) (0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr = 00:d0:5c:64:ba:14
input: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:00/0000:00:09.0/input/input6
budget_ci: CI interface initialised
stb0899_get_dev_id: Device ID=[8], Release=[2]
stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100
dvb_ca adapter 0: DVB CAM detected and initialised successfully
DVB: registering frontend 0 (STB0899 Multistandard)...

  </pre>
    <blockquote type="cite">
      <blockquote type="cite">
        <pre wrap="">508     if ((ci_version &amp; 0xa0) != 0xa0) {
509             result = -ENODEV;
510             goto error;
511     }

      </pre>
      </blockquote>
    </blockquote>
    <pre wrap=""><!---->
Martin, have you tried commenting out this test to see if you then can
get the 'CI interface initialised' message?

  </pre>
    <blockquote type="cite">
      <pre wrap="">Sorry I cannot offer any direct help. But I thought you might like to
know you are not the only one fighting with this piece of hardware :-)

Roger
    </pre>
    </blockquote>
    <pre wrap=""><!---->
Roger, in your other message you said your CI board reports the
version as 0xa0 which the driver expects to generate interrupts, which
clearly it doesn't. Have you tried changing the code so that the
driver uses polling for your CI version?

Werner

  </pre>
  </blockquote>
Werner,<br>
  <br>
Thank you for the suggestions. All help is gratefully received.<br>
  <br>
The board does generate interrupts for CAM insertion and removal. But I
did try it with polling, no change. The flags coming back from the CI
stay at 0x09 (CICONTROL_CAMDETECT_|CICONTROL_RESET), and the read of
byte 0 of the atrribute memory returns 0x00 so the slot never goes into
ready state. I will follow your suggestion and check out the board
versions though!<br>
  <br>
I am waiting for the delivery an AstonCrypt CAM (I found one cheap one
ebay) to see if that will initialise. As far as I can see, in my case
the DEBI interface between the TT-3200 and the CI board is working, but
I cannot ascertain if the CI interface on the daughter board is working
properly or the CAM I am using (T.Rex/Dragon) is incompatible with the
budget-ci driver. I know the Dragon CAM will work in TT-3200+CI
installations on windows using the TT drivers because a number of
people have reported success with it. The particular CAM I have also
works with the CI emulator in my CAS-3 programmer so I don't think it
is faulty.<br>
  <br>
In Martin's set up the DEBI interface may not be working as he does not
see any difference if the CAM is present or not.<br>
  <br>
Do you ( or anyone) know of any source of information on the software
interface to these boards? The guys who wrote the original code must
have had some. Is Andrew de Quincey still active on the list?<br>
  <br>
Roger
</blockquote>
Hooray,<br>
<br>
I have got it working. I took out the TT3200 and the CI board to check
their versions. Before putting them back in I cleaned and reseated the
DEBI interface cable connections. Whilst I was playing with some more
diagnostics I noticed I was getting back a 0x1d (CISTPL_DEVICE_OA) code
from the call the read_attribute_memory in the call to
ciintf_poll_status I had put into the "PC card not responding" path. I
put back the change to use polling mode for firmware version 0xa0 that
I had tried and failed with before, and lo and behold it all burst into
life. Well at least it appears to have intiailised, whether it will
decrypt is for another day.<br>
<br>
Here is the dmesg output now for information.<br>
<br>
saa7146: register extension 'budget_ci dvb'.<br>
ACPI: PCI Interrupt 0000:00:0b.0[A] -&gt; Link [LNKD] -&gt; GSI 12
(level, low) -&gt; IRQ 12<br>
saa7146: found saa7146 @ mem e0a42000 (revision 1, irq 12)
(0x13c2,0x1019).<br>
saa7146 (0): dma buffer size 192512<br>
DVB: registering new adapter (TT-Budget S2-3200 PCI)<br>
adapter has MAC addr = 00:d0:5c:68:34:04<br>
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9<br>
budget_ci: Slot status d587c000 set to NONE 3 ci_version a0<br>
budget_ci: Slot status d587c000 set to PRESENT<br>
dvb_ca_en50221_init<br>
budget_ci: CI interface initialised<br>
dvb_ca_en50221_thread<br>
budget_ci: Slot status d587c000 set to RESET<br>
budget_ci: Slot status d587c000 set to READY<br>
budget_ci: read_attribute 1d<br>
TUPLE type:0x1d length:4<br>
&nbsp; 0x00: 0x00 .<br>
&nbsp; 0x01: 0x61 a<br>
&nbsp; 0x02: 0x00 .<br>
&nbsp; 0x03: 0xff .<br>
TUPLE type:0x1c length:4<br>
&nbsp; 0x00: 0x00 .<br>
&nbsp; 0x01: 0xd3 .<br>
&nbsp; 0x02: 0x00 .<br>
&nbsp; 0x03: 0xff .<br>
TUPLE type:0x15 length:27<br>
&nbsp; 0x00: 0x05 .<br>
&nbsp; 0x01: 0x00 .<br>
&nbsp; 0x02: 0x54 T<br>
&nbsp; 0x03: 0x2d -<br>
&nbsp; 0x04: 0x52 R<br>
&nbsp; 0x05: 0x45 E<br>
&nbsp; 0x06: 0x58 X<br>
&nbsp; 0x07: 0x58 X<br>
&nbsp; 0x08: 0x00 .<br>
&nbsp; 0x09: 0x54 T<br>
&nbsp; 0x0a: 0x52 R<br>
&nbsp; 0x0b: 0x45 E<br>
&nbsp; 0x0c: 0x58 X<br>
&nbsp; 0x0d: 0x20<br>
&nbsp; 0x0e: 0x43 C<br>
&nbsp; 0x0f: 0x41 A<br>
&nbsp; 0x10: 0x4d M<br>
&nbsp; 0x11: 0x00 .<br>
&nbsp; 0x12: 0x52 R<br>
&nbsp; 0x13: 0x45 E<br>
&nbsp; 0x14: 0x56 V<br>
&nbsp; 0x15: 0x00 .<br>
&nbsp; 0x16: 0x32 2<br>
&nbsp; 0x17: 0x2e .<br>
&nbsp; 0x18: 0x32 2<br>
&nbsp; 0x19: 0x00 .<br>
&nbsp; 0x1a: 0xff .<br>
TUPLE type:0x20 length:4<br>
&nbsp; 0x00: 0xc9 .<br>
&nbsp; 0x01: 0x02 .<br>
&nbsp; 0x02: 0x01 .<br>
&nbsp; 0x03: 0x01 .<br>
TUPLE type:0x1a length:21<br>
&nbsp; 0x00: 0x01 .<br>
&nbsp; 0x01: 0x39 9<br>
&nbsp; 0x02: 0x00 .<br>
&nbsp; 0x03: 0x02 .<br>
&nbsp; 0x04: 0x03 .<br>
&nbsp; 0x05: 0xc0 .<br>
&nbsp; 0x06: 0x0e .<br>
&nbsp; 0x07: 0x41 A<br>
&nbsp; 0x08: 0x02 .<br>
&nbsp; 0x09: 0x44 D<br>
&nbsp; 0x0a: 0x56 V<br>
&nbsp; 0x0b: 0x42 B<br>
&nbsp; 0x0c: 0x5f _<br>
&nbsp; 0x0d: 0x43 C<br>
&nbsp; 0x0e: 0x49 I<br>
&nbsp; 0x0f: 0x5f _<br>
&nbsp; 0x10: 0x56 V<br>
&nbsp; 0x11: 0x31 1<br>
&nbsp; 0x12: 0x2e .<br>
&nbsp; 0x13: 0x30 0<br>
&nbsp; 0x14: 0x30 0<br>
TUPLE type:0x1b length:42<br>
&nbsp; 0x00: 0xf9 .<br>
&nbsp; 0x01: 0x04 .<br>
&nbsp; 0x02: 0x09 .<br>
&nbsp; 0x03: 0x7f .<br>
&nbsp; 0x04: 0x55 U<br>
&nbsp; 0x05: 0xcd .<br>
&nbsp; 0x06: 0x19 .<br>
&nbsp; 0x07: 0xd5 .<br>
&nbsp; 0x08: 0x19 .<br>
&nbsp; 0x09: 0x3d =<br>
&nbsp; 0x0a: 0x9e .<br>
&nbsp; 0x0b: 0x25 %<br>
&nbsp; 0x0c: 0x26 &amp;<br>
&nbsp; 0x0d: 0x54 T<br>
&nbsp; 0x0e: 0x22 "<br>
&nbsp; 0x0f: 0xc0 .<br>
&nbsp; 0x10: 0x09 .<br>
&nbsp; 0x11: 0x44 D<br>
&nbsp; 0x12: 0x56 V<br>
&nbsp; 0x13: 0x42 B<br>
&nbsp; 0x14: 0x5f _<br>
&nbsp; 0x15: 0x48 H<br>
&nbsp; 0x16: 0x4f O<br>
&nbsp; 0x17: 0x53 S<br>
&nbsp; 0x18: 0x54 T<br>
&nbsp; 0x19: 0x00 .<br>
&nbsp; 0x1a: 0xc1 .<br>
&nbsp; 0x1b: 0x0e .<br>
&nbsp; 0x1c: 0x44 D<br>
&nbsp; 0x1d: 0x56 V<br>
&nbsp; 0x1e: 0x42 B<br>
&nbsp; 0x1f: 0x5f _<br>
&nbsp; 0x20: 0x43 C<br>
&nbsp; 0x21: 0x49 I<br>
&nbsp; 0x22: 0x5f _<br>
&nbsp; 0x23: 0x4d M<br>
&nbsp; 0x24: 0x4f O<br>
&nbsp; 0x25: 0x44 D<br>
&nbsp; 0x26: 0x55 U<br>
&nbsp; 0x27: 0x4c L<br>
&nbsp; 0x28: 0x45 E<br>
&nbsp; 0x29: 0x00 .<br>
TUPLE type:0x14 length:0<br>
END OF CHAIN TUPLE type:0xff<br>
Valid DVB CAM detected MANID:2c9 DEVID:101 CONFIGBASE:0x200
CONFIGOPTION:0x39<br>
dvb_ca_en50221_set_configoption<br>
Set configoption 0x39, read configoption 0x39<br>
DVB CAM validated successfully<br>
dvb_ca_en50221_link_init<br>
dvb_ca_en50221_wait_if_status<br>
dvb_ca_en50221_wait_if_status succeeded timeout:0<br>
dvb_ca_en50221_read_data<br>
Received CA packet for slot 0 connection id 0x0 last_frag:0 size:0x2<br>
Chosen link buffer size of 255<br>
dvb_ca_en50221_wait_if_status<br>
dvb_ca_en50221_wait_if_status succeeded timeout:0<br>
dvb_ca_en50221_write_data<br>
Wrote CA packet for slot 0, connection id 0x0 last_frag:0 size:0x2<br>
dvb_ca adapter 0: DVB CAM detected and initialised successfully<br>
stb0899_attach: Attaching STB0899<br>
stb6100_attach: Attaching STB6100<br>
DVB: registering frontend 0 (STB0899 Multistandard)...<br>
<br>
Roger<br>
<br>
</body>
</html>


--===============0351040032==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0351040032==--
