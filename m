Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53718 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934507AbcCNPWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 11:22:23 -0400
Subject: Re: [PATCH v3 06/22] media: Media Controller enable/disable source
 handler API
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <2d8b035ec723346dfeed5db859aba67738e049cc.1455233153.git.shuahkh@osg.samsung.com>
 <20160310073500.GK11084@valkosipuli.retiisi.org.uk>
 <56E184E7.80603@osg.samsung.com>
 <20160313201131.GN11084@valkosipuli.retiisi.org.uk>
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
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E6D724.6080909@osg.samsung.com>
Date: Mon, 14 Mar 2016 09:22:12 -0600
MIME-Version: 1.0
In-Reply-To: <20160313201131.GN11084@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2016 02:11 PM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Thu, Mar 10, 2016 at 07:29:59AM -0700, Shuah Khan wrote:
>> On 03/10/2016 12:35 AM, Sakari Ailus wrote:
>>> Hi Shuah,
>>>
>>> On Thu, Feb 11, 2016 at 04:41:22PM -0700, Shuah Khan wrote:
>>>> Add new fields to struct media_device to add enable_source, and
>>>> disable_source handlers, and source_priv to stash driver private
>>>> data that is used to run these handlers. The enable_source handler
>>>> finds source entity for the passed in entity and checks if it is
>>>> available. When link is found, it activates it. Disable source
>>>> handler deactivates the link.
>>>>
>>>> Bridge driver is expected to implement and set these handlers.
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>> ---
>>>>  include/media/media-device.h | 30 ++++++++++++++++++++++++++++++
>>>>  1 file changed, 30 insertions(+)
>>>>
>>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>>>> index 075a482..1a04644 100644
>>>> --- a/include/media/media-device.h
>>>> +++ b/include/media/media-device.h
>>>> @@ -302,6 +302,11 @@ struct media_entity_notify {
>>>>   * @entity_notify: List of registered entity_notify callbacks
>>>>   * @lock:	Entities list lock
>>>>   * @graph_mutex: Entities graph operation lock
>>>> + *
>>>> + * @source_priv: Driver Private data for enable/disable source handlers
>>>> + * @enable_source: Enable Source Handler function pointer
>>>> + * @disable_source: Disable Source Handler function pointer
>>>> + *
>>>>   * @link_notify: Link state change notification callback
>>>>   *
>>>>   * This structure represents an abstract high-level media device. It allows easy
>>>> @@ -313,6 +318,26 @@ struct media_entity_notify {
>>>>   *
>>>>   * @model is a descriptive model name exported through sysfs. It doesn't have to
>>>>   * be unique.
>>>> + *
>>>> + * @enable_source is a handler to find source entity for the
>>>> + * sink entity  and activate the link between them if source
>>>> + * entity is free. Drivers should call this handler before
>>>> + * accessing the source.
>>>> + *
>>>> + * @disable_source is a handler to find source entity for the
>>>> + * sink entity  and deactivate the link between them. Drivers
>>>> + * should call this handler to release the source.
>>>> + *
>>>
>>> Is there a particular reason you're not simply (de)activating the link, but
>>> instead add a new callback?
>>
>> These two handlers are separate for a couple of reasons:
>>
>> 1. Explicit and symmetric API is easier to use and maintain.
>>    Similar what we do in other cases, register/unregister
>>    get/put etc.
> 
> Link state is set explicitly (enabled or disabled). This is certainly not a
> reason to create a redundant API for link setup.
> 
>> 2. This is more important. Disable handler makes sure the
>>    owner is releasing the resource. Otherwise, when some
>>    other application does enable, the owner could loose
>>    the resource, if enable and disable are the same.
>>
>>    e.g: Video app is holding the resource, DVB app does
>>    enable. Disable handler makes sure Video/owner  is the one
>>    that is asking to do the release.
> 
> Based on the later patches in this set, the enable_source() callback of the 
> au0828 driver performs three things:
> 
> - Find the source entity,
> - Enable the link from some au0828 entity to the source and
> - Start the pipeline that begins from the I/O device node. The pipe object
>   is embedded in struct video_device.
> 
> disable_source() undoes this in reverse order.
> 
> That's in the au0828 driver and rightly so.
> 
> Then it gets murkier. enable_source() and disable_source() callbacks
> (through a few turns) will get called from v4l2-ioctl.c functions
> v4l_querycap, v4l_s_fmt, v4l_s_frequency, v4l_s_std and v4l_querystd. This
> is also performed in VB2 core vb2_core_streamon() function.
> 
> I certainly have no objections when it comes to blocking other processes
> from setting the format when a process holding a file handle to a device has
> e.g. set the format. The implementation is another matter.
> 
> What particularly does concern me in this patchset is:
> 
> - struct media_pipe is intended to be allocated by drivers embedded in
>   another struct holding information the driver needs related to the
>   pipeline. Moving this struct to struct video_device prevents this, which
>   translates to v4l_enable_media_source() and v4l_disable_media_source()
>   functions the patchset adds being specific to the au0828 driver. They
>   should be part of that driver, and may not be part of the V4L2 core.
>   struct media_pipe may not be added to struct video_device for the same
>   reason.

This media_pipe is associated with struct video_device though. I don't
understand your concern. I am viewing this media_pipe as part of the
registered video_device. video_device struct is in the au0828 device
and gets registered as a whole including the media_pipe 

> 
> - The IOCTL handlers in v4l2-ioctl.c already call driver-settable callbacks
>   before this set. It looks like redundant callbacks are added there as
>   ell. The same appears to be true for the VB2 callback. Could you use the
>   existing callbacks instead of creating new ones?

If I understand correctly, you are suggesting that the calls to enable
and disable source should be made from the au0828 hooks. e.g vidioc_s_std()

Calling them from v4l2-core makes it generic and works on all drivers
without driver changes. That is the rationale for making adding v4l2
common interfaces v4l_enable_media_source() and v4l_disable_media_source()

> 
> As a short term solution, I propose moving the code to the au0828 driver.
> Once it is there, we can see whether it could be made more generic if there
> is a need for it elsewhere. I believe so. Support atomic pipeline
> configuration and startup is a generic problem that requires a generic
> solution: we should have a way to construct a pipeline and prevent other
> users from messing with it before it's started. But as currently implemented
> by this patchset, it is very specific to the au0828 driver and as such may
> not be added to the V4L2 or the MC frameworks.
> 

The enable and disable handlers themselves are for a good reason. These are
handlers that get called from dvb-core, v4l2-core via the common interfaces.
These also get called from sound driver from the media_device. All of this is
generic. Could you please elaborate on which part is au0828 driver specific
other than the media_pipe in struct video_device?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
