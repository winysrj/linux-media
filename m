Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37411
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932526AbcLOOSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 09:18:06 -0500
Date: Thu, 15 Dec 2016 12:17:58 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg KH <greg@kroah.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161215120706.6cbed1de@vento.lan>
In-Reply-To: <20161215134438.GA28343@kroah.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
 <3043978.ViByGAdkJL@avalon>
 <20161215103734.716a0619@vento.lan>
 <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
 <20161215105716.30186ff5@vento.lan>
 <20161215134438.GA28343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg,

Em Thu, 15 Dec 2016 05:44:38 -0800
Greg KH <greg@kroah.com> escreveu:

> On Thu, Dec 15, 2016 at 10:57:16AM -0200, Mauro Carvalho Chehab wrote:
> > Em Thu, 15 Dec 2016 09:42:35 -0300
> > Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> >   
> > > Hello Mauro,
> > > 
> > > On 12/15/2016 09:37 AM, Mauro Carvalho Chehab wrote:
> > > 
> > > [snip]
> > >   
> > > > 
> > > > What happens is that omap3isp driver calls media_device_unregister()
> > > > too early. Right now, it is called at omap3isp_video_device_release(),
> > > > with happens when a driver unbind is ordered by userspace, and not after
> > > > the last usage of all /dev/video?? devices.
> > > > 
> > > > There are two possible fixes:
> > > > 
> > > > 1) at omap3isp_video_device_release(), streamoff all streams and mark
> > > > that the media device will be gone.  
> > 
> > I actually meant to say: isp_unregister_entities() here.
> >   
> > > > 
> > > > 2) instead of using video_device_release_empty for the video->video.release,
> > > > create a omap3isp_video_device_release() that will call
> > > > media_device_unregister() when destroying the last /dev/video?? devnode.
> > > >    
> > > 
> > > There's also option (3), to have a proper refcounting to make sure that
> > > the media device node is not freed until all references to it are gone.  
> > 
> > Yes, that's another alternative.
> >   
> > > I understand that's what Sakari's RFC patches do. I'll try to make some
> > > time tomorrow to test and review his patches.  
> > 
> > The biggest problem with Sakari's patches is that it starts by 
> > reverting 3 patches, and this will cause regressions on existing
> > devices.
> > 
> > Development should be incremental.  
> 
> How can reverting patches cause regressions?  If a patch that is applied
> breaks something else, it needs to be reverted, end of story.  If that
> patch happened to have fixed a different issue, that's fine, we are back
> to the original issue, it's not a "regression" at all, the patch was
> wrong in the first place.
> 
> So please, just revert them now.  That's the correct thing to do, as we
> will be back to the previous release's behavior.

The patches that Sakari want to revert are fixes. Before those patches, the
cdev logic was broken. So, it used to generate OOPS when the media
character device is removed.

So, when PCI/USB drivers gained media controller support, a regression
was introduced. Those patches fix it, as without them, unbinding
(or physically removing) PCI/USB devices cause OOPS because the cdev logic
there are broken.

What happens is that Sakari is proposing a different approach to
solve it on this 21 RFC patch series. Instead of applying his solution
on the top of upstream code, he decided to start it by removing the
regression fix patches.

Also, the way his solution was designed, every single media driver using 
the media controller needs to be modified in order for it to not cause OOPS
at device unbind. However, the series only do such changes on OMAP3
driver (and no te didn't make any tests on this series out of OMAP3). 

So, applying the entire series will very likely cause regressions
on PCI/USB drivers.

Thanks,
Mauro
