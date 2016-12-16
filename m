Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51721 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761927AbcLPQGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 11:06:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Fri, 16 Dec 2016 18:06:37 +0200
Message-ID: <2184723.57DbA5Qh8A@avalon>
In-Reply-To: <20161216091850.688dd863@vento.lan>
References: <20161214151406.20380-1-mchehab@s-opensource.com> <2965200.xcWXyJedNO@avalon> <20161216091850.688dd863@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 16 Dec 2016 09:18:50 Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 16:04:51 +0200 Laurent Pinchart escreveu:
> 
> We have now two threads discussing the same subject, which is bad, as
> we'll end repeating the same arguments on different threads...
> 
> Let's use the "[PATCH RFC 00/21]" for those discussions, as it seems we're
> reaching to somewhere there.
> 
> > Even if you're not entirely convinced by the reasons
> > explained in this mail thread, remember that we will need sooner or later
> > to implement support for media graph update at runtime. Refcounting will
> > be needed, let's design it in the cleanest possible way.
> 
> As I said, I'm not against using some other approach and even
> adding refcounting to each graph object.
> 
> What I am against is on a patchset that starts by breaking
> the USB drivers that use the media controller.

So, what you're essentially saying, is that you noticed we have a problem in 
the core when trying to add MC support to a bunch of USB driver. Instead of 
fixing the problem properly, you've merged 3 patches that work around part of 
the issue, despite negative comments received by the original authors of the 
code, and then added a bunch of code to the USB drivers that make them subject 
to the race condition. And you're then claiming that we can't revert the 
patches that we know from the start were broken because you piled additional 
patches on top of them, making the end result worse ? Sorry, I can't buy that. 
If you really insist we can also revert the series that add MC support to the 
USB drivers, but there's no way that your decision to ignore known issues can 
ever be considered as an excuse to not revert broken changes.

This discussion is over as far as I'm concerned. The 3 patches in question are 
wrong. I want the proper fixes to be merged, and we thus all need to work in 
that direction, which means reviewing them. Once we agree on what the end 
result should be we'll see whether we could possibly rework the code in a way 
that doesn't require a revert. If that's not possible, we'll revert what is 
broken. It's as simple as that. Now, let's get technical and fix this crap. If 
I had wanted a show I would have bought tickets to the circus.

> Btw, I'm starting to suspect that getting rid of devm_*alloc()
> on OMAP3, as proposed by the 00/21 thread is addressing a symptom of
> the problem and not a cause, and that using get_device()/put_device()
> may help fixing such issues. See Hans comments on that thread.

-- 
Regards,

Laurent Pinchart

