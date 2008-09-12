Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n78.bullet.mail.sp1.yahoo.com ([98.136.44.42])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Ke4ok-0000L2-MH
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 11:19:57 +0200
Date: Fri, 12 Sep 2008 02:17:06 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>, urishk@yahoo.com
In-Reply-To: <247734.79799.qm@web38801.mail.mud.yahoo.com>
MIME-Version: 1.0
Message-ID: <730162.85795.qm@web46115.mail.sp1.yahoo.com>
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

--- On Thu, 9/11/08, Uri Shkolnik <urishk@yahoo.com> wrote:

> > It is from my perspective in Europe that I write,
> > 
> I'm not so sure. As I see it, if it depends on number
> of users DVB-H comes last after CMMB and ISDB-T.

Then let them add their support ;-P   I just discovered that
I should be within reception range of a (subscription) DVB-H
mux, though sticking a directional antenna out the window did
not show any signal (but also not on other previously-received
frequencies) -- but climbing a nearby hill should net me a
useful signal, maybe two.

For DAB, a simple paperclip antenna will get me one ensemble,
a second should be receivable as well, and perhaps with a good
antenna, some others may appear.

So, I can test real-world broadcasts and get the actual hands-
on experience I need to understand and be able to help --
which is more than I can for the other missing standards, as
I'm not so good with the theoretical...



> I know the TerraTec device you refer to, and theoretically
> it can be used as DAB radio receiver. The current LinuxTV
> lacks the code to support it.
[...]
> There is a open source module from Siano that enable DAB @
> Linux.

Is this something I would be able to download?  (Feel free to
mail me privately if you don't want it available to other
developers, though they could certainly fit it into a suitable
API much better than I could)

I've searched with g00gle but haven't found any source to
download.  (And if drivers under Linux for the other modes
(T-DMB, DVB-H) are available, they may help me to better
understand those modes as well)


>   The problem is that this module is not a part of DVB
> and does not communicates with DVB in any way, but it uses
> its own character devices in order to communicate with user
> space applications. It may be converted of course to
> something that uses DVB, and also be more generic.

There is another USB DAB device out there (apparently no
longer available, and if so, at an `early-adopter' price)
with kernel support.
Perhaps there's some shared functionality that can be
combined, somehow, and make easier possibly adding support
for some of the small handful of other DAB-able devices.


Anyway, if I'm able to start to play with my device and DAB
under linux, that should keep me busy and quiet for some time

thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
