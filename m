Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab0BATqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 14:46:44 -0500
Message-ID: <4B672F95.5070009@redhat.com>
Date: Mon, 01 Feb 2010 17:46:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thomas Voegtle <tv@lio96.de>
CC: obi@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: Kernel Oops, dvb_dmxdev_filter_reset, bisected
References: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
In-Reply-To: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Voegtle wrote:
> 
> Hello,
> 
> yesterday I moved from 2.6.31.y to 2.6.32 and found a reproducable
> kernel oops.
> Bug is in Linus' tree, too.

Please try the two patches I sent to the ML today that fixes two potential
situations where the OOPS bug may hit.

I suspect that alevt-dvb is doing something wrong with the memory of the machine.

The more likely case happens when there's no more available memory for vmalloc(). 
In this case, this code fails:

        dvbdemux->feed = vmalloc(dvbdemux->feednum * sizeof(struct dvb_demux_feed));
        if (!dvbdemux->feed) {
                vfree(dvbdemux->filter);
                return -ENOMEM;

And the driver frees the memory. However, before the patch, it used to forget
to reset dvbdemux->filter to NULL. Later, dvb_dmx_release() is called, and it
tries to free an already freed memory, causing the OOPS.

After applying those two patches, I can't see any other potential cause
for the problem. Someone with aletv and a DVB-T signal with Teletext
(it is not my case, I am at an ISDB-T area) should now take a look on 
what's the application is doing and why aletv-dvb is exhausting the computer 
memory used by vmalloc.

> I bisected this down to:
> 
> root@scratchy:/data/kernel/linux-2.6# git bisect bad
> 1cb662a3144992259edfd3cf9f54a6b25a913a0f is first bad commit
> commit 1cb662a3144992259edfd3cf9f54a6b25a913a0f
> Author: Andreas Oberritter <obi@linuxtv.org>
> Date:   Tue Jul 14 20:28:50 2009 -0300
> 
>     V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID
> ...
> 
> 
> Reverting the patch on top of 2.6.33-rc6, I can start mplayer and alevt
> with no problems.

If reverting this patch solves the issue, then I can see 2 possible reasons
for the breakage:
	1) the behavior of the old ioctls changed a little bit for Teletext;
	2) your mplayer version has support to the new ioctls, and is doing
something different. In this case, as aletv-dvb is not prepared for the 
changes, it hits some internal bug, and it is working badly.

In any case, someone needs to dig at aletv and check what's happening there, 
identifying the root cause. So, the better is to contact aletv-dvb maintainer. 

It the error is due to (2), the fix is a patch to aletv-dvb. If it is (1),
then a regression has occurred, and a patch to the kernel is needed. For someone
to write such patch, he needs to know exactly where's the bug: e. g. what's the
difference between the previous driver response and the new broken response.

Cheers,
Mauro

