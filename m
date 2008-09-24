Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+d37b05d399b7c5e0b58f+1858+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KiWBz-0003VV-D5
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 17:22:15 +0200
Date: Wed, 24 Sep 2008 12:21:19 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <48DA15A2.40109@gmail.com>
Message-ID: <alpine.LFD.1.10.0809240942250.28125@areia.chehab.org>
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48D9F6F3.8090501@gmail.com>
	<alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
	<48DA15A2.40109@gmail.com>
MIME-Version: 1.0
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

Manu,

On Wed, 24 Sep 2008, Manu Abraham wrote:

>> 2) My vote for S2API is final.
>>
>> It is final, because the S2API is mainly affecting
>> include/linux/dvb/frontend.h to add user-API support for new standards.
>> I prefer the user-API of S2API over the one of multiproto because of 1).
>
> After adding in diversity to frontend.h,
>
> Would you prefer to update the diversity related event on the event list
> as well ?

The decision were already taken by the group.

It should be noticed also that the public announcement took some time to 
be ready, since we all carefully reviewed it to reflect the understanding 
that the group had.

Both API's work, and people needed to choose between one of the proposals.

Each one there had enough time to read and understand each proposal, since 
the patches were available more than one week before the meeting, and
everybody were aware that the decision are scheduled to happen during LPC.

Each one voted based on their own technical analysis, on a meeting that 
took about 2:30 hours, on the day after the presentations. People had 
enough time there to discuss, explain their ideas with the help of a 
whiteboard, decide and improve the proposal.

S2API was choosen, since it was considered the better proposal for 
everybody there. None of the presents voted for Multiproto.

Now that the decision were already taken, it is not time anymore to argue 
in favor to any other proposals. We need to move ahead and finally add 
support for DVB-S2 and the remaining missing digital TV's at kernel.

Thank you and everyone else involved on adding support for the missing 
standards.

Let's move to the next step: finally add API changes and drivers for 
DVB-S2 and prepare support for the remaining missing standards.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
