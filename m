Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50912 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751481AbcKNN13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:27:29 -0500
Date: Mon, 14 Nov 2016 15:27:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
Message-ID: <20161114132722.GR3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161109154608.1e578f9e@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I'm replying below but let me first summarise the remaining problem area
that this patchset addresses.

The problems you and Shuah have seen and partially addressed are related to
a larger picture which is the lifetime of (mostly) memory resources related
to various objects used by as well both the Media controller and V4L2
frameworks (including videobuf2) as the drivers which make use of these
frameworks.

The Media controller and V4L2 interfaces exposed by drivers consist of
multiple devices nodes, data structures with interdependencies within the
frameworks themselves and dependencies from the driver's own data structures
towards the framework data structures. The Media device and the media graph
objects are central to the problem area as well.

So what are the issues then? Until now, we've attempted to regulate the
users' ability to access the devices at the time they're being unregistered
(and the associated memory released), but that approach does not really
scale: you have to make sure that the unregistering also will not take place
_during_ the system call --- not just in the beginning of it.

The media graph contains media graph objects, some of which are media
entities (contained in struct video_device or struct v4l2_subdev, for
instance). Media entities as graph nodes have links to other entities. In
order to implement the system calls, the drivers do parse this graph in
order to obtain information they need to obtain from it. For instance, it's
not uncommon for an implementation for video node format enumeration to
figure out which sub-device the link from that video nodes leads to. Drivers
may also have similar paths they follow.

Interrupt handling may also be taking place during the device removal during
which a number of data structures are now freed. This really does call for a
solution based on reference counting.

This leads to the conclusion that all the memory resources that could be
accessed by the drivers or the kernel frameworks must stay intact until the
last file handle to the said devices is closed. Otherwise, there is a
possibility of accessing released memory.

Right now in a lot of the cases, such as for video device and sub-device
nodes, we do release the memory when a device (as in struct device) is being
unregistered. There simply is in the current mainline kernel a way to do
this in a safe way. Drivers do use devm_() family of functions to allocate
the memory of the media graph object and their internal data structures.

With this patchset:

- The media_device which again contains the media_devnode is allocated
  dynamically. The lifetime of the media device --- and the media graph
  objects it contains --- is bound to device nodes that are bound to the
  media device (video and sub-device nodes) as well as open file handles.

- Care is taken that the unregistration process and releasing memory happens
  in the right order. This was not always the case previously.

- The driver remains responsible for the memory of the video and sub-device
  nodes. However, now the Media controller provides a convenient callback to
  the driver to release any memory resources when the time has come to do
  so. This takes place just before the media device memory is released.

- Drivers that do not strictly need to be removable require no changes. The
  benefits of this set become tangible for any driver by changing how the
  driver allocates memory for the data structures. Ideally at least
  drivers for hot-removable devices should be converted.

In order to make the current drivers to behave well it is necessary to make
changes to how memory is allocated in the drivers. If you look at the sample
patches that are part of the set for the omap3isp driver, you'll find that
around 95% of the changes are related to removing the user of devm_() family
of functions instead of Media controller API changes. In this regard, the
approach taken here requires very little if any additional overhead.

On Wed, Nov 09, 2016 at 03:46:08PM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 9 Nov 2016 10:00:58 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
> > > Maybe we can get the Media Device Allocator API work in and then we can
> > > get your RFC series in after that. Here is what I propose:
> > > 
> > > - Keep the fixes in 4.9
> 
> Fixes should always be kept. Reverting a fix is not an option.
> Instead, do incremental patches on the top of it.
> 
> > > - Get Media Device Allocator API patches into 4.9.  
> > 
> > I meant 4.10 not 4.9
> > 
> > > - snd-usb-auido work go into 4.10
> 
> Sounds like a plan.
> 
> > > Then your RFC series could go in. I am looking at the RFC series and that
> > > the drivers need to change as well, so this RFC work could take longer.
> > > Since we have to make media_device sharable, it is necessary to have a
> > > global list approach Media Device Allocator API takes. So it is possible
> > > for your RFC series to go on top of the Media Device Allocator API.
> 
> Firstly, the RFC series should be converted into something that can
> be applicable upstream, e. g.:
> 
> - doing the changes over the top of upstream, instead of needing to
>   revert patches;

The patches are in fact on top of the current media-tree, or were when they
were sent (v4).

The reason I'm reverting patches is that the reason why these patches were
merged was not because they would have been a sound way forward for the
Media controller framework, but because they partially worked around issues
in a device being in use while it was removed.

They never were a complete fix for these problems nor I do think they could
be extended to be such. There were also unaddressed issues in these patches
pointed out during the review. For these reasons I'm reverting the three
patches. In more detail:

* media: fix media devnode ioctl/syscall and unregister race
  6f0dd24a084a

The patch clears the registered bit before performing the steps related to
unregistering a media device, but the bit is checked only at the beginning
of the IOCTL call. As unregistering a device and an IOCTL call on a file
handle of that device are not serialised, nothing guarantees the IOCTL call
will finish with the registered bit still in the same state. Serialising the
two e.g. by using a mutex is hardly a feasible solution for this.

I may have pointed out the original problem but this is not the solution.

<URL:http://www.spinics.net/lists/linux-media/msg101295.html>

The right solution is instead to make sure the data structures related to
the media device will not disappear while the IOCTL call is in progress (at
least).

* media: fix use-after-free in cdev_put() when app exits after driver unbind
  5b28dde51d0c

The patch avoids the problem of deleting a character device (cdev_del())
after its memory has been released. The change is sound as such but the
problem is addressed by another, a lot more simple patch in my series:

<URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=26fa8c1a3df5859d34cef8ef953e3a29a432a17b>

It might be possible to reasonably continue from here if the next patch to
be reverted did not depend on this one.

* media-device: dynamically allocate struct media_devnode

This creates a two-way dependency between struct media_devnode and
media_device. This is very much against the original design which clearly
separates the two: media_devnode is entirely independent of media_device.

The original intent was that another sub-system in the kernel such as the
V4L2 could make use of media_devnode as well and while that hasn't happened,
perhaps the two could be merged. There simply are no other reasons to keep
the two structs separate.

The patch is certainly a workaround, as it (partially, again) works around
issues in timing of releasing memory and accessing it.

The proper solutions regarding the media_device and media_devnode are either
maintain the separation or unify the two, and this patch does nor suggests
either of these. To the contrary: it makes either of these impossible by
design, and this reason alone is enough to revert it.

The set I'm pushing maintains the separation and leaves the option of either
merging the two (media_device and media_devnode) or making use of
media_devnode elsewhere open.

> - change all drivers as the kAPI changes;

The patchset actually adds new APIs rather than changing the OLD one --- as
the old one was simply that drivers were responsible for allocating the data
structures related to a media device. Existing drivers should continue to
work as they did before without changes.

Naturally, to get full benetifs of the changes, driver changes will be also
required (see the beginning of the message).

The set has been posted as RFC in order to get reviews. It makes no sense to
convert all the drivers and then start changing APIs, affecting all those
converted drivers.

> 
> - be git bisectable, e. g. all patches should compile and run fine
>   after each single patch, without introducing regressions.

Compilation has already been tested (on ARM) on each patch applied in order.

> 
> That probably means that the series should be tested not only on
> omap3, but also on some other device drivers.

I fully agree with that. More review, testing and changes to at least some
drivers (mostly for removable devices) will be needed before merging them,
that's for sure.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
