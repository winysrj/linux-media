Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JTlNn-0000vN-FP
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 23:01:11 +0100
Message-ID: <47C33A9D.6000902@gmail.com>
Date: Tue, 26 Feb 2008 02:01:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <347808.47907.qm@web33106.mail.mud.yahoo.com>
In-Reply-To: <347808.47907.qm@web33106.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD
 SP400 rebadge)
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
> Hi Manu,
> 
> Thanks for the reply
> Yes, indeed I tried over the weekend and by selecting the higher limitation by ISEL register:
> 
> if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0, 0x40)) {
> 
> My rotor now moves. Do you think it is better to use static current protection?

It is similar to an Auto transmission car in comparison to a manual 
transmission one.
It depends how well you can handle it. Dynamic limitation is done by 
using PWM. The
advantage of using static limiting is a slightly higher dissipation but 
you see in some
practical cases that it can provide more current or maybe that it 
behaves a bit more
better in comparison. When you have more dissipation, the device draws a 
larger
current from the bus, but that's all about it. (Normally many people 
don't like Static
limitation due to the additional dissipation and current drawn, since it 
is not advisable
to sink large currents from the PCI bus and hence an additional 
auxiliary power connector
is provided on the card. Most cards generally draw power from the PCI 
bus alone)

> But unfortunately that is not the end of the story. The problem that I am
> having now is that patched mythtv rewrites the limits in my rotor?! And the weird thing is 
> it does in such a way that I had to take the motor apart to recalibrate it. It looks like there are
> hard limits in the rotor (Aston 1.2) firmware which are not the software limits because trying to reset 
> them either from Linux side or from Windoz did not help. So I actually had to take it apart to recalibrate
> the motor inside the rotor. I do not think there is a problem with the rotor itself because I have been using it for over 2 years with my other Twinhah 102g card without any problems.
> I also wrote a small command line program (using libsec) that will do only rotor commands. With that
> program I can do goto n, store, reset, soft limits. All there operations work fine. Goto nn steps also
> works somewhat even though it is not taking the specified number of steps precisely. I am not sure why.
> 
> Getting back to my mythtv setup - I have a committed switch behind the rotor. So the rotor command is followed by (with 15ms delay) the switch, tone burst and then tunning commands. I turned on the verbose in mantis module and looked what i2c reports. The diseqc sequence looks correct. The only thing I see is that the fifo gets filled up by the end of the sequence so we have to wait for a few cycles before sending the next byte. So now I am thinking could there be any problems if the pause between writing the diseqc bytes is a bit longer since we write byte, check if fifo is full and then write the next byte. What do you think about that? I was thinking of trying to write the whole diseqc command and then check fifo or even better first check fifo and then write the command since we have 15ms between commands anyway.
> On the side - switch works 50% of the times so I should look into that too. It is a really good Spaun switch and even with 102g works flawlessly.

Ok, does sending the commands as it is on the fly help for you, rather 
than storing
all of them in the FIFO and whack them out in a disciplined way ?

If it looks working better that way, will try that and ask others as 
well whether they
see similar benefits ?


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
