Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:12145 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3KDOnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:43:31 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVQ00BT1U7MPT30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Nov 2013 09:43:30 -0500 (EST)
Date: Mon, 04 Nov 2013 12:43:26 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2 11/29] uvc/lirc_serial: Fix some warnings on parisc arch
Message-id: <20131104124326.101fb7f8@samsung.com>
In-reply-to: <2429755.EyGbY6tqJF@avalon>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-12-git-send-email-m.chehab@samsung.com>
 <2429755.EyGbY6tqJF@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 04 Nov 2013 15:22:26 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Saturday 02 November 2013 11:31:19 Mauro Carvalho Chehab wrote:
> > On this arch, usec is not unsigned long. So, we need to typecast,
> > in order to remove those warnings:
> > 
> > 	drivers/media/usb/uvc/uvc_video.c: In function 'uvc_video_clock_update':
> > 	drivers/media/usb/uvc/uvc_video.c:678:2: warning: format '%lu' expects
> > argument of type 'long unsigned int', but argument 9 has type
> > '__kernel_suseconds_t' [-Wformat] drivers/staging/media/lirc/lirc_serial.c:
> > In function 'irq_handler': drivers/staging/media/lirc/lirc_serial.c:707:5:
> > warning: format '%lx' expects argument of type 'long unsigned int', but
> > argument 6 has type '__kernel_suseconds_t' [-Wformat]
> > drivers/staging/media/lirc/lirc_serial.c:707:5: warning: format '%lx'
> > expects argument of type 'long unsigned int', but argument 7 has type
> > '__kernel_suseconds_t' [-Wformat]
> > drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx'
> > expects argument of type 'long unsigned int', but argument 6 has type
> > '__kernel_suseconds_t' [-Wformat]
> > drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx'
> > expects argument of type 'long unsigned int', but argument 7 has type
> > '__kernel_suseconds_t' [-Wformat]
> > drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx'
> > expects argument of type 'long unsigned int', but argument 6 has type
> > '__kernel_suseconds_t' [-Wformat]
> > drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx'
> > expects argument of type 'long unsigned int', but argument 7 has type
> > '__kernel_suseconds_t' [-Wformat]
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I don't like this much, but I guess we won't get parisc to switch 
> __kernel_suseconds from int to unsigned long any time soon. 

No, I don't think so.

> So,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> By the way, what about defining a macro similar to the PRI* macros (from 
> inttypes.h) for kernel types ? We could then get rid of the cast.

Well, the Kernel's way is to define a type-specific printk stuff, like %zd
for size_t.

Personally, I think that the PRI* macros are a dirty hack. Adding
type-specific handlers at print* functions seems more elegant, IMHO,
but such discussions should actually happen at LKML. 

In any case, before writing this patch, I double checked if there was 
anything like that for __kernel_suseconds_t but it doesn't. The thing 
is that there aren't many places inside the kernel where a timestamp 
is printed. 

So, IMO, a typecast for timestamps cost less than reserving a new 
type-specific handler at printk.

> I expect you to apply the patch directly to your tree, please let me know if I 
> should take it in mine instead.

Yeah, I'll apply it on my tree. My plan is to have them for 3.13 (they are
already on a separate branch, at -next - although I'll rebase it due to
some comments/acks). So, it will likely be sent on a separate pull request,
after the one containing the other patches.
> 
> > ---
> >  drivers/media/usb/uvc/uvc_video.c        | 3 ++-
> >  drivers/staging/media/lirc/lirc_serial.c | 9 ++++++---
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index 3394c3432011..899cb6d1c4a4 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -680,7 +680,8 @@ void uvc_video_clock_update(struct uvc_streaming
> > *stream, stream->dev->name,
> >  		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
> >  		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
> > -		  v4l2_buf->timestamp.tv_sec, v4l2_buf->timestamp.tv_usec,
> > +		  v4l2_buf->timestamp.tv_sec,
> > +		  (unsigned long)v4l2_buf->timestamp.tv_usec,
> >  		  x1, first->host_sof, first->dev_sof,
> >  		  x2, last->host_sof, last->dev_sof, y1, y2);
> > 
> > diff --git a/drivers/staging/media/lirc/lirc_serial.c
> > b/drivers/staging/media/lirc/lirc_serial.c index af08e677b60f..7b3be2346b4b
> > 100644
> > --- a/drivers/staging/media/lirc/lirc_serial.c
> > +++ b/drivers/staging/media/lirc/lirc_serial.c
> > @@ -707,7 +707,8 @@ static irqreturn_t irq_handler(int i, void *blah)
> >  				pr_warn("ignoring spike: %d %d %lx %lx %lx %lx\n",
> >  					dcd, sense,
> >  					tv.tv_sec, lasttv.tv_sec,
> > -					tv.tv_usec, lasttv.tv_usec);
> > +					(unsigned long)tv.tv_usec,
> > +					(unsigned long)lasttv.tv_usec);
> >  				continue;
> >  			}
> > 
> > @@ -719,7 +720,8 @@ static irqreturn_t irq_handler(int i, void *blah)
> >  				pr_warn("%d %d %lx %lx %lx %lx\n",
> >  					dcd, sense,
> >  					tv.tv_sec, lasttv.tv_sec,
> > -					tv.tv_usec, lasttv.tv_usec);
> > +					(unsigned long)tv.tv_usec,
> > +					(unsigned long)lasttv.tv_usec);
> >  				data = PULSE_MASK;
> >  			} else if (deltv > 15) {
> >  				data = PULSE_MASK; /* really long time */
> > @@ -728,7 +730,8 @@ static irqreturn_t irq_handler(int i, void *blah)
> >  					pr_warn("AIEEEE: %d %d %lx %lx %lx %lx\n",
> >  						dcd, sense,
> >  						tv.tv_sec, lasttv.tv_sec,
> > -						tv.tv_usec, lasttv.tv_usec);
> > +						(unsigned long)tv.tv_usec,
> > +						(unsigned long)lasttv.tv_usec);
> >  					/*
> >  					 * detecting pulse while this
> >  					 * MUST be a space!


-- 

Cheers,
Mauro
