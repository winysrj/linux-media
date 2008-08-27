Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx00.csee.securepod.com ([66.232.128.196]
	helo=cseeapp00.csee.securepod.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KYHqg-00081B-GT
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 12:01:58 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	by smtp00.csee.securepod.com (Postfix) with ESMTP id E95B6198809A
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 11:01:22 +0100 (BST)
Message-ID: <48B525F4.50004@beardandsandals.co.uk>
Date: Wed, 27 Aug 2008 11:01:24 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080825122741.GB17421@optima.lan>	<48B2E1DC.2080605@beardandsandals.co.uk>
	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
In-Reply-To: <6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1532542994=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1532542994==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
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
</body>
</html>


--===============1532542994==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1532542994==--
