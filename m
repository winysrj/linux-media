Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43660 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932329AbcCQJaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 05:30:18 -0400
Date: Thu, 17 Mar 2016 11:30:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 06/22] media: Media Controller enable/disable source
 handler API
Message-ID: <20160317093008.GZ11084@valkosipuli.retiisi.org.uk>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <2d8b035ec723346dfeed5db859aba67738e049cc.1455233153.git.shuahkh@osg.samsung.com>
 <20160310073500.GK11084@valkosipuli.retiisi.org.uk>
 <56E184E7.80603@osg.samsung.com>
 <20160313201131.GN11084@valkosipuli.retiisi.org.uk>
 <56E6D724.6080909@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E6D724.6080909@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

I see that the patches have been merged to media-tree.git master and
subsequently a pull request has been sent to Linus including them, but the
remaining issues still need to be fixed. Some matters should be discussed
further on the list.

On Mon, Mar 14, 2016 at 09:22:12AM -0600, Shuah Khan wrote:
> On 03/13/2016 02:11 PM, Sakari Ailus wrote:
> > Hi Shuah,
> > 
> > On Thu, Mar 10, 2016 at 07:29:59AM -0700, Shuah Khan wrote:
> >> On 03/10/2016 12:35 AM, Sakari Ailus wrote:
> >>> Hi Shuah,
> >>>
> >>> On Thu, Feb 11, 2016 at 04:41:22PM -0700, Shuah Khan wrote:
> >>>> Add new fields to struct media_device to add enable_source, and
> >>>> disable_source handlers, and source_priv to stash driver private
> >>>> data that is used to run these handlers. The enable_source handler
> >>>> finds source entity for the passed in entity and checks if it is
> >>>> available. When link is found, it activates it. Disable source
> >>>> handler deactivates the link.
> >>>>
> >>>> Bridge driver is expected to implement and set these handlers.
> >>>>
> >>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >>>> ---
> >>>>  include/media/media-device.h | 30 ++++++++++++++++++++++++++++++
> >>>>  1 file changed, 30 insertions(+)
> >>>>
> >>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >>>> index 075a482..1a04644 100644
> >>>> --- a/include/media/media-device.h
> >>>> +++ b/include/media/media-device.h
> >>>> @@ -302,6 +302,11 @@ struct media_entity_notify {
> >>>>   * @entity_notify: List of registered entity_notify callbacks
> >>>>   * @lock:	Entities list lock
> >>>>   * @graph_mutex: Entities graph operation lock
> >>>> + *
> >>>> + * @source_priv: Driver Private data for enable/disable source handlers
> >>>> + * @enable_source: Enable Source Handler function pointer
> >>>> + * @disable_source: Disable Source Handler function pointer
> >>>> + *
> >>>>   * @link_notify: Link state change notification callback
> >>>>   *
> >>>>   * This structure represents an abstract high-level media device. It allows easy
> >>>> @@ -313,6 +318,26 @@ struct media_entity_notify {
> >>>>   *
> >>>>   * @model is a descriptive model name exported through sysfs. It doesn't have to
> >>>>   * be unique.
> >>>> + *
> >>>> + * @enable_source is a handler to find source entity for the
> >>>> + * sink entity  and activate the link between them if source
> >>>> + * entity is free. Drivers should call this handler before
> >>>> + * accessing the source.
> >>>> + *
> >>>> + * @disable_source is a handler to find source entity for the
> >>>> + * sink entity  and deactivate the link between them. Drivers
> >>>> + * should call this handler to release the source.
> >>>> + *
> >>>
> >>> Is there a particular reason you're not simply (de)activating the link, but
> >>> instead add a new callback?
> >>
> >> These two handlers are separate for a couple of reasons:
> >>
> >> 1. Explicit and symmetric API is easier to use and maintain.
> >>    Similar what we do in other cases, register/unregister
> >>    get/put etc.
> > 
> > Link state is set explicitly (enabled or disabled). This is certainly not a
> > reason to create a redundant API for link setup.
> > 
> >> 2. This is more important. Disable handler makes sure the
> >>    owner is releasing the resource. Otherwise, when some
> >>    other application does enable, the owner could loose
> >>    the resource, if enable and disable are the same.
> >>
> >>    e.g: Video app is holding the resource, DVB app does
> >>    enable. Disable handler makes sure Video/owner  is the one
> >>    that is asking to do the release.
> > 
> > Based on the later patches in this set, the enable_source() callback of the 
> > au0828 driver performs three things:
> > 
> > - Find the source entity,
> > - Enable the link from some au0828 entity to the source and
> > - Start the pipeline that begins from the I/O device node. The pipe object
> >   is embedded in struct video_device.
> > 
> > disable_source() undoes this in reverse order.
> > 
> > That's in the au0828 driver and rightly so.
> > 
> > Then it gets murkier. enable_source() and disable_source() callbacks
> > (through a few turns) will get called from v4l2-ioctl.c functions
> > v4l_querycap, v4l_s_fmt, v4l_s_frequency, v4l_s_std and v4l_querystd. This
> > is also performed in VB2 core vb2_core_streamon() function.
> > 
> > I certainly have no objections when it comes to blocking other processes
> > from setting the format when a process holding a file handle to a device has
> > e.g. set the format. The implementation is another matter.
> > 
> > What particularly does concern me in this patchset is:
> > 
> > - struct media_pipe is intended to be allocated by drivers embedded in
> >   another struct holding information the driver needs related to the
> >   pipeline. Moving this struct to struct video_device prevents this, which
> >   translates to v4l_enable_media_source() and v4l_disable_media_source()
> >   functions the patchset adds being specific to the au0828 driver. They
> >   should be part of that driver, and may not be part of the V4L2 core.
> >   struct media_pipe may not be added to struct video_device for the same
> >   reason.
> 
> This media_pipe is associated with struct video_device though. I don't
> understand your concern. I am viewing this media_pipe as part of the
> registered video_device. video_device struct is in the au0828 device

That is another problem --- this approach excludes pipelines with multiple
video nodes in them. It's not uncommon to have more than one video device in
a pipeline nowadays, e.g. omap3isp driver has that in memory-to-memory
processing.

Other ISPs also have more than one memory output in a single pipeline, that
omap3isp driver could technically support as well.

If you look at the struct media_pipeline, it was an empty struct until a
month or so ago. Drivers embed this struct in their own data structures.

> and gets registered as a whole including the media_pipe 
> 
> > 
> > - The IOCTL handlers in v4l2-ioctl.c already call driver-settable callbacks
> >   before this set. It looks like redundant callbacks are added there as
> >   ell. The same appears to be true for the VB2 callback. Could you use the
> >   existing callbacks instead of creating new ones?
> 
> If I understand correctly, you are suggesting that the calls to enable
> and disable source should be made from the au0828 hooks. e.g vidioc_s_std()
> 
> Calling them from v4l2-core makes it generic and works on all drivers
> without driver changes. That is the rationale for making adding v4l2
> common interfaces v4l_enable_media_source() and v4l_disable_media_source()
> 
> > 
> > As a short term solution, I propose moving the code to the au0828 driver.
> > Once it is there, we can see whether it could be made more generic if there
> > is a need for it elsewhere. I believe so. Support atomic pipeline
> > configuration and startup is a generic problem that requires a generic
> > solution: we should have a way to construct a pipeline and prevent other
> > users from messing with it before it's started. But as currently implemented
> > by this patchset, it is very specific to the au0828 driver and as such may
> > not be added to the V4L2 or the MC frameworks.
> > 
> 
> The enable and disable handlers themselves are for a good reason. These are
> handlers that get called from dvb-core, v4l2-core via the common interfaces.
> These also get called from sound driver from the media_device. All of this is
> generic. Could you please elaborate on which part is au0828 driver specific
> other than the media_pipe in struct video_device?

As far as I understand, you intend to prevent changing e.g. format or input
after a user holding e.g. a file handle to a video node open by other
processes. The au0828 driver does this by configuring the links and starting
the pipeline from the driver itself.

That solution does solve the problem in some special cases (I presume au0828
driver at least), but how about drivers that support the V4L2 sub-device
API? If you start the pipeline based on VIDIOC_S_FMT, for instance, that
also prevents changing the V4L2 sub-device formats along that pipeline.
There is no requirement that the V4L2 sub-device formats in a pipeline must
be set before the V4L2 formats.

Should VIDIOC_S_FMT, for example, have that kind of behaviour? The question
is closely related to the more generic question of how do you prevent other
processes from changing a pipeline (links, V4L2 sub-device formats,
selections or V4L2 formats etc.) while it's being configured. So far that
hasn't been done elsewhere than on video nodes, and not all drivers
implemeted that. I'd like to have at least Hans's and Laurent's opinion on
that. I think the idea is good in principle.

This should be considered together with existing mechanisms. The V4L2 spec
says that:

	Application Priority
	
	When multiple applications share a device it may be desirable to
	assign them different priorities. Contrary to the traditional "rm
	-rf /" school of thought a video recording application could for
	example block other applications from changing video controls or
	switching the current TV channel. Another objective is to permit
	low priority applications working in background, which can be
	preempted by user controlled applications and automatically regain
	control of the device at a later time.
	
	Since these features cannot be implemented entirely in user space
	V4L2 defines the VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY ioctls to
	request and query the access priority associate with a file
	descriptor. Opening a device assigns a medium priority, compatible
	with earlier versions of V4L2 and drivers not supporting these
	ioctls. Applications requiring a different priority will usually
	call VIDIOC_S_PRIORITY after verifying the device with the
	VIDIOC_QUERYCAP ioctl.
	
	Ioctls changing driver properties, such as VIDIOC_S_INPUT, return an
	EBUSY error code after another application obtained higher priority.

	<URL:http://hverkuil.home.xs4all.nl/spec/media.html#app-pri>

Setting the input should thus be possible unless another application (file
handle) has a higher priority.

It would be good to write an RFC on the topic so that it's easier for
everyone to understand the underlying technical problems and the intended
way to resolve those issues (once there is one).

In order to make your solution generic, it should also

1. Support pipelines with multiple video nodes in them.

2. Assuming people find extending (and implementing them where
implementation is missing) the current priority mechanisms, provide a way to
prevent other processes from changing configuration of V4L2/MC/V4L2
sub-device nodes (links, V4L2 sub-device formats, selections or V4L2 formats
etc.). The au0828 implementation should be in line with this.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
