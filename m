Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754687AbcLPIVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 03:21:34 -0500
Date: Fri, 16 Dec 2016 10:21:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg KH <greg@kroah.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161216082124.GG16630@valkosipuli.retiisi.org.uk>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
 <3043978.ViByGAdkJL@avalon>
 <20161215103734.716a0619@vento.lan>
 <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
 <20161215105716.30186ff5@vento.lan>
 <20161215134438.GA28343@kroah.com>
 <20161215120706.6cbed1de@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215120706.6cbed1de@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Greg,

On Thu, Dec 15, 2016 at 12:17:58PM -0200, Mauro Carvalho Chehab wrote:
> Greg,
> 
> Em Thu, 15 Dec 2016 05:44:38 -0800
> Greg KH <greg@kroah.com> escreveu:
> 
> > On Thu, Dec 15, 2016 at 10:57:16AM -0200, Mauro Carvalho Chehab wrote:
> > > Em Thu, 15 Dec 2016 09:42:35 -0300
> > > Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> > >   
> > > > Hello Mauro,
> > > > 
> > > > On 12/15/2016 09:37 AM, Mauro Carvalho Chehab wrote:
> > > > 
> > > > [snip]
> > > >   
> > > > > 
> > > > > What happens is that omap3isp driver calls media_device_unregister()
> > > > > too early. Right now, it is called at omap3isp_video_device_release(),
> > > > > with happens when a driver unbind is ordered by userspace, and not after
> > > > > the last usage of all /dev/video?? devices.
> > > > > 
> > > > > There are two possible fixes:
> > > > > 
> > > > > 1) at omap3isp_video_device_release(), streamoff all streams and mark
> > > > > that the media device will be gone.  
> > > 
> > > I actually meant to say: isp_unregister_entities() here.
> > >   
> > > > > 
> > > > > 2) instead of using video_device_release_empty for the video->video.release,
> > > > > create a omap3isp_video_device_release() that will call
> > > > > media_device_unregister() when destroying the last /dev/video?? devnode.
> > > > >    
> > > > 
> > > > There's also option (3), to have a proper refcounting to make sure that
> > > > the media device node is not freed until all references to it are gone.  
> > > 
> > > Yes, that's another alternative.
> > >   
> > > > I understand that's what Sakari's RFC patches do. I'll try to make some
> > > > time tomorrow to test and review his patches.  
> > > 
> > > The biggest problem with Sakari's patches is that it starts by 
> > > reverting 3 patches, and this will cause regressions on existing
> > > devices.
> > > 
> > > Development should be incremental.  
> > 
> > How can reverting patches cause regressions?  If a patch that is applied
> > breaks something else, it needs to be reverted, end of story.  If that
> > patch happened to have fixed a different issue, that's fine, we are back
> > to the original issue, it's not a "regression" at all, the patch was
> > wrong in the first place.
> > 
> > So please, just revert them now.  That's the correct thing to do, as we
> > will be back to the previous release's behavior.
> 
> The patches that Sakari want to revert are fixes. Before those patches, the
> cdev logic was broken. So, it used to generate OOPS when the media
> character device is removed.

I'd rather call them workarounds. They cause other issues (see below the
reply) and there are unaddressed review comments. They were still applied
because there was no good solution available at the time.

<URL:http://www.spinics.net/lists/kernel/msg2281365.html>
<URL:https://www.spinics.net/lists/linux-media/msg100355.html>
<URL:https://www.spinics.net/lists/linux-media/msg100927.html>
<URL:https://www.spinics.net/lists/linux-media/msg100936.html>
<URL:https://www.spinics.net/lists/linux-media/msg100952.html>
<URL:https://www.spinics.net/lists/linux-media/msg101028.html>

At least some of the issues the patches claim to fix are really not fixed
either. They are just made slightly less likely to accidentally stumble
upon.

> 
> So, when PCI/USB drivers gained media controller support, a regression
> was introduced. Those patches fix it, as without them, unbinding
> (or physically removing) PCI/USB devices cause OOPS because the cdev logic
> there are broken.
> 
> What happens is that Sakari is proposing a different approach to
> solve it on this 21 RFC patch series. Instead of applying his solution
> on the top of upstream code, he decided to start it by removing the
> regression fix patches.

