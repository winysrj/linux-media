Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51088 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0CMRvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 12:51:05 -0500
Subject: Re: [patch 1/5] drivers/media/video/cx23885 needs kfifo conversion
From: Andy Walls <awalls@radix.net>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	Stefani Seibold <stefani@seibold.net>
In-Reply-To: <1268485166.6339.39.camel@wall-e>
References: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
	 <1268485166.6339.39.camel@wall-e>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 12:50:42 -0500
Message-Id: <1268502642.3084.52.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-03-13 at 13:59 +0100, Stefani Seibold wrote:
> Am Donnerstag, den 11.03.2010, 14:02 -0800 schrieb
> akpm@linux-foundation.org:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > linux-next:
> > 
> > drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
> > drivers/media/video/cx23885/cx23888-ir.c:597: error: implicit declaration of function 'kfifo_put'
> > drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_rx_read':
> > drivers/media/video/cx23885/cx23888-ir.c:660: error: implicit declaration of function 'kfifo_get'
> > drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_probe':
> > drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> > drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> > drivers/media/video/cx23885/cx23888-ir.c:1172: warning: assignment makes pointer from integer without a cast
> > drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> > drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> > drivers/media/video/cx23885/cx23888-ir.c:1178: warning: assignment makes pointer from integer without a cast
> > 
> 
> This looks fine in 2.6.33. I don't know who reverted it in linux-next.
> 

Things also look OK at the v4l-dvb GIT repositories:

http://git.linuxtv.org/v4l-dvb.git?a=blob;f=drivers/media/video/cx23885/cx23888-ir.c;hb=HEAD

http://git.linuxtv.org/linux-2.6.git?a=blob;f=drivers/media/video/cx23885/cx23888-ir.c;hb=HEAD

As far as I recall, this file should not have changed since the original
changes for the new kfifo implementation.

Regards,
Andy


