Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55115 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0BGOpf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 09:45:35 -0500
Subject: Re: "However, if you don't want to lose your freedom, you had
 better not follow him." (Re: Videotext application crashes the kernel due
 to DVB-demux patch)
From: Andy Walls <awalls@radix.net>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Chicken Shack <chicken.shack@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <1265515083.2666.139.camel@localhost>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>
	 <1265397736.6310.98.camel@palomino.walls.org>
	 <4B6C7F1B.7080100@linuxtv.org>  <4B6C88AD.4010708@redhat.com>
	 <1265409155.2692.61.camel@brian.bconsult.de>
	 <1265411523.4064.23.camel@localhost>
	 <1265413149.2063.20.camel@brian.bconsult.de>
	 <1265415910.2558.17.camel@localhost>
	 <1265446554.1733.36.camel@brian.bconsult.de>
	 <1265515083.2666.139.camel@localhost>
Content-Type: text/plain
Date: Sun, 07 Feb 2010 09:43:32 -0500
Message-Id: <1265553812.3063.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-02-07 at 04:58 +0100, hermann pitton wrote:
> Am Samstag, den 06.02.2010, 09:55 +0100 schrieb Chicken Shack:
> > Am Samstag, den 06.02.2010, 01:25 +0100 schrieb hermann pitton:

> 3.
> Also confirmed, your 1.7.0 version did work on a latest unpatched F11
> 2.6.30 without setting the teletext pid explicitly, providing the
> information what else is around there, and next should allow switching
> through all teletext stuff with the UI I guess.
> 
> Taking the oopses now, you are likely right, that we have a backward
> compat regression here and should try to fix it.


I'm looking at this still, just not quickly.

The over-abundance of the use of the words "demux", "dmx", "dvb",
"feed", "ts", and "sec" in the dvb-core make code analysis difficult.
I'm putting the dvb-core data structures into a UML tool, so I can get
some decent class and collaboration diagrams to have a good picture of
the relationships.

I can say that the easiest fix will most likely be that in dmxdev.h:

struct dmxdev_filter {
	...
        union {
                /* list of TS and PES feeds (struct dmxdev_feed) */
                struct list_head ts;
                struct dmx_section_feed *sec;
        } feed;
	....

"feed" should no longer be a union, or that "feed.sec" should be
converted to a list as well.

It appears under certain circumstances "feed.sec" is being set to NULL,
which corrupts the "feed.ts" list head.   The "feed.ts" list head is
being properly intiialized in dvb_demux_open(), so that's not the
problem.


Regards,
Andy



> I'm at least still available for reproducing oopses ;)
> 
> And, an app, which ever, should not to be able to get all down.
> 
> Cheers,
> Hermann

