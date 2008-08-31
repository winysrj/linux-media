Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KZqyY-0003SC-ND
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 19:44:36 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: linux-dvb@linuxtv.org
Date: Sun, 31 Aug 2008 19:44:29 +0200
References: <200808221555.26507.mldvb@mortal-soul.de>
	<200808242030.24060.mldvb@mortal-soul.de>
	<200808242203.53675@orion.escape-edv.de>
In-Reply-To: <200808242203.53675@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808311944.29970.mldvb@mortal-soul.de>
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

Hi Oliver.

Just wanted to post a status note that I was too busy to get anything useful 
done. Next weekend should be okay though, finally.

So far I've decided to go with a rather conservative locking instead of a more 
finer grained one because in the end it'll make things easier to handle and 
won't introduce new problems. In more detail:

 - a slot is locked as long as the kernel thread is processing it or if some
   user ioctl needs access to it

 - reading won't introduce any new locks because it doesn't access the h/w
   directly and thus doesn't need locks (only works on the slot ringbuffer)

I hope that this will work out and the longer lock in the kernel thread won't 
introduce new trouble. For the underlying implementations like budget_[av|ci] 
this means they are save from concurrent accesses to one slot but concurrent 
accesses to different slots are still possible and have to be taken care of 
there. Nevertheless this is rather irrelevant at the moment because there is 
no driver using dvb_ca_en50221 yet which provides more than one slot afaik.

Ok... as soon as I have something tested and ready, I'll let you know.

So long,
matthias.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
