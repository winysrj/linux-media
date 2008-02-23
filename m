Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JSnxf-0000XV-Ct
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 07:34:15 +0100
Message-ID: <47BFBE5A.4030000@gmail.com>
Date: Sat, 23 Feb 2008 10:34:02 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <694662.3577.qm@web33104.mail.mud.yahoo.com>
In-Reply-To: <694662.3577.qm@web33104.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
 AD	SP400 rebadge)
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

Simeon Simeonov wrote:
> Hi Gernot,
> 
> I can confirm that I have similar experience to yours.
> By the way do you know if one can control from the soft side (register or some other means)
> the max current output for the card. I am having a problem when trying to tune with a rotor.
> On the Linux side the current seems to be capped at 300 mA as on the XP I see it goes to
> about 440 mA. I was still surprised that this card can supply less current than the 102g but
> we take what we get ...


The card has an auxiliary power supply i/p, which should be connected, 
if you are using a larger load.
With a higher load and if you draw power from the PCI bus, it could be 
bad, as there are some
limitations to the current drawn from a PCI slot. Also, you can set the 
SEC chip for a different current
limitation.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