The problems always existed, we just did not pay much attention to them, for
the reason you stated above. Instead of trying to fend off user space
accessing the device through IOCTL calls (which are _not_ serialised with
releasing of the data structures the IOCTL calls operate on), one really
must make sure the device is not being accessed from the user space through
e.g. IOCTLs while its memory is being released.

On V4L2 there's a release() callback to do that, on Media controller we
still have nothing --- something that's added by my RFC patchset. And yes,
it's still RFC and requires modifications, but it's not reasonable to
outright reject it (or not to review it) on the grounds that an unagreed
Media controller core API change isn't yet implemented for all potentially
affected drivers. Existing drivers still work without API changes, with the
caveat that they do have the same object lifetime issues which they did
before.

> 
> Also, the way his solution was designed, every single media driver using 
> the media controller needs to be modified in order for it to not cause OOPS
> at device unbind. However, the series only do such changes on OMAP3
> driver (and no te didn't make any tests on this series out of OMAP3). 

I use omap3isp as an example as it's a good example: it's relatively well
written and uses sub-devices implemented by external drivers with V4L2,
Media controller and V4L2 sub-device nodes, so it exhibits most of the
issues in the problem domain. I also have the hardware so I can test it, I
understand Shuah and Laurent have one as well.

> 
> So, applying the entire series will very likely cause regressions
> on PCI/USB drivers.

It's not intended to be applied as it is. This is why it's posted as RFC.

Quoting myself (with added commit id for the third patch, full thread here):

<URL:http://www.spinics.net/lists/linux-media/msg107844.html>

> The patches are in fact on top of the current media-tree, or were when they
> were sent (v4).
> 
> The reason I'm reverting patches is that the reason why these patches were
> merged was not because they would have been a sound way forward for the
> Media controller framework, but because they partially worked around issues
> in a device being in use while it was removed.
> 
> They never were a complete fix for these problems nor I do think they could
> be extended to be such. There were also unaddressed issues in these patches
> pointed out during the review. For these reasons I'm reverting the three
> patches. In more detail:
> 
> * media: fix media devnode ioctl/syscall and unregister race
>   6f0dd24a084a
> 
> The patch clears the registered bit before performing the steps related to
> unregistering a media device, but the bit is checked only at the beginning
> of the IOCTL call. As unregistering a device and an IOCTL call on a file
> handle of that device are not serialised, nothing guarantees the IOCTL call
> will finish with the registered bit still in the same state. Serialising the
> two e.g. by using a mutex is hardly a feasible solution for this.
> 
> I may have pointed out the original problem but this is not the solution.
> 
> <URL:http://www.spinics.net/lists/linux-media/msg101295.html>
> 
> The right solution is instead to make sure the data structures related to
> the media device will not disappear while the IOCTL call is in progress (at
> least).
> 
> * media: fix use-after-free in cdev_put() when app exits after driver unbind
>   5b28dde51d0c
> 
> The patch avoids the problem of deleting a character device (cdev_del())
> after its memory has been released. The change is sound as such but the
> problem is addressed by another, a lot more simple patch in my series:
> 
> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=26fa8c1a3df5859d34cef8ef953e3a29a432a17b>
> 
> It might be possible to reasonably continue from here if the next patch to
> be reverted did not depend on this one.
> 
> * media-device: dynamically allocate struct media_devnode
>   a087ce704b80
> 
> This creates a two-way dependency between struct media_devnode and
> media_device. This is very much against the original design which clearly
> separates the two: media_devnode is entirely independent of media_device.
> 
> The original intent was that another sub-system in the kernel such as the
> V4L2 could make use of media_devnode as well and while that hasn't happened,
> perhaps the two could be merged. There simply are no other reasons to keep
> the two structs separate.
> 
> The patch is certainly a workaround, as it (partially, again) works around
> issues in timing of releasing memory and accessing it.
> 
> The proper solutions regarding the media_device and media_devnode are either
> maintain the separation or unify the two, and this patch does nor suggests
> either of these. To the contrary: it makes either of these impossible by
> design, and this reason alone is enough to revert it.
> 
> The set I'm pushing maintains the separation and leaves the option of either
> merging the two (media_device and media_devnode) or making use of
> media_devnode elsewhere open.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
