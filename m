Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bene2.itea.ntnu.no ([129.241.56.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mathieu.taillefumier@free.fr>) id 1KpIGj-00085M-KC
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 09:55:11 +0200
Message-ID: <48F2FED4.8060206@free.fr>
Date: Mon, 13 Oct 2008 09:55:00 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <1223741522.48f0d052c956b@webmail.free.fr>
	<1223753645.3125.57.camel@palomino.walls.org>
In-Reply-To: <1223753645.3125.57.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 bug in 64 bits system
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
> With a diff of the dmesg files, I noticed things are being detected and
> configured slightly differently.  I'm not sure that's important, but
> this one in particular caught my eye:
>
>      ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>     -ACPI: Skipping IOAPIC probe due to 'noapic' option.
>     +ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>     +IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
>
>
> Any particular reason you're specifying noapic for 32 bit and not for 64
> bit?
>    
Well, not anymore. I had trouble with some old kernels that did not want 
to boot correctly from time to time and putting noapic was helping a bit.
> Again, I'm not sure if it's important, but if you are troubleshooting
> between 2 setups, you want to eliminate as many unknowns as possible by
> keeping things the same as much as you can.
>    
I do agree with you but the thing is that the config options for 32bits 
and 64bits are not completely identical either. I recompiled the kernel 
yesterday for both 32 and 64 bits and I discover for instance that the 
initialization of the tvcard is wrong in 32bits when the option 
CONFIG_RESOURCES_64bits is enabled. The gpio is correct but the rest of 
the output are obviously wrong.
> I'm wagering it's a PCI bus configuration/setup problem.  (*guess*)
>
> Given that it looks like your video card is a PCMCIA/CardBus card, maybe
> something with the Yenta driver is not right. (*Wild guess*)
>
> This message, that only appeared in dmesg-64, may be of concern, since
> you're using a PCMCIA/CardBus card:
>
>     cs: pcmcia_socket0: unable to apply power.
>     pccard: CardBus card inserted into slot 0
>    
I was able to reproduce it but curiously the power is not restored when 
I unload the driver, disconnect the card and put the card again in the 
slot (after 1 minute). I have to do a reboot to turn the card on.
>> I am willing to help
>> the devs to track down this bug so please let me know if you need some help.
>> Those are just WAGs as to what might be wrong.  More differential
>> analysis of the dmesg and dmesg-64 files may help you narrow things
>> down.  I will think you'll need to expand your search beyond the saa7134
>> driver messages - to me they appear to be symptoms caused by a problem
>> with something else.  Good luck.
>>      
I think I will need some. Anyway thank you for the help.

Regards

Mathieu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
