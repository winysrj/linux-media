Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajw1980@gmail.com>) id 1JUQ3j-0000UH-5B
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 18:27:11 +0100
Received: by py-out-1112.google.com with SMTP id a29so3096199pyi.0
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 09:26:57 -0800 (PST)
Date: Wed, 27 Feb 2008 11:26:54 -0600
From: Andy Wettstein <ajw1980@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080227172654.GA2191@wettstein.homelinux.org>
References: <20080227000807.GB14099@wettstein.homelinux.org>
	<47C59132.2090701@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47C59132.2090701@linuxtv.org>
Subject: Re: [linux-dvb] hvr1250 messages
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

On Wed, Feb 27, 2008 at 11:34:58AM -0500, Steven Toth wrote:
> Andy Wettstein wrote:
>> Hi,
>>
>> I just installed a hauppauge hvr1250 and it seems to be ok, but
>> there are ton of messages being logged.  I am wondering if these  
>> messages are something to be concerned about.
>>
>> uname:
>> Linux beerme 2.6.24-1-686 #1 SMP Mon Feb 11 14:37:45 UTC 2008 i686 GNU/Linux
>>
>>
>> Relevant dmesg output:
>>
>> cx23885 driver version 0.0.1 loaded
>> ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
>> ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC5] -> GSI 16 (level, low) -> IRQ 19
>> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]
>> cx23885[0]: i2c bus 0 registered
>> cx23885[0]: i2c bus 1 registered
>> cx23885[0]: i2c bus 2 registered
>> tveeprom 0-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.
>> cx23885[0]: warning: unknown hauppauge model #0
>> cx23885[0]: hauppauge eeprom: model=0
>> cx23885[0]: cx23885 based dvb card
>> MT2131: successfully identified at address 0x61
>> DVB: registering new adapter (cx23885[0])
>> DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
>> cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xfd800000
>> PCI: Setting latency timer of device 0000:01:00.0 to 64
>
> The driver was loaded with debug enabled.

Thanks.  Much quieter with the debugging off.  Now to figure out why 
mythbackend segfaults recording from this card.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
