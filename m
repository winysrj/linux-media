Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50279 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbeC0LbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 07:31:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH 08/30] media: v4l2-ioctl: fix some "too small" warnings
Date: Tue, 27 Mar 2018 14:31:03 +0300
Message-ID: <152219071.bcR9fVCFyQ@avalon>
In-Reply-To: <20180326172808.1271b10b@vento.lan>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com> <2278589.Q4kJOvEtWm@avalon> <20180326172808.1271b10b@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday, 26 March 2018 23:28:55 EEST Mauro Carvalho Chehab wrote:
> Em Mon, 26 Mar 2018 21:47:33 +0300 Laurent Pinchart escreveu:
> > On Monday, 26 March 2018 13:08:16 EEST Mauro Carvalho Chehab wrote:
> > > Em Fri, 23 Mar 2018 23:53:56 +0200 Sakari Ailus escreveu:
> > > > On Fri, Mar 23, 2018 at 07:56:54AM -0400, Mauro Carvalho Chehab wrote:
> > > >> While the code there is right, it produces three false positives:
> > > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error:
> > > >> 	copy_from_user() 'parg' too small (128 vs 16383)
> > > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error:
> > > >> 	copy_from_user() 'parg' too small (128 vs 16383)
> > > >> 	drivers/media/v4l2-core/v4l2-ioctl.c:2876 video_usercopy() error:
> > > >> 	memset() 'parg' too small (128 vs 16383)> >
> > > >> 
> > > >> Store the ioctl size on a cache var, in order to suppress those.
> > > > 
> > > > I have to say I'm not a big fan of changing perfectly fine code in
> > > > order
> > > > to please static analysers.
> > > 
> > > Well, there's a side effect of this patch: it allows gcc to better
> > > 
> > > optimize the text size, with is good:
> > >    text	   data	    bss	    dec	    hex	filename
> > >   
> > >   34538	   2320	      0	  36858
> > > 
> > > 8ffa	old/drivers/media/v4l2-core/v4l2-ioctl.o 34490	   2320	      0
> > > 36810	   8fca	new/drivers/media/v4l2-core/v4l2-ioctl.o
> > > 
> > > > What's this, smatch? I wonder if it could be fixed
> > > > instead of changing the code. That'd be presumably a lot more work
> > > > though.
> > > 
> > > Yes, the warnings came from smatch. No idea how easy/hard would be to
> > > change it.
> > > 
> > > > On naming --- "size" is rather more generic, but it's not a long
> > > > function
> > > > either. I'd be a bit more specific, e.g. ioc_size or arg_size.
> > > 
> > > Agreed.
> > > 
> > > I'll add the enclosed patch changing it to ioc_size.
> > > 
> > > 
> > > Thanks,
> > > Mauro
> > > 
> > > [PATCH] media: v4l2-ioctl: rename a temp var that stores _IOC_SIZE(cmd)
> > > 
> > > Instead of just calling it as "size", let's name it as "ioc_size",
> > > as it reflects better its contents.
> > > 
> > > As this is constant along the function, also mark it as const.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > 
> > I would have expected a v2 of the original patch, but it seems you pushed
> > it to the public master branch before giving anyone a change to review it
> > (Sakari's review came 10h after the past was posted).
> > 
> > Patches need to be reviewed before being applied, and that applies to all
> > patches, regarding of the author. Please refrain from merging future
> > patches before they get reviewed.
> 
> It shouldn't have pushed. It happened due to some script errors,
> when I was handling a request from Hans to push upstream some fixes
> for -rc7, as mentioned on IRC:
> 	https://linuxtv.org/irc/irclogger_log/v4l?date=2018-03-23,Fri

Thank you for the explanation. Bugs happen, luckily it should have less impact 
than spectre or meltdown :-)

> As I said there:
> 
> "If someone finds an issue on the warning fixes, I can revert or apply a
> fixup I really hate when things like that happens :-("

-- 
Regards,

Laurent Pinchart
