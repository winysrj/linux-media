Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 31 Dec 2008 09:13:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>, Klaus Schmidinger
	<Klaus.Schmidinger@cadsoft.de>
Message-ID: <20081231091321.55035a64@pedra.chehab.org>
In-Reply-To: <1230219306.2336.25.camel@pc10.localdom.local>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de> <494FC15C.6020400@gmx.de>
	<495355F1.8020406@helmutauer.de>
	<1230219306.2336.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On Thu, 25 Dec 2008 16:35:05 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi,
> 
> Am Donnerstag, den 25.12.2008, 10:44 +0100 schrieb Helmut Auer:
> > Hello Udo
> > > After some insights to S2API interface, this looks even better to me:
> > >
> > > properties.num = 1;
> > > properties.props[0].cmd = DTV_DELIVERY_SYSTEM;
> > > properties.props[0].u.data = SYS_DVBS2;
> > > if (ioctl(d, FE_CAP_SET_PROPERTY, &properties) >= 0) {
> > >      // has S2 capability
> > > }
> > >
> > > A generic frontend test function that delivers the necessary S2 
> > > capability information, and many other capabilities too. And there are a 
> > > lot more delivery systems that seem to be hard to detect, so a query 
> > > function 'can do SYS_XXXX' seems necessary anyway.
> > >
> > >
> > >   
> > That's a good approach, but I doubt that anyone takes care of it.
> > This mailing list is like WOM (Write only Memory) when you post patches 
> > or make suggestions :(
> > 
> 
> if I get the status right for this one, we have from Klaus a fully
> qualified patch according to README.patches.
> 
> http://www.spinics.net/lists/linux-dvb/msg30371.html
> 
> Further we have at least an ACK from Steven and no NACK so far.
> 
> http://www.spinics.net/lists/linux-dvb/msg30817.html

After reviewing the thread, it seems that Manu also ACKed:
	http://www.spinics.net/lists/linux-dvb/msg30422.html

He only suggested to use a shorter name. 

I also prefer a shorter name, but both ways work fine. I'll let Klaus to decide
to take one of the suggested names.

IMO, "2G" Is clearer than "2ND_GEN". Also, maybe we should keep the association
with "MODULATION" at the naming. So, I vote for this name:

	FE_CAN_2G_MODULATION

> But that ACK also means that he will not forward it himself to Mauro
> through one of his development repositories by a pull request.
> 
> In this case direct mail to Mauro is requested to let him know a patch
> on the list is considered to be ready, or wait until he gets aware of
> it.

Yes, please. I generally wait for people to agree on such changes, then someone
will get the acks and commit on his tree, or reply at the thread asking me
to get the final patch.

Klaus, 

could you prepare the final patch? and send it to me, keeping the ML C/C?

---

I can't avoid to comment a small CodingStyle issue I noticed at the patch:

+        FE_CAN_2ND_GEN_MODULATION       = 0x10000000, // frontend supports "2nd generation modulation" (DVB-S2)

"//" for comments shouldn't happen, since it violates C99 syntax that it is used
on kernel. 

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
