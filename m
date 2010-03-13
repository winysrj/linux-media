Return-path: <linux-media-owner@vger.kernel.org>
Received: from www84.your-server.de ([213.133.104.84]:33859 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab0CMNR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 08:17:57 -0500
Subject: Re: [patch 1/5] drivers/media/video/cx23885 needs kfifo conversion
From: Stefani Seibold <stefani@seibold.net>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
In-Reply-To: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
References: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 13 Mar 2010 13:59:26 +0100
Message-ID: <1268485166.6339.39.camel@wall-e>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 11.03.2010, 14:02 -0800 schrieb
akpm@linux-foundation.org:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> linux-next:
> 
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
> drivers/media/video/cx23885/cx23888-ir.c:597: error: implicit declaration of function 'kfifo_put'
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_rx_read':
> drivers/media/video/cx23885/cx23888-ir.c:660: error: implicit declaration of function 'kfifo_get'
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_probe':
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: assignment makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: assignment makes pointer from integer without a cast
> 

This looks fine in 2.6.33. I don't know who reverted it in linux-next.


