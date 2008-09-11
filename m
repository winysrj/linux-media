Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Kdt97-0004me-1g
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 22:52:12 +0200
Date: Thu, 11 Sep 2008 13:51:33 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>, urishk@yahoo.com
In-Reply-To: <179729.56472.qm@web38808.mail.mud.yahoo.com>
MIME-Version: 1.0
Message-ID: <164710.35297.qm@web46108.mail.sp1.yahoo.com>
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

--- On Mon, 9/8/08, Uri Shkolnik <urishk@yahoo.com> wrote:

> First I would like to present myself (I'm new to this forum)

A hearty Welcome from my side, and I hope you have a pleasant
stay.  Please help yourself to the refreshments from the bar,
and have a kipper.  ;-)


> I don't know what should be done next, which API (and
> sub-system) should be added first, second, ... (or not at
> all?). I have my own views (CMMB getting much more audience
> than DVB-H and ISDB-T more than the DAB family). 

Of course, this will depend on your location -- in some parts
of Europe, DVB-H is available as an (subscription) option and
DAB is widespread from the provider-point-of-view.

It is from my perspective in Europe that I write, where ISDB-T
is not used, but DAB hardware is relatively difficult to find.
Still, DAB services have been widely available for a longer
time than DVB-T has been operating.


> One point regarding Siano non-DVB offering - With Michael
> Krufky's help, I'm trying to find a way to add
> Siano's non-DVB(-T) offering into the kernel's code
> base (till now we supply a proprietary sources directly to
> our customers).

When you say `customers', do you mean business customers,
for example, TerraTec, which has incorporated your device
into the Cinergy Piranha, which I have, and for which the
TerraTec-supplied 'Doze media player can sort-of successfully
play the available DAB stations?  Or do you mean, `end-users'
(fnarr) such as myself, who want to use this device under
Linux, for more than DVB-T?


Here is my biggest question, which probably could be answered
if I used a Real Web Browser.

My Internet access is mostly through a SSH connection to a text-
only web-browser on a trusted host, usually on a borrowed
connection.  So I don't have access to Javascript links, or
other non-text offerings -- and often I have no access at all,
so I've sort of adopted a UUCP-like way of `working', for some
values of `work'.


In Mr. Krufky's work, I've seen reference to Siano-provided
drivers as an alternative to those which he's painstakingly
adapted and included in the mainstream.  Unfortunately for me,
the link is to the main webpage, and from there, normal links
lead nowhere interesting.  There are plenty of Javascript links
that I can't follow.  So, I haven't found anything which might
help me to answer my further questions myself, and for that,
I must apologise.


>  Of course it will be somewhat specific code
> by the fact that it'll match Siano's chipset instead
> of be more generic.

I don't see this as a real problem, because I don't know
how to weave a generic API from the DAB/DAB+ specs that
I've read.


I was hoping to find a diagram of the demodulation process
for DAB streams, from the OFDM RF carrier (handled by the
hardware) to the mp2/AAC+ audio decoding (in Linux, handled
by a userspace software player).  Unfortunately, I could not
find anything...

Had I found something, I would ask you, if it is not obvious
from freely-available code to customers, just where in the
chain of decoding, your hardware outputs a stream.  I mean,
if I supply a channel number such as 12C (VHF), would I be
seeing the entire multiplex from which I could extract one
particular service, or can I expect something more specific?


I suspect that I would likely find that with different
devices (of the few that are available), I'd be tapping
into the demodulation-demultiplexing chain at different
points, therefore needing to be able to tweak the devices
differently appropriate to where I tap into the chain.


But then, I really don't know what I'm talking about.


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
