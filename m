Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <martin.hurton@gmail.com>) id 1KYHC0-00058c-Le
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 11:19:59 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1586944nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 02:19:52 -0700 (PDT)
Date: Wed, 27 Aug 2008 11:19:48 +0200
From: Martin Hurton <martin.hurton@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080827091948.GA2479@optima.lan>
References: <20080825122741.GB17421@optima.lan>
	<48B2E1DC.2080605@beardandsandals.co.uk>
	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
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

Hi Werner

On Tue, Aug 26, 2008 at 09:35:55PM +0200, Werner Hauger wrote:
> Hi Guys
> 
> What is the hardware revision of your CI board (printed on the bottom
> of the PCB just above the PCI connector)?

The revision of my CI board is 1.1.
> 
> I have a Rev 1.1 on my TT S2-3200 which requires polling, as well a
> Rev 1.0 on an old NOVA-S card which provides an interrupt, both of
> which work with the current driver. The version testing code was added
> to the driver to handle these two boards. Maybe there is a new
> revision out that the driver does not yet cater for.
> 
> A working CI and CAM combination should produce the following output
> when the driver loads:
> 
> Linux video capture interface: v2.00
> saa7146: register extension 'dvb'.
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
> PCI: setting IRQ 5 as level-triggered
> ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 5 (level,
> low) -> IRQ 5
> saa7146: found saa7146 @ mem d8ae8000 (revision 1, irq 5) (0x13c2,0x1019).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:64:ba:14
> input: Budget-CI dvb ir receiver saa7146 (0) as
> /devices/pci0000:00/0000:00:09.0/input/input6
> budget_ci: CI interface initialised
> stb0899_get_dev_id: Device ID=[8], Release=[2]
> stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
> stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
> stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100
> dvb_ca adapter 0: DVB CAM detected and initialised successfully
> DVB: registering frontend 0 (STB0899 Multistandard)...
> 
> > > 508     if ((ci_version & 0xa0) != 0xa0) {
> > > 509             result = -ENODEV;
> > > 510             goto error;
> > > 511     }
> > >
> 
> Martin, have you tried commenting out this test to see if you then can
> get the 'CI interface initialised' message?

When I comment out the above code, I can see the "CI interface
initialised" message, but cannot see the "dvb_ca adapter 0: DVB CAM
detected and initialised successfully" one. The CA is not working.
> 
> > Sorry I cannot offer any direct help. But I thought you might like to
> > know you are not the only one fighting with this piece of hardware :-)
> >
> > Roger
> 
> Roger, in your other message you said your CI board reports the
> version as 0xa0 which the driver expects to generate interrupts, which
> clearly it doesn't. Have you tried changing the code so that the
> driver uses polling for your CI version?
> 
> Werner

Do you know of any way to make sure the connection between TT-3200 and CI
board is working properly? 

Regards,
/Martin


> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
