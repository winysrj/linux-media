Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TCBAO8016746
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:11:10 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TCAr4l016590
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:10:54 -0400
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200808281658.28151.jdelvare@suse.de>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<200808281658.28151.jdelvare@suse.de>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 08:09:38 -0400
Message-Id: <1220011778.3174.19.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 2008-08-28 at 16:58 +0200, Jean Delvare wrote:
> Hi Andy,

> In the specific case I am studying, there are 8 BT878 chips, so each
> one definitely can't be considered the only "high bandwith card in
> the system". And it seems to me that latency matters as much as
> bandwith here... A high latency timer on one card will hurt bus
> latency at least as much as bus banwidth as I understand it.
> 
> > Setting latency timers for a system is a balancing act between the needs
> > of individual devices and the system's need for the shared PCI bus to
> > support the maximum anticipated burst or sustained activity on the bus
> > by all the devices that could be active at once.
> 
> We agree on that. With 8 BT878 chips, the problem is that both bus
> latency and bus bandwidth are potentially problematic. So the balance
> isn't an easy one to find. Which is exactly why I am asking all these
> questions.

No it probably isn't easy.  With a static analysis (spreadheet),
assuming worst case conditions, you will likely end up with the
conclusion that the PCI bus can't handle the worst case load, so you'll
need to model with higher fidelity and different assumptions than worst
case.

Consistently meeting the real-time communications needs of the 8 BT878's
and the disks on the PCI bus could well be impossible with (the very
common) round robin arbiters.

You may find this thesis paper interesting:

http://os.inf.tu-dresden.de/papers_ps/schoenberg-phd.pdf

Which addresses the problem by proposing a different arbiter.


This, much shorter paper:

http://www.irisa.fr/manifestations/2004/wcet2004/Papers/Stohr.pdf

proposes that the Master Enable bit of devices be switched on and off to
ensure deterministic times across the bus.  (I'm not sure if I'd want to
do that though...)


Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
