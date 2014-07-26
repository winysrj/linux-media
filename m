Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:59263 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaGZNei (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 09:34:38 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9B00KR5N1O3420@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 09:34:36 -0400 (EDT)
Date: Sat, 26 Jul 2014 10:34:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] rc-core: don't use dynamic_pr_debug for IR_dprintk()
Message-id: <20140726103432.366c0904.m.chehab@samsung.com>
In-reply-to: <53D38C14.40501@iki.fi>
References: <1406341536-14418-1-git-send-email-m.chehab@samsung.com>
 <53D38C14.40501@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 26 Jul 2014 14:08:04 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> 
> 
> On 07/26/2014 05:25 AM, Mauro Carvalho Chehab wrote:
> > The hole point of IR_dprintk() is that, once a level is
> > given at debug parameter, all enabled IR parsers will show their
> > debug messages.
> >
> > While converting it to dynamic_printk might be a good idea,
> > right now it just makes very hard to debug the drivers, as
> > one needs to both pass debug=1 or debug=2 to rc-core and
> > to use the dynamic printk to enable all the desired lines.
> 
> Did you know you could enable debugs as whole module too? Also per 
> function or source file, not only per line you seems to use.
> 
> That is basic command to enable all debugs for module rc-core
> modprobe rc-core; echo -n 'module rc-core +p' > 
> /sys/kernel/debug/dynamic_debug/control
> 
> Look also other flags than '+p' from documentation
> Documentation/dynamic-debug-howto.txt

Antti,

Yes, I'm aware of that. I'm not against using pr_debug(),
but the patch that converted from printk to pr_debug()
made a crappy job, because it didn't replace all occurrences
of IR_dprintk() with pr_debug(). Instead, it did:

#define IR_dprintk(level, foo) if (level >= debug) pr_debug(foo)

So, if you do:
	module rc-core +p > .../dynamic_debug/control

it won't work, because debug is zero.

And, if you load rc-core with debug=1, it also doesn't work.
It is the worse of both worlds.

So, the hole point is that we should either remove IR_dprintk
macro everywhere or to remove pr_debug(). I took the shortest
way, as the hole point were to make the debug useful again, for me to
be able to test some of the IR patches I merged.

Btw, in the specific case of rc-core debug, the debug flag
is used on all RC raw decoders, and not only by the core.

I think that IR_dprintk is more intuitive than pr_debug in
this particular usecase, especially since it takes a longer
time to be able to enable the "level 1" type of messages on
all 9 IR decoders, and such "level 1" type of debug activation
can't easily be scriptable, as there's no way to do something like:

module rc-core ir* +p level=1 > .../dynamic_debug/control

Regards,
Mauro
> 
> 
> > That doesn't make sense!
> >
> > So, revert to the old way, as a single line is changed,
> > and the debug parameter will now work as expected.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >   include/media/rc-core.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> > index 3047837db1cc..2c7fbca40b69 100644
> > --- a/include/media/rc-core.h
> > +++ b/include/media/rc-core.h
> > @@ -26,7 +26,7 @@ extern int rc_core_debug;
> >   #define IR_dprintk(level, fmt, ...)				\
> >   do {								\
> >   	if (rc_core_debug >= level)				\
> > -		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
> > +		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
> >   } while (0)
> >
> >   enum rc_driver_type {
> >
> 
