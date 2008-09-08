Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcnUJ-0003zQ-Cq
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 22:37:32 +0200
Message-ID: <48C58D03.8040004@gmail.com>
Date: Tue, 09 Sep 2008 00:37:23 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com
References: <364203.80680.qm@web46101.mail.sp1.yahoo.com>
In-Reply-To: <364203.80680.qm@web46101.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

barry bouwsma wrote:
> Ciao,
> 

[..]

> 
> What I wonder, is two things.
> 
> Does DiSEqC 1.1 fit into the existing API, and is it more of
> a question of hardware support (generally I've noticed 1.0 and
> 1.2 listed), and applications being able to handle the additional
> switching (I've found an app limit of 4 positions)?

Cascading is not supported by the dvb-apps, i must say. It's more of a
support from the application side.

As far as multiproto goes, the driver used alongwith it supports DiSEqC 2.0


> I don't know enough about the internals of DiSEqC to have any idea
> what I'm talking about; I've got a 1.1 switch on order, and I have
> a 1.1-able 8/1+16/1 receiver, where those appear to be incompatible
> with my existing 4/1 switch.
> 
> 
> Second, how do non-DVB-like technologies like DAB (Eureka-147) fit
> into the scope of either multiproto or S2API -- or must they
> remain outside of v4l-dvb?


There is already a kernel module called dabusb for ages.


> The Wiki sez, ``some developers already have hardware using
> standards unsupported by multiproto, such as ISDB-T and DMB-T/H.''
> And some of us non-developers have such hardware and want to try
> it with non-Windows for readily-receiveable DAB.

With some simple definitions ? What applications are used ? With regards
to ISDB-T, there was an idea to integrate the ARIB extension used in the
DVB V4 API, but then it was proven that there wasn't much use for the
same due to:

* lack of available hardware (only some mobile devices using 1 seg or
likewise were available) Of course, there was the demodulator from
Toshiba TCxxxx, the DVB V4 API which it was based on.

* most of the stuff's completely scrambled and the scrambling schemes
are not open like DVB stuff.

But still, if there's need to add support for the same into the
multiproto tree, it is quite trivial.

> Or is DAB/T-DMB too different from DVB and related technologies,
> that a separate development path needs to be taken outside
> linux-dvb, but probably within V4L?

DMB resembles quite a bit of DAB. Well, the tables for DMB-T/H is quite
different from standard DVB tables, but still you can use multiproto to
handle DMB-T/H, it's quite trivial.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
