Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33102.mail.mud.yahoo.com ([209.191.69.132])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JUca2-0006ia-RF
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 07:49:23 +0100
Date: Wed, 27 Feb 2008 22:48:48 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Message-ID: <445553.1721.qm@web33102.mail.mud.yahoo.com>
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

Hi Manu,

Here is some more info about my diseqc problem:

> Ok, does sending the commands as it is on the fly help for you, rather 
> than storing
> all of them in the FIFO and whack them out in a disciplined way ?
>
> If it looks working better that way, will try that and ask others as
> well whether they
> see similar benefits ?

The short answer is no,  I do not see any benefits of sending the whole
diseqc command.

Unfortunately I still do not have a good idea what exactly the problem is.
Here is what I tried:
1. Bypass the rotor and connect directly to the switch: in that case switch
works 100% of the times even though I am first sending a rotor switch command
and then switch command and no repeats. This I checked with both mythtv
and szap.
2. Connect the rotor and send a rotor, followed by a switch command with no repeats.
In this case rotor works fine but the switch works 1/10 times. But my rotor does not
get reprogrammed
3. Send more than 2 diseqc command - being repeat for either switch or rotor or both.
Well if the rotor does not have to move (I have 2 satellites that I can use for that)
switch works about half of the time but as soon as try to move the rotor it gets all
reprogrammed.

I really have no idea what is happening. Again I looked up the mantis i2c commands
and all diseqc ones that are sent look correct. 
Any hints are welcome.

Thanks for your help,
Simeon






      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
