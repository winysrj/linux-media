Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KUFhy-0004f7-UH
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 08:56:20 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: linux-dvb@linuxtv.org
Date: Sat, 16 Aug 2008 08:56:12 +0200
References: <200808121443.27020.mldvb@mortal-soul.de>
	<200808160631.23359@orion.escape-edv.de>
In-Reply-To: <200808160631.23359@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808160856.13167.mldvb@mortal-soul.de>
Subject: Re: [linux-dvb] Possible SMP problems with budget_av/saa7134
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

Hello Oliver,

and thanks for your reply.

On Saturday 16 August 2008 06:31:21 Oliver Endriss wrote:

> Please test the attached patch (untested because I do not own this kind
> of hardware). Please save your work before loading the patched driver,
> since a locking bug might crash your machine...

I will give it a try and let you know as soon as I have some results. Testing 
changes or getting more debugging output (see below) is quite time consuming 
because you have no idea how long it takes till you'll hit the problem again. 
Yesterday it happened several times across the day- and unfortunately over 
night (when I was testing changes in the en50221 implementation), everything 
was rock stable. :-(

By the way, I spent the last few days hacking on dvb_ca_en50221.c, putting a 
lot more debugging output in it and thus trying to narrow the problem down. 
There are a few corner cases which IMHO could have been triggered and have 
caused this. I'll try to confirm or disprove those and according to this try 
to fix those if necessary.

One more thing: the en50221 "driver" assumes that setting bit 7 of the command 
register enables/disables irq signaling. According to the en50221 standard 
those bits are reserved and shall be always zero. Do you know where I can 
find more informations on this...?

Thanks again and have a nice weekend,
Matthias

PS. For now, I am keepking this off the vdr mailing list because I've reviewed
    the vdr cicam handling code and everything looks fine- except for maybe
    the error handling which could be a bit more flexible. I guess due to the
    continued cam monitoring implemented in vdr 1.5.x, the bug just happens to
    be triggered more easily/frequently.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
