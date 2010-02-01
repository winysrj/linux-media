Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50750 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751382Ab0BAVh7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 16:37:59 -0500
Subject: Re: Kernel Oops, dvb_dmxdev_filter_reset, bisected
From: Chicken Shack <chicken.shack@gmx.de>
To: Thomas Voegtle <tv@lio96.de>
Cc: obi@linuxtv.org, mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1002012148310.9330@er-systems.de>
References: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
	 <1265052321.19005.8.camel@brian.bconsult.de>
	 <alpine.LNX.2.00.1002012148310.9330@er-systems.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 22:35:50 +0100
Message-ID: <1265060150.2653.14.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 01.02.2010, 21:50 +0100 schrieb Thomas Voegtle:
> On Mon, 1 Feb 2010, Chicken Shack wrote:
> 
> > Hi Thomas,
> >
> > thanks for reproducing that kernel oops.
> >
> > Question:
> >
> > Can you also confirm / reproduce that alevt does not follow the new TV
> > or radio channel if the new channel, tuned by dvbstream / mplayer for
> > example, is part of another transponder?
> >
> > Normal, i. e. expected behaviour can be desribed in the following
> > example:
> >
> > a. You start mplayer://ZDF, then you start alevt, and ZDF teletext
> > should be visible.
> >
> > b. You change the channel to mplayer://Das Erste.
> > Now alevt should follow the new tuning and tune one channel of the
> > transponder containing the ARD bouquet.
> >
> > But instead of that alevt hangs and cannot be finished by an ordinary
> > quit. You need _violence_ a la "killall -9 alevt" or, on the command
> > line: STRG-C as shortcut.
> >
> > Can you reproduce / confirm that, Thomas?
> 
> 
> Yes, I can confirm that. And yes, it is annoying.


Thank you, Thomas.

I think that the tasks to work on are clear now. All my hopes rest on
Andy Walls now......
To be honest I would be much happier if more people would volunteer and
perform a task splitting due to lack of time......


The thing is:
Looking at the code in vbi.c (using grep -e .....) I in fact saw a vbi
reset function call.
But this vbi reset function call does not touch the DVB demux device
(which would mean f. ex. to set the teletext pid to zero and stuff like
that.....).

Proof (which you can easily find out if you have an analogue bttv card).

The hangup does not happen if you use alevt-dvb in analogue mode.
It only happens because the DVB implementation needs a little bit of
care by a highly experienced and competent person.

The vbi reset function or even some similar system call needs to be
extended or added to fulfil DVB needs.

The DVB implementation is reduced to demux filter release (start) and
demux filter stop. Reset does not seem to exist, and that's why the
proggy does not follow the new channel as part of a different
transponder if a new channel is being tuned by some external application
like kaffeine or mplayer.....


> thanks,
> 
> Thoams


My turn so say Thank you

CS


> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


