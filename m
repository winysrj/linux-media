Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.perex.cz ([77.48.224.245]:56313 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaETN6L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 09:58:11 -0400
Message-ID: <537B5B68.40505@perex.cz>
Date: Tue, 20 May 2014 15:40:56 +0200
From: Jaroslav Kysela <perex@perex.cz>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>
CC: "Yang, Libin" <libin.yang@intel.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"Nikkanen, Kimmo" <kimmo.nikkanen@intel.com>,
	"Koul, Vinod" <vinod.koul@intel.com>,
	"Lin, Mengdong" <mengdong.lin@intel.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"Babu, Ramesh" <ramesh.babu@intel.com>,
	"Shankar, Uma" <uma.shankar@intel.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	"Girdwood, Liam R" <liam.r.girdwood@intel.com>,
	Greg KH <greg@kroah.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [Intel-gfx] [RFC] set up an sync channel between
 audio and display driver (i.e. ALSA and DRM)
References: <F46914AEC2663F4A9BB62374E5EEF8F82B447059@SHSMSX101.ccr.corp.intel.com> <20140520100204.GM8790@phenom.ffwll.local> <20140520100438.GN8790@phenom.ffwll.local> <20140520124325.GA6240@ulmo>
In-Reply-To: <20140520124325.GA6240@ulmo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Date 20.5.2014 14:43, Thierry Reding wrote:
> On Tue, May 20, 2014 at 12:04:38PM +0200, Daniel Vetter wrote:
>> Also adding dri-devel and linux-media. Please don't forget these lists for
>> the next round.
>> -Daniel
>>
>> On Tue, May 20, 2014 at 12:02:04PM +0200, Daniel Vetter wrote:
>>> Adding Greg just as an fyi since we've chatted briefly about the avsink
>>> bus. Comments below.
>>> -Daniel
>>>
>>> On Tue, May 20, 2014 at 02:52:19AM +0000, Lin, Mengdong wrote:
>>>> This RFC is based on previous discussion to set up a generic communication channel between display and audio driver and
>>>> an internal design of Intel MCG/VPG HDMI audio driver. It's still an initial draft and your advice would be appreciated
>>>> to improve the design.
>>>>
>>>> The basic idea is to create a new avsink module and let both drm and alsa depend on it.
>>>> This new module provides a framework and APIs for synchronization between the display and audio driver.
>>>>
>>>> 1. Display/Audio Client
>>>>
>>>> The avsink core provides APIs to create, register and lookup a display/audio client.
>>>> A specific display driver (eg. i915) or audio driver (eg. HD-Audio driver) can create a client, add some resources
>>>> objects (shared power wells, display outputs, and audio inputs, register ops) to the client, and then register this
>>>> client to avisink core. The peer driver can look up a registered client by a name or type, or both. If a client gives
>>>> a valid peer client name on registration, avsink core will bind the two clients as peer for each other. And we
>>>> expect a display client and an audio client to be peers for each other in a system.
>>>>
>>>> int avsink_new_client ( const char *name,
>>>>                             int type,   /* client type, display or audio */
>>>>                             struct module *module,
>>>>                             void *context,
>>>>                             const char *peer_name,
>>>>                             struct avsink_client **client_ret);
>>>>
>>>> int avsink_free_client (struct avsink_client *client);
>>>
>>>
>>> Hm, my idea was to create a new avsink bus and let vga drivers register
>>> devices on that thing and audio drivers register as drivers. There's a bit
>>> more work involved in creating a full-blown bus, but it has a lot of
>>> upsides:
>>> - Established infrastructure for matching drivers (i.e. audio drivers)
>>>   against devices (i.e. avsinks exported by gfx drivers).
>>> - Module refcounting.
>>> - power domain handling and well-integrated into runtime pm.
>>> - Allows integration into componentized device framework since we're
>>>   dealing with a real struct device.
>>> - Better decoupling between gfx and audio side since registration is done
>>>   at runtime.
>>> - We can attach drv private date which the audio driver needs.
> 
> I think this would be another case where the interface framework[0]
> could potentially be used. It doesn't give you all of the above, but
> there's no reason it couldn't be extended. Then again, adding too much
> would end up duplicating more of the driver core, so if something really
> heavy-weight is required here, then the interface framework is not the
> best option.
> 
> [0]: https://lkml.org/lkml/2014/5/13/525

This looks like the right direction. I would go in this way rather than
create specific A/V grouping mechanisms. This seems to be applicable to
more use cases.

				Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project; Red Hat, Inc.
