Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KVM32-0002N3-LS
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 09:54:38 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: Oliver Endriss <o.endriss@gmx.de>
Date: Tue, 19 Aug 2008 09:54:30 +0200
References: <200808121443.27020.mldvb@mortal-soul.de>
	<200808160631.23359@orion.escape-edv.de>
	<200808182226.21705.mldvb@mortal-soul.de>
In-Reply-To: <200808182226.21705.mldvb@mortal-soul.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808190954.32033.mldvb@mortal-soul.de>
Cc: linux-dvb@linuxtv.org
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

Hi Oliver.

On Monday 18 August 2008 22:26:19 I wrote:

> So far everything is looking very good- haven't had a single failure in
> almost 2 days now.

Ok... rejoiced too soon. I got the same error (write failing) this morning but 
this time (due to the proper locking in place), at least the slot reset 
worked just fine and after a few seconds, everything worked again by itself 
which _never_ worked before. So this is quite an improvement. IMHO the 
locking patch should definitely make it into the tree and properly in 2.6.27 
as well because it fixes (at least partially) a long standing bug and causes 
no harm.

I have a pretty good hunch where the remaining problem could be: en50221. I 
have put a lot of new debugging output in it and now I have to wait till it 
happens again. If I am right, we'll have to put some locking in there too. 
I'll go into more detail once I am sure that I am not seeing ghosts in the 
machine. :-)

So long,
matthias.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
