Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56064 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbZJ1Brn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 21:47:43 -0400
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
From: Andy Walls <awalls@radix.net>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Amerigo Wang <xiyou.wangcong@gmail.com>,
	Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Tue, 27 Oct 2009 21:49:31 -0400
Message-Id: <1256694571.3131.26.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> One thing is that the new API is not compatible with the old one. I
> had a look at the current user of the old kfifo API and it is was easy
> to adapt it to the new API. These are the files which currently use
> the kfifo API:
> 
> drivers/char/nozomi.c
> drivers/char/sonypi.c
> drivers/infiniband/hw/cxgb3/cxio_resource.c
> drivers/media/video/meye.c
> drivers/net/wireless/libertas/main.c
> drivers/platform/x86/fujitsu-laptop.c
> drivers/platform/x86/sony-laptop.c
> drivers/scsi/libiscsi.c
> drivers/scsi/libiscsi_tcp.c
> drivers/scsi/libsrp.c
> drivers/usb/host/fhci.h
> net/dccp/probe.c
> drivers/usb/serial/usb-serial.c
> drivers/usb/serial/generic.c

Here's a V4L-DVB cx23885 module change, that is on its way upstream,
that uses kfifo as is:

http://linuxtv.org/hg/v4l-dvb/rev/a2d8d3d88c6d

Do you really have to break the old API?

Regards,
Andy

