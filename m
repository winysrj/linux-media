Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K9zBo-0002CZ-IK
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 11:15:22 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 11:14:46 +0200
References: <1214015056l.6292l.1l@manu-laptop>
In-Reply-To: <1214015056l.6292l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806211114.46921.ajurik@quick.cz>
Cc: abraham.manu@gmail.com
Subject: Re: [linux-dvb] How to solve the TT-S2-3200 tuning problems?
Reply-To: ajurik@quick.cz
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

I've tried to see where the problem is for some time. My opinions and results 
of some debugging work is included.

I'm ready to cooperate in debugging of this driver.

BR,

Ales

On Saturday 21 of June 2008, manu wrote:
> 	Hi all,
> there are several threads about TT-3200 not being able to lock on
> different channels depending on FEC/symbol rate/modulation.
> Now what kind of experimentation could provide enough data to solve
> them? For example would it be possible that some knowledgeable guy here
> posts:
> -datasheets/programming guide for the tuner/demod if no NDA...

Yes, such documents are under NDA, I don't have access to it.

> -post the source of a prog that could gather data when tuning to a
> given transponder.
> -or anything else that this/these persons think would improve the
> understanding of the problems.
> HTH
> Bye
> Manu, who would like to watch the final of the euro cup in HD ;-)

The point from which I've checked the driver is file stb0899_priv.h (enum 
stb0899_modcod). There are defined values for all possible 
FEC/modulation combinations. We could see that 8PSK modulations have values 
from 12 to 17 (for debugging). 

But no initial values are used for 8PSK modulation for registers csm1 to csm4 
as the stb0899_dvbs2_init_csm is called only for QPSK ( condition is and-ed 
with INRANGE(STB0899_QPSK_23, modcod, STB0899_QPSK_910) ).

I'm not sure if this is the reason of problems, but I could get lock (very 
unstable - lock is active for few minutes, than for minute or so disappeared 
and so long) after few minutes staying tuned on some 8PSK channels. 

Maybe if set some registers (don't know if csm1-csm4 is enough) to initial 
values depending on FEC/modulation it would be possible to get lock within 
seconds like it is with QPSK.

In the driver there are also some pieces of code depended to FEC/modulation, 
but only STB0899_QPSK_XXX is used for such pieces of code. Not possible to 
find STB0899_8PSK_XXX depending code. Isn't it necessary? Or such code is 
missing and the casual lock is done by hw automation? 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
