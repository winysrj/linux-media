Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:65292 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab0ANUWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 15:22:49 -0500
Message-ID: <4B4F7D14.7080806@freemail.hu>
Date: Thu, 14 Jan 2010 21:22:44 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 ERRORS
References: <201001141910.o0EJARf7029441@smtp-vbr14.xs4all.nl>
In-Reply-To: <201001141910.o0EJARf7029441@smtp-vbr14.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log

> linux-2.6.32-i686: ERRORS
>
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function 'cx23888_ir_irq_handler':  CC [M]  /marune/build/v4l-dvb-master/v4l/cx23885-f300.o
>
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:621: error: implicit declaration of function 'kfifo_in_locked'
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function 'cx23888_ir_rx_read':
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:688: error: implicit declaration of function 'kfifo_out_locked'
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c: In function 'cx23888_ir_probe':
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:1243: warning: passing argument 1 of 'kfifo_alloc' makes integer from pointer without a cast
> include/linux/kfifo.h:37: note: expected 'unsigned int' but argument is of type 'struct kfifo *'
> /marune/build/v4l-dvb-master/v4l/cx23888-ir.c:1243: warning: passing argument 3 of 'kfifo_alloc' makes pointer from integer without a cast
> include/linux/kfifo.h:37: note: expected 'struct spinlock_t *' but argument is of type 'unsigned int'
> make[3]: *** [/marune/build/v4l-dvb-master/v4l/cx23888-ir.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [_module_/marune/build/v4l-dvb-master/v4l] Error 2
> make[2]: Leaving directory `/marune/build/trees/i686/linux-2.6.32'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/marune/build/v4l-dvb-master/v4l'
> make: *** [all] Error 2

As I can see in the include/linux/kfifo.h ( http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=include/linux/kfifo.h )
there is renaming of
 - kfifo_put into kfifo_in_locked
 - kfifo_get into kfifo_out_locked

Possible solutions would be:

 a) disable the compiling of cx23888-ir.c before 2.6.33

 b) adding something like this to v4l/compat.h:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
#define kfifo_in_locked kfifo_put
#define kfifo_out_locked kfifo_get
#endif

What do you think the best way would be?

Regards,

	Márton Németh
