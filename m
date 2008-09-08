Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n56.bullet.mail.sp1.yahoo.com ([98.136.44.52])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Kcmhi-0000e5-QP
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 21:47:20 +0200
Date: Mon, 8 Sep 2008 12:45:34 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48C174B0.6070409@tiscalinet.it>
MIME-Version: 1.0
Message-ID: <364203.80680.qm@web46101.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: free_beer_for_all@yahoo.com
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

Ciao,

--- On Fri, 9/5/08, Francesco Schiavarelli <kaboom@tiscalinet.it> wrote:

> Seeing how hot API discussion got lately I think it's time to write on 
> the subject.

I'm going to avoid giving an opinion, because I don't have one
to give as an outsider, other than whatever works, is good...


What I wonder, is two things.

Does DiSEqC 1.1 fit into the existing API, and is it more of
a question of hardware support (generally I've noticed 1.0 and
1.2 listed), and applications being able to handle the additional
switching (I've found an app limit of 4 positions)?

I don't know enough about the internals of DiSEqC to have any idea
what I'm talking about; I've got a 1.1 switch on order, and I have
a 1.1-able 8/1+16/1 receiver, where those appear to be incompatible
with my existing 4/1 switch.


Second, how do non-DVB-like technologies like DAB (Eureka-147) fit
into the scope of either multiproto or S2API -- or must they
remain outside of v4l-dvb?

The Wiki sez, ``some developers already have hardware using
standards unsupported by multiproto, such as ISDB-T and DMB-T/H.''
And some of us non-developers have such hardware and want to try
it with non-Windows for readily-receiveable DAB.

Or is DAB/T-DMB too different from DVB and related technologies,
that a separate development path needs to be taken outside
linux-dvb, but probably within V4L?


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
