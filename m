Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:52110 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdCILRw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 06:17:52 -0500
Message-ID: <1489058253.5218.16.camel@linux.intel.com>
Subject: Re: [PATCH] staging/atomisp: Add support for the Intel IPU v2
From: Alan Cox <alan@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: greg@kroah.com, mchehab@kernel.org, linux-media@vger.kernel.org
Date: Thu, 09 Mar 2017 11:17:33 +0000
In-Reply-To: <20170308133726.05a12c0d@vento.lan>
References: <148735051279.12479.11445229229552101143.stgit@acox1-desk1.ger.corp.intel.com>
         <20170308133726.05a12c0d@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Before moving firmware-dependent drivers out of staging, please send
the
> firmware files to linux-firmware ML.

The firmware files come with the system. They may have system dependant
components and it's also not clear that they can be put in linux-
firmware for licensing reasons. They are however available on the
device itself, and in the downloadable re-install/upgrade kit supplied
by the actual product vendor for the relevant device.

I'm working on the firmware question but it's a slow moving item 8(

> >  920 files changed, 204645 insertions(+)
> 
> Wow! that's huge!

It was quite a bit larger. I'm slowly trying to diet it, and it looks
like a lot of the code is portability indirections, or in many cases
simply unused library routines. That said the hardware does an awful
lot of things.

> > +5. The AtomISP driver includes some special IOCTLS
> > (ATOMISP_IOC_XXXX_XXXX)
> > +   that may need some cleaning up.
> 
> Those likely require upstream discussions, in order to identify if
> are 
> there any already existing ioctl set that does the same thing and/or
> if it makes sense to add new ioctls to do what's needed there.

Definitely.

> When you think that each of those I2C drivers are ready to be 
> promoted out of staging, please send them as if they're a new driver
> to
> linux-media@vger.kernel.org, as this will make the review process
> easier.

Will do - thanks

Alan
