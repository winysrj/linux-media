Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40980 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3JMLQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 07:16:31 -0400
Date: Sun, 13 Oct 2013 12:16:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gianluca Gennari <gennarone@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media/i2c: ths8200: fix build failure with gcc 4.5.4
Message-ID: <20131013111613.GC25034@n2100.arm.linux.org.uk>
References: <20131013101333.GA25034@n2100.arm.linux.org.uk> <525A7797.6000605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525A7797.6000605@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 13, 2013 at 12:36:07PM +0200, Gianluca Gennari wrote:
> Il 13/10/2013 12:13, Russell King - ARM Linux ha scritto:
> > v3.12-rc fails to build with this error:
> > 
> > drivers/media/i2c/ths8200.c:49:2: error: unknown field 'bt' specified in initializer
> > drivers/media/i2c/ths8200.c:50:3: error: field name not in record or union initializer
> > drivers/media/i2c/ths8200.c:50:3: error: (near initialization for 'ths8200_timings_cap.reserved')
> > drivers/media/i2c/ths8200.c:51:3: error: field name not in record or union initializer
> > drivers/media/i2c/ths8200.c:51:3: error: (near initialization for 'ths8200_timings_cap.reserved')
> > ...
> > 
> > with gcc 4.5.4.  This error was not detected in builds prior to v3.12-rc.
> > This patch fixes this.
> 
> Hi Russel,
> this error is already fixed by this patch:
> 
> https://patchwork.linuxtv.org/patch/20002/
> 
> that has been already accepted and is queued for kernel 3.12.

It would be a good idea to have the comment updated - given that gcc 4.5.4
also has a problem, it's not only a problem for gcc < 4.4.6 as that patch
claims.
