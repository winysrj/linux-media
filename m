Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JzJV9-0005VK-SO
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 00:43:13 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Jelle De Loecker <skerit@kipdola.com>
In-Reply-To: <4835EF00.2030306@kipdola.com>
References: <4835EF00.2030306@kipdola.com>
Date: Fri, 23 May 2008 00:42:10 +0200
Message-Id: <1211496130.2515.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto annoying compilation error
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


Am Freitag, den 23.05.2008, 00:09 +0200 schrieb Jelle De Loecker:
> Hi again,
> 
> I've recently declared success on installing the multiproto drivers on
> LinuxMCE 0710 (kubuntu 7.10)
> After a lot of hard work, I created a guide which did it like a charm
> ( http://skerit.kipdola.com/?p=5&language=en )
> 
> My guide instructs you to use the older multiproto version, which
> makes scan work and all.
> 
> Now, I reinstalled linuxmce again, but I mistakenly installed the
> newer multiproto_plus version, like previously, nothing loaded:
> 
>         [   76.128799] saa7146: register extension 'budget_ci dvb'.
>         [   76.238955] Linux video capture interface: v2.00
>         [   76.671737] saa7146: register extension 'dvb'.
> 
> No bad, I expected it to load nothing.
> So I remove all the modules, I delete every bit of source code, I try
> to use my own guide and I get *absolutely nothing*! 
> 
>         [  192.299179] saa7146: register extension 'budget_ci dvb'.
> 
> I've rebooted so many times I've lost count! I've removed all the
> drivers again, rebooted, reinstalled, it just won't load again! 
> 
> I refuse to reinstall linuxmce just so I can install the right drivers
> from the beginning.
> 
> Does anyone have *any* idea as to why it's not working? I'm really
> getting desperate.

to give something in between totally OT.

As expected, the lame old ATI stuff (the card was not cheap:) is far
beyond to display BBC HD under, oh well, for what we are serviced.

It was totally simple to get it with quite zero BER to the dish and disk
using the thumb, and concerning CPU load for that, a 266 can do I guess.

Are there known versions of mplayer dealing with that BBC HD, or what
one would have to set for the scaling, if the incoming spits errors on a
too small display ;) (comes as 1963x1080)

Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
