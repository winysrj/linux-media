Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from saturn.adsl24.co.uk ([84.234.17.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <john@sager.me.uk>) id 1LDK2E-00081z-5u
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 15:39:30 +0100
Message-ID: <494A607E.9030105@sager.me.uk>
Date: Thu, 18 Dec 2008 14:38:54 +0000
From: John Sager <john@sager.me.uk>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <494913C4.9060704@sager.me.uk>
	<1229552900.3109.24.camel@palomino.walls.org>
In-Reply-To: <1229552900.3109.24.camel@palomino.walls.org>
Cc: LinuxTV-DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] pci_abort messages from cx88 driver
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

Andy,

Thanks for the reply.

Andy Walls wrote:

> 
> You've logically leaped too far.  You can only say that the aborted PCI
> transfers, if any actually happened, didn't matter to apparent proper
> operation of the device in it's current mode of operation.
> 
> That said, maybe the best course of action is to ignore PCI aborts when
> a capture is ongoing.  It however, may not be the best idea to ignore
> such errors when setting up for a capture or controlling I2C device
> through the chip.

The interrupts in question are specifically related to the transport
stream.

> 
>>
>> It may be worth fixing this in the main code to hide the problem for
>> unfortunate users of this & related cards until the real problem is
>> found. Unfortunately I doubt I can help there as a detailed knowledge
>> of the Conexant PCI interface device is probably required to pursue it.
> 
> Maybe not.  Look at the cx18 driver where a similar issue was
> confronted.

Yuk. I see what you mean. I don't think I really want to go that far.
The fix is minor so I don't mind patching kernels for my own use
when they get upgraded. If I start getting other problems as a consequence
I may just give up on the card but fingers-crossed it's working OK
for now.

regards,

John

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
