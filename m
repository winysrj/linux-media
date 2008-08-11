Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KSNcN-0002e4-IR
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 04:58:51 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 11 Aug 2008 04:09:23 +0200
References: <341e26050808101001x6ba9c5f2i5bc48b7008d5f232@mail.gmail.com>
	<341e26050808101008k2c72448fk4921f33a93638174@mail.gmail.com>
In-Reply-To: <341e26050808101008k2c72448fk4921f33a93638174@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808110409.23646@orion.escape-edv.de>
Subject: Re: [linux-dvb] activy dvb-t ALPS tdhd1-204A support?
Reply-To: linux-dvb@linuxtv.org
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

webmaster lunastick wrote:
> Hi,
> 
> I have also a AMC 570 with 2 dvb-t tuners. (activy dvb-t model
> S26361-D1297-V300 GS2)
> (Pcb has a print: ActivyAL BS 03601790A)
> The chip is SAA7146AH. I opened the tuner tin box
> and only chip that was visible was Epcos X7251D

There should be more chips inside, maybe on the other side of the pcb.
Which chips are outside of the tin box?
Could you provide a hires picture of the board?

> Lspci gives me almost the
> same than below, I think the important part is the 5f60 adress which
> means that our cards have alps tdhd1-204a tuners. It seems that
> there is no linux support for this card type yet.

Correct.

> I also attached .inf file from the original windows installation if
> it gives any help. (I found it here
> http://forum.fujitsu-siemens.com/digitalhome/viewtopic.php?f=30&t=5622&st=0&sk=t&sd=a&start=15
> and it mentions my card)
> 
> I'd appreciate if somebody tells me if it is possible to
> create linux support with a quick patch or not.

Sorry, there is no 'quick patch'. ;-(

I could not find any useful information about this tuner.
No other card seems to use it, and I don't have this kind of hardware.

> lspci gives me this:
> 01:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>        Subsystem: Philips Semiconductors Unknown device 5f60
> ...
> I found this in the archives:
> http://linuxtv.org/pipermail/linux-dvb/2007-January/015133.html
> however my device is 5f60 where his card had 5f61
>
> I took the attached patch
> http://www.linuxtv.org/pipermail/linux-dvb/attachments/20070103/46dbb191/activy-0001.obj
> and changed all occurrences of 5f61 to 5f60.

Cannot work.

The card with subsystem id 5f61 has a Grundig tuner, which is supported.
See http://linuxtv.org/hg/v4l-dvb/rev/46fe6767b0d4

Unfortunately this will not help you.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
