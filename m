Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42215
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1761155AbcLPLS6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 06:18:58 -0500
Date: Fri, 16 Dec 2016 09:18:50 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161216091850.688dd863@vento.lan>
In-Reply-To: <2965200.xcWXyJedNO@avalon>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
        <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
        <20161215105716.30186ff5@vento.lan>
        <2965200.xcWXyJedNO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Em Thu, 15 Dec 2016 16:04:51 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

We have now two threads discussing the same subject, which is bad, as
we'll end repeating the same arguments on different threads...

Let's use the "[PATCH RFC 00/21]" for those discussions, as it seems we're
reaching to somewhere there.

> Even if you're not entirely convinced by the reasons 
> explained in this mail thread, remember that we will need sooner or later to 
> implement support for media graph update at runtime. Refcounting will be 
> needed, let's design it in the cleanest possible way.

As I said, I'm not against using some other approach and even
adding refcounting to each graph object.

What I am against is on a patchset that starts by breaking 
the USB drivers that use the media controller.

Btw, I'm starting to suspect that getting rid of devm_*alloc()
on OMAP3, as proposed by the 00/21 thread is addressing a symptom of
the problem and not a cause, and that using get_device()/put_device()
may help fixing such issues. See Hans comments on that thread.

Thanks,
Mauro
