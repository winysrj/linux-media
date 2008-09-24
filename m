Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KiJkI-0000vP-Jv
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 04:04:51 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: "Markus Rechberger" <mrechberger@gmail.com>
Date: Wed, 24 Sep 2008 04:04:45 +0200
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<200809240236.15144.janne-dvb@grunau.be>
	<d9def9db0809231755g4f97bdc8r846e40476ca2cd99@mail.gmail.com>
In-Reply-To: <d9def9db0809231755g4f97bdc8r846e40476ca2cd99@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809240404.45959.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
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

On Wednesday 24 September 2008 02:55:48 Markus Rechberger wrote:
> On Wed, Sep 24, 2008 at 2:36 AM, Janne Grunau <janne-dvb@grunau.be> 
wrote:
> > I agree that it would have been nice if more developers and
> > especially Manu would have been at the DVB BOF. But more than 2/3
> > (849/1245) of the commits to drivers/media/dvb in the last 1000
> > days were done by people present at the meeting. It's not completly
> > unreasonable to treat a decision of that group as a decission of
> > the linuxtv developers.
>
> sorry to strong reply here, what commits? I respect people who wrote
> code on their own
> eg. Thierry Merle. But there are just alot commits from other people
> too. This also takes my code into account which got taken from my
> repository. My code seems to be good enough for adding other
> copyrights and hijacking the maintainership (! - em28xx-alsa
> which got copied including the existing bugs back then).
>
> Just don't make it up to those commits.

I've just counted commit to drivers/media/dvb, video/em28xx commits 
should be excluded. 

> A widely public technical 
> discussion can be done on the ML and
> this should be the way to solve that issue.

We can try to make that now based on on the second part of this mail to 
which I will reply seperately.

> 1. S2API adds another question who's going to port the multiproto
> drivers

I'm pretty sure that there are enough people to port exiting multiproto 
drivers if they are available under GPL 2.

> 2. who's going to test them, since they are already supported 
> by eg. vdr

Kaffeine supports the new API and there will be patches available for 
mythtv shortly. I'm certain we find enough users who would happily test 
DVB-S2 now. 

> 3. I know Manu is working on upcoming devices, telling him 
> to use the S2API would mean to reinvent the wheel I guess, so
> how to avoid that best.

if it is work in progress he should not need to reinvent the wheel. If 
it's already done porting the API is minor part of writing a driver and 
they will be people doing that work if the driver is available under 
GPL 2.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
