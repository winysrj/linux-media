Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42631
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932480AbcKVNIM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 08:08:12 -0500
Date: Tue, 22 Nov 2016 11:08:06 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] [media] serial_ir: port lirc_serial to rc-core
Message-ID: <20161122110806.29f8fe77@vento.lan>
In-Reply-To: <20161121215327.GA3886@gofer.mess.org>
References: <1478905987-23019-1-git-send-email-sean@mess.org>
        <20161121142808.1365a96e@vento.lan>
        <20161121215327.GA3886@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Nov 2016 21:53:27 +0000
Sean Young <sean@mess.org> escreveu:

> On Mon, Nov 21, 2016 at 02:28:08PM -0200, Mauro Carvalho Chehab wrote:
> > Em Fri, 11 Nov 2016 23:13:06 +0000
> > Sean Young <sean@mess.org> escreveu:
> >   
> > > Tested with a homebrew serial ir. Remove last remmants of the nslu2
> > > which could not be enabled.  
> > 
> > Thanks for this! It is really nice to see any efforts on moving the drivers
> > under staging.   
> 
> Unfortunately some of the hardware is hard to track down. I've got my eyes
> on ebay, but if anyone can help me out with:
> 
> - Sasem OnAir VFD/IR (Dign HV5 or D.Vine 5 HTPC IR/VFD) (lirc_sasem)
> - lirc parallel (lirc_parallel)
> - Original iMon SoundGraph IR receiver/display (lirc_imon)
> 
> I would appreciate it and I can work on getting the drivers out of staging.

Yeah, getting some legacy hardware is not easy. Well, if we fail
getting them, then maybe it is time to just remove the driver.
For example, finding a computer nowadays with a parallel port is
very difficult. So, I'd say that lirc_parallel is a likely
candidate to be removed, except if some developer gets one in
hands and still has some machine with parallel port on it.

> 
> > IMHO, it is almost ready for upstream merge, but I would prefer if you
> > could do all changes, in incremental patches, on the driver at
> > drivers/staging/media/lirc/lirc_serial.c, doing the module rename
> > (together with Kconfig/Makefile/MAINTAINERS change) on the last one.   
> 
> That is better, I've reworked it.

Thanks! Yeah, it looked nice after your refactor! I applied one
small checkpatch fixup, solving a few issues there, before moving
it out of staging. Please check if everything is still ok after that.

Thanks,
Mauro
