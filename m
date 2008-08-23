Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KX0D5-0002QB-PQ
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 22:59:50 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: Matthias Dahl <mldvb@mortal-soul.de>
Date: Sat, 23 Aug 2008 22:58:39 +0200
References: <200808221555.26507.mldvb@mortal-soul.de>
In-Reply-To: <200808221555.26507.mldvb@mortal-soul.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808232258.40112@orion.escape-edv.de>
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

Matthias Dahl wrote:
> Hi Oliver.
> 
> I can happily report that with the following two patches applied, I haven't 
> seen a single case where the cam stopped working due to i/o errors or 
> anything like it.
> 
> The budget_av patch is basically your patch just a bit extended which I 
> thought was necessary to cover all relevant cases. Works just fine.
> 
> The dvb_ca_en50221 patch introduces the concept of slot lock that means, you 
> can either read or write to a slot but concurrent i/o on a slot is no longer 
> allowed. This case was already thought of and partly taken care of but 
> unfortunately due to the missing locking mechanism, it just made the race 
> condition harder to trigger but not impossible... especially on SMP systems 
> where this is easier to hit. That's way I introduced a mutex. I left the 
> original check in there but it actually never should get triggered anymore. 
> Right now actually, if it gets triggered, one could assume the ci/cam is in 
> an undefined state and trigger a reinit, like it's done on a few other 
> places.
> 
> Could you please apply those patches to the dvb tree and maybe get into the 
> official 2.6.27? Those bugs haven been around for quite some time now and 
> without the patches, they are not so hard to trigger.

Finally I had some time to review your patches.

budget-av:
Could you please elaborate why 
- ciintf_slot_ts_enable
- ciintf_slot_shutdown
require locking? I cannot see that.

ciintf_slot_reset:
Ok, although I doubt that it will make any difference, because the
routine will kill tuner and CI interface anyway...

ciintf_poll_slot_status:
Hm, I think my version was also correct.


dvb_ca_en50221.c:
Ok. but I need your signed-off-by for this patch.

Btw, wouldn't it be better to remove the locking stuff from budget-av.c,
and do all locking in dvb_ca_en50221.c?

Imho this would be a far better solution (only one mutex, not two).
Could you implement that?

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
