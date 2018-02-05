Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40853 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752999AbeBELz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 06:55:26 -0500
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
 <20180205085130.2b48dcd4@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9bea912a-0093-1b08-97b4-5377169e6e3a@xs4all.nl>
Date: Mon, 5 Feb 2018 12:55:21 +0100
MIME-Version: 1.0
In-Reply-To: <20180205085130.2b48dcd4@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 12:15 PM, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Sun, 4 Feb 2018 14:06:42 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> I'm working on adding proper compliance tests for the MC but I think something
>> is missing in the G_TOPOLOGY ioctl w.r.t. pads.
>>
>> In several v4l-subdev ioctls you need to pass the pad. There the pad is an index
>> for the corresponding entity. I.e. an entity has 3 pads, so the pad argument is
>> [0-2].
>>
>> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use that
>> in the v4l-subdev ioctls, so how do I translate that to a pad index in my application?
>>
>> It seems to be a missing feature in the API. I assume this information is available
>> in the core, so then I would add a field to struct media_v2_pad with the pad index
>> for the entity.
> 
> No, this was designed this way by purpose, back in 2015, when this was
> discussed at the first MC workshop. It was a consensus on that time that
> parameters like PAD index, PAD name, etc should be implemented via the
> properties API, as proposed by Sakari [1]. We also had a few discussions 
> about that on both IRC and ML.
> 
> [1] See: https://linuxtv.org/news.php?entry=2015-08-17.mchehab
> 
> 	3.3 Action items
> 	...
> 	media_properties: RFC userspace API: Sakari
> 
> Unfortunately, Sakari never found the time to send us a patch series
> implementing a properties API, even as RFC.
> 
> One of the other missing features is to add a new version for setting
> links (I guess we called it as S_LINKS_V2 at the meetings there).
> The hole idea is to provide a way to setup the entire pipeline using
> a single ioctl, on an atomic way.
> 
> The big problem with pad indexes happen on entities that have PADs with
> different types of signal input or output, like for example a TV tuner.
> 
> On almost all PC consumers hardware supported by the Kernel, the same
> PCI/USB ID may come with different types of hardware. This may also
> happen with embedded TV sets, as, depending on the market is is
> sold, the same product may come with a different tuner.
> 
> A "classic" TV tuner usually has those types of output signals:
> 
> 	- analog TV luminance IF;
> 	- analog TV chrominance IF [1];
> 	- digital TV OFDM IF;
> 	- audio IF;
> 
> [1] As both luminance and chrominance should go to the same TV
>     demod, in practice, we can group both signals together on a
>     single pad.
> 
> More modern tuners also have an audio demod integrated, meaning that
> they also have another PAD:
> 	- digital mono or stereo audio.
> 
> At the simplest possible scenario, let's say that we have a TV device
> has those entities (among others), each with a single PAD input:
> 
> 	- entity #0: a TV tuner;
> 	- entity #1: an audio demod;
> 	- entity #2: an analog TV demod;
> 	- entity #3: a digital TV demod.
> 
> And the TV tuner has 4 output pads:
> 
> 	- pad #0 -> analog TV luminance/chrominance;
> 	- pad #1 -> digital TV IF;
> 	- pad #2 -> audio IF;
> 	- pad #3 -> digital audio.
> 
> There, pad #0 can only be connected to entity #2. You cannot
> connect any other pad to entity #2. The same apply to every other
> TV tuner output PAD.
> 
> In this specific scenario, entity #1 can only be connected to pad #2,
> and pad #3 can't be connected anywhere, as, on this model opted to
> have a separate audio demod, and didn't wired the digital audio output.
> Yet, the subdev has it.
> 
> Another TV set may have different pad numbers - placing them even on a
> different order, and opting to use the audio demod tuner, wiring the
> digital audio output.
> 
> Currently, there's no way for an userspace application to know what pads
> can be linked to each entity, as there's no way to tell userspace what
> kind of signal each pad supports.
> 
> In any case, the Kernel should either detect the tuner model or know
> it (via a different DT entry), but userspace need such information,
> in order to be able to properly set the pipelines.
> 
> So, what we really need here is passing an optional set of properties
> to userspace in order to allow it to do the right thing.

I fail to see the problem. Entities have pads. Pads have both a unique
ID and an index within the entity pad list. I.e. the pad ID and the
(entity ID + pad index) tuple both uniquely identify the pad.

Whether a pad is connected to anything or what type it is is unrelated
to this. Passing the pad index of an unconnected pad to e.g. SUBDEV_S_FMT
will just result in an error. All I need is to be able to obtain the
pad index so I can call SUBDEV_S_FMT at all!

I actually like G_TOPOLOGY, it's nice. But it just does not give all the
information needed.

> Yet, I agree with you: we should not wait anymore for a properties API,
> as it seems unlikely that we'll add support for it anytime soon.
> 
> So, let's add two fields there:
> 	- pad index number;

So should I also add a flag to signal that the pad index is set? Since
current and past kernels never set this. Obviously none of the current
applications using G_TOPOLOGY would use a pad index because there isn't
one. It would only be a problem for new applications that switch to
G_TOPOLOGY, use subdevs and assume that the kernel that is used supports
the pad index. I'm not sure if this warrants a new pad flag though.

> 	- pad type.
> 
> In order to make things easy, I guess the best would be to use a string
> for the pad type, and fill it only for entities where it is relevant
> (like TV tuners and demods).

struct media_v2_pad {
        __u32 id;
        __u32 entity_id;
        __u32 flags;
        __u32 reserved[5];
} __attribute__ ((packed));

This does not easily lend itself to a string. A pad type u16 would be easy
to add though. That said, adding a pad type is a completely separate issue
and needs an RFC or something to define this. If there such an RFC was posted
in the past, can you provide a link to refresh my memory?

Regards,

	Hans
