Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1KFQS6-0006MJ-Tq
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 11:22:40 +0200
Message-ID: <48708BBF.9050400@cadsoft.de>
Date: Sun, 06 Jul 2008 11:09:19 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de>
In-Reply-To: <200807060315.51736@orion.escape-edv.de>
Cc: kernelnewbies <kernelnewbies@nl.linux.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jaswinder Singh <jaswinder@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
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

On 07/06/08 03:15, Oliver Endriss wrote:
> Jaswinder Singh wrote:
>> There's no point in this, since the user can use the BUILTIN_FIRMWARE
>> option to include arbitrary firmware files directly in the kernel image.
> 
> NAK! This option allows to compile the firmware into the _driver_,
> which is very useful if you want to test various driver/firmware
> combinations. Having the firmware in the _kernel_ does not help!

I strongly support Oliver's request!
Working with various driver versions is much easier with the
firmware compiled into the driver!

Klaus

> Well, I am tired to fight for this option in the kernel every other
> month. :-(
> 
> @Mauro:
> Is there a way to strip this stuff from Kconfig/Makefile/av7110*.[ch]
> for submission to the kernel? Basically I don't care whether and how
> they cripple the driver in the kernel. But I would like to keep the code
> 'as is' in the linuxtv repositories.
> 
> CU
> Oliver

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
