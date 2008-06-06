Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1K4fdu-0003IF-5n
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 19:22:24 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Nico Sabbi <Nicola.Sabbi@poste.it>
In-Reply-To: <200806061630.35379.Nicola.Sabbi@poste.it>
References: <200806061630.35379.Nicola.Sabbi@poste.it>
Date: Fri, 06 Jun 2008 19:22:09 +0200
Message-Id: <1212772929.15600.41.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Remote on Lifeview Trio: anyone got it working?
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

Hi,

Am Freitag, den 06.06.2008, 16:30 +0200 schrieb Nico Sabbi:
> Hi,
> did anyone get the remote controller on the Trio working?
> I found a patch from which it seems that it talks via i2c either
> at 0x0b or at 0x0e address and someone reported success,
> but it seems that no patch was applied to linuxtv's HG repository.
> 
> Can anyone who has it working post the correct patch(-es), please?
> 
> Thanks,
> 	Nico
> 

you find the patch from Eddi based on the Henry Wong MSI TV@nywhere
patch here.

http://tux.dpeddi.com/lr319sta

You might have to apply it manually, since quite old.
If so, please post an updated patch after that for others.
It is known to work.

Doing the probing of the IR chip in ir-kbd-i2c to make it responsive is
the main reason for not have been included, since it is expected not to
be accepted at mainline. 

According to Eddi and Peter on the video4linux-list on May 28 2007, the
driver has a flaw in implementing i2c remotes card specific.
Dwaine Garden with the same problem on the Kworld ATSC110 also confirmed
that it is not possible to initialize the similar behaving KS chips from
saa7134-cards.c currently. His patch version is also only off tree
available.

Sampling from gpio IRQ, what we do on recent Asus PC39 remotes, is also
not implemented yet for i2c remotes and the lack is visible in
saa7134-core.c.

Cheers,
Hermann


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
