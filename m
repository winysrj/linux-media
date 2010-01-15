Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40419 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0AOBg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 20:36:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21: ERRORS
Date: Fri, 15 Jan 2010 02:36:25 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201001141910.o0EJARf7029441@smtp-vbr14.xs4all.nl> <4B4F7D14.7080806@freemail.hu>
In-Reply-To: <4B4F7D14.7080806@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001150236.25297.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Németh,

On Thursday 14 January 2010 21:22:44 Németh Márton wrote:
> Hans Verkuil wrote:
> > Detailed results are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> >
> > linux-2.6.32-i686: ERRORS
> >
> > /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function
> > 'cx23888_ir_irq_handler':  CC [M] 
> > /marune/build/v4l-dvb-master/v4l/cx23885-f300.o
> >
> > /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:621: error: implicit
> > declaration of function 'kfifo_in_locked'
> > /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function
> > 'cx23888_ir_rx_read': /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:688:
> > error: implicit declaration of function 'kfifo_out_locked'
> > /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function
> > 'cx23888_ir_probe': /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:1243:
> > warning: passing argument 1 of 'kfifo_alloc' makes integer from pointer
> > without a cast include/linux/kfifo.h:37: note: expected 'unsigned int'
> > but argument is of type 'struct kfifo *'
> > /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:1243: warning: passing
> > argument 3 of 'kfifo_alloc' makes pointer from integer without a cast
> > include/linux/kfifo.h:37: note: expected 'struct spinlock_t *' but
> > argument is of type 'unsigned int' make[3]: ***
> > [/marune/build/v4l-dvb-master/v4l/cx23888-ir.o] Error 1 make[3]: ***
> > Waiting for unfinished jobs....
> > make[2]: *** [_module_/marune/build/v4l-dvb-master/v4l] Error 2
> > make[2]: Leaving directory `/marune/build/trees/i686/linux-2.6.32'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/marune/build/v4l-dvb-master/v4l'
> > make: *** [all] Error 2
> 
> As I can see in the include/linux/kfifo.h (
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history
> ;f=include/linux/kfifo.h ) there is renaming of
>  - kfifo_put into kfifo_in_locked
>  - kfifo_get into kfifo_out_locked
> 
> Possible solutions would be:
> 
>  a) disable the compiling of cx23888-ir.c before 2.6.33
> 
>  b) adding something like this to v4l/compat.h:
> 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> #define kfifo_in_locked kfifo_put
> #define kfifo_out_locked kfifo_get
> #endif

I don't think that would be enough. The kfifo API has changed quite a lot in 
2.6.33. It will be difficult to handle that solely through compat.h. 
Conditional compilation based on the kernel version would probably be needed 
in the cx23888 driver itself.

-- 
Regards,

Laurent Pinchart
