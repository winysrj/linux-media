Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KXKMD-0005IY-Qw
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 20:30:34 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: Oliver Endriss <o.endriss@gmx.de>
Date: Sun, 24 Aug 2008 20:30:21 +0200
References: <200808221555.26507.mldvb@mortal-soul.de>
	<200808232258.40112@orion.escape-edv.de>
In-Reply-To: <200808232258.40112@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808242030.24060.mldvb@mortal-soul.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] budget_av / dvb_ca_en50221: fixes ci/cam
	handling especially on SMP machines
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

Hello Oliver.

On Saturday 23 August 2008 22:58:39 Oliver Endriss wrote:

> Finally I had some time to review your patches.

No problem. I am currently short on time either so I know what it's like. :-)

> budget-av:
> Could you please elaborate why
> - ciintf_slot_ts_enable
> - ciintf_slot_shutdown
> require locking? I cannot see that.

The thought behind that was to make it impossible that any of all the ciintf 
functions could interfere with each other and thus possibly get the ci intf 
in an undefined state. So to prevent that only one one of them is allowed to 
be active at any given time. But you are right one could have left those out 
of there... sorry, my fault.

> ciintf_slot_reset:
> Ok, although I doubt that it will make any difference, because the
> routine will kill tuner and CI interface anyway...

Basically, see above. :-) Nevertheless I still think we should make absolutely 
certain that nothing interferes with the reset function because otherwise we 
may end up with an inoperational ci system just like the issues I had. So 
having the mutex in there won't hurt at the very least.

> ciintf_poll_slot_status:
> Hm, I think my version was also correct.

Same applies here. I guess I was just too overly cautious trying to get rid of 
those problems. The only reason I saw here was that slot_status might have 
gotten changed when the mutex was released early. But that clearly shouldn't 
cause any harm either. Man, I guess was asleep while doing those. That's 
already kinda embarrassing...

> Btw, wouldn't it be better to remove the locking stuff from budget-av.c,
> and do all locking in dvb_ca_en50221.c?

That was exactly what I was working on before I got your patch but as your 
patch seemed to work fine initially I put that on hold and later just started 
from scratch and only put the locks in [read|write]_data because then I knew 
what was causing the trouble.

> Imho this would be a far better solution (only one mutex, not two).
> Could you implement that?

Actually I wanted to work on it today but I am dealing with some health issues 
so I didn't get around to it. I try to get it done in the next few days. So 
with some extra days for testing, hopefully I will have something next 
weekend.

So long,
matthias.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
