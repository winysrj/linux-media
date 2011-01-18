Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45672 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1ARU6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 15:58:32 -0500
Received: by wyb28 with SMTP id 28so68808wyb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 12:58:31 -0800 (PST)
Subject: Re: [PATCH][_COMPAT_H] git://linuxtv.org/media_build.git Legacy
 issues
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1295317361.12544.22.camel@localhost>
References: <1295305161.2162.21.camel@tvboxspy>
	 <1295317361.12544.22.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 20:49:32 +0000
Message-ID: <1295383772.2215.1.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-17 at 21:22 -0500, Andy Walls wrote: 
> On Mon, 2011-01-17 at 22:59 +0000, Malcolm Priestley wrote:
> > Clean up legacy issues for error free build on Kernel 2.6.37.
> > 
> > Today while testing on Kernel 2.6.35 latest tarball throws error with 
> > alloc_ordered_workqueue undefined on Kernels less than 2.6.37. defined back to 
> > create_singlethread_workqueue.
> > 
> > Please test on other kernel versions.
> >
> > Tested-on 2.6.35/37 by: Malcolm Priestley <tvboxspy@gmail.com>
> > 

> >  
> > +#define alloc_ordered_workqueue(a,b) create_singlethread_workqueue(a)
> 
> That will get cx18 to compile.  However, I can tell you without testing,
> the latest cx18 driver could badly affect system event processing
> performance on older kernels.
> 
> This is because another change happened at the same time as the change
> to call alloc_ordered_workqueue().  A kernel version before that, CMWQ
> was added to the kernel, so there was no longer a need for the
> cx18_out_work workqueue.  So now the cx18_out_work workqueue has been
> removed from the cx18 driver.
> 
> In the older kernels without CMWQ and without the cx18_out_work
> workqueue, outgoing cx18 buffer work will get queued to the [keventd/M]
> kernel threads.  Unrelated system work being processed by [keventd/M]
> threads will regularly find itself *waiting for the CX23418 hardware* to
> respond to firmware commands.
> 
> It would be better to not allow the newest cx18 driver version to
> compile on older kernels.

Yes, after review, it would be wise to disable the cx18 driver.

However, there are more problems with the media_build today on all
kernels.

For now the patch is withdrawn. 

Regards

malcolm

