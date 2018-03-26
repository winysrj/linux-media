Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37470 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbeCZU3G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 16:29:06 -0400
Date: Mon, 26 Mar 2018 17:28:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH 08/30] media: v4l2-ioctl: fix some "too small" warnings
Message-ID: <20180326172808.1271b10b@vento.lan>
In-Reply-To: <2278589.Q4kJOvEtWm@avalon>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
        <20180323215356.3ib2ho2q7sd5z27v@kekkonen.localdomain>
        <20180326070816.26859af6@vento.lan>
        <2278589.Q4kJOvEtWm@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Mar 2018 21:47:33 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday, 26 March 2018 13:08:16 EEST Mauro Carvalho Chehab wrote:
> > Em Fri, 23 Mar 2018 23:53:56 +0200 Sakari Ailus escreveu:  
> > > On Fri, Mar 23, 2018 at 07:56:54AM -0400, Mauro Carvalho Chehab wrote:  
> > >> While the code there is right, it produces three false positives:
> > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error:
> > >> 	copy_from_user() 'parg' too small (128 vs 16383)
> > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error:
> > >> 	copy_from_user() 'parg' too small (128 vs 16383)
> > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2876 video_usercopy() error:
> > >> 	memset() 'parg' too small (128 vs 16383)> > 
> > >> Store the ioctl size on a cache var, in order to suppress those.  
> > > 
> > > I have to say I'm not a big fan of changing perfectly fine code in order
> > > to please static analysers.  
> > 
> > Well, there's a side effect of this patch: it allows gcc to better
> > optimize the text size, with is good:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >   34538	   2320	      0	  36858	  
> > 8ffa	old/drivers/media/v4l2-core/v4l2-ioctl.o 34490	   2320	      0	 
> > 36810	   8fca	new/drivers/media/v4l2-core/v4l2-ioctl.o  
> > > What's this, smatch? I wonder if it could be fixed
> > > instead of changing the code. That'd be presumably a lot more work though.  
> > 
> > Yes, the warnings came from smatch. No idea how easy/hard would be to
> > change it.
> >   
> > > On naming --- "size" is rather more generic, but it's not a long function
> > > either. I'd be a bit more specific, e.g. ioc_size or arg_size.  
> > 
> > Agreed.
> > 
> > I'll add the enclosed patch changing it to ioc_size.
> > 
> > 
> > Thanks,
> > Mauro
> > 
> > [PATCH] media: v4l2-ioctl: rename a temp var that stores _IOC_SIZE(cmd)
> > 
> > Instead of just calling it as "size", let's name it as "ioc_size",
> > as it reflects better its contents.
> > 
> > As this is constant along the function, also mark it as const.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> I would have expected a v2 of the original patch, but it seems you pushed it 
> to the public master branch before giving anyone a change to review it 
> (Sakari's review came 10h after the past was posted).
> 
> Patches need to be reviewed before being applied, and that applies to all 
> patches, regarding of the author. Please refrain from merging future patches 
> before they get reviewed.

It shouldn't have pushed. It happened due to some script errors,
when I was handling a request from Hans to push upstream some fixes
for -rc7, as mentioned on IRC:
	https://linuxtv.org/irc/irclogger_log/v4l?date=2018-03-23,Fri

As I said there:

"If someone finds an issue on the warning fixes, I can revert or apply a fixup
 I really hate when things like that happens :-("

Thanks,
Mauro
