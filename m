Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+d046754b6c5b6d5ca51d+1711+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JrJvq-0007Ow-W2
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 23:33:43 +0200
Date: Wed, 30 Apr 2008 18:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080430183327.4896c2b0@gaivota>
In-Reply-To: <1209507723.3456.90.camel@pc10.localdom.local>
References: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
	<1209499089.3456.34.camel@pc10.localdom.local>
	<2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
	<1209507723.3456.90.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined with
 kernel 2.6.23.17
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

On Wed, 30 Apr 2008 00:22:03 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> 
> Am Dienstag, den 29.04.2008, 23:36 +0200 schrieb Stone:
> > Thanks for the confirmation.  Would you happen to know which file to
> > edit so that I can add such missing dependencies (ie;
> > videobuf-dma-sg)?  It seems like it should be a one line fix.  I would
> > build "all" but my machine is so slow, it really drags on.  There must
> > be an easier way.
> > 
> 
> [snip]
> >         If you enable for example saa7134 support under video you should get the
> >         missing videobuf* modules too until the build dependencies are working
> >         for saa7146 again?
> 
> Either try that or go a little back before saa7146 is moved
> to /media/video from /media/common.
> 
> It might be also already fixed or will be soon.
> The build system is quickly moving due to get some tuner bugs away
> before the 2.6.26 merge window is closed.

Sorry for the noise. We usually have some "turbulence" during the merge window,
since we are focused on make things happen at mainstream.

We've decided to keep saa7146 back on his original location. The patches were
already backported from the development tree used for those moves (-git).

So, all modules should be building fine again. If not, please report to me.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
