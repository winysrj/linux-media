Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34064 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab0AOW2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 17:28:44 -0500
Subject: Re: Fix for breakage caused by kfifo backport
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4B50C639.7070402@redhat.com>
References: <1263556855.3059.10.camel@palomino.walls.org>
	 <4B50C639.7070402@redhat.com>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 17:27:51 -0500
Message-Id: <1263594471.3064.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-15 at 17:47 -0200, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > Mauro,
> > 
> > At 
> > 
> > http://linuxtv.org/hg/~awalls/cx23885-ir2
> > 
> > I have a change checked in to fix the v4l-dvb compilation breakage for
> > kernels less than 2.6.33 cause by the kfifo API change.  I have fixed
> > both the cx23885 and meye driver so they compile again for older
> > kernels.
> 
> As patches that do backports aren't applied upstream, they can't change any
> line at the upstream code. However, your patch is changing two comments:


> This means that upstream and your -hg will be different. Please, don't do that.
> If you want to touch on comments or at the upstream code, please send a separate
> patch.

Ooops.  OK, I didn't consider that.  Thanks.  I guess Douglas' change
will be the fix then.


> > All the changes in this repo are OK to PULL as is, even though I haven't
> > finished all the changes for the TeVii S470 IR  (I was planning on a
> > PULL request late this evening EST).  You can also just cherry pick the
> > one that fixes the kfifo problem if you want.
> 
> Yet, the series contains that issue I've already pointed:
> +struct cx23885_ir_input {
> ...
> +       char                    name[48];
> +       char                    phys[48];
> 

Mauro Carvalho Chehab wrote in another thread:
> >> Why are you creating a name[] and phys[] chars here? It should be using the names already
> >> defined at struct input_dev.

-ENOMEM

>From linux/include/linux/input.h:

        struct input_dev {
                const char *name;
                const char *phys;
        [...]

My previous full response is here in case it got lost:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14745

Please advise if this is still an issue, or if there is some other
storage that you were thinking about.

Regards,
Andy

