Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51481 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbeBENRz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 08:17:55 -0500
Date: Mon, 5 Feb 2018 11:17:51 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
Message-ID: <20180205111751.719d9888@vento.lan>
In-Reply-To: <9bea912a-0093-1b08-97b4-5377169e6e3a@xs4all.nl>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
        <20180205085130.2b48dcd4@vento.lan>
        <9bea912a-0093-1b08-97b4-5377169e6e3a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Feb 2018 12:55:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/05/2018 12:15 PM, Mauro Carvalho Chehab wrote:
> > Hi Hans,
> > 
> > Em Sun, 4 Feb 2018 14:06:42 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> Hi Mauro,
> >>
> >> I'm working on adding proper compliance tests for the MC but I think something
> >> is missing in the G_TOPOLOGY ioctl w.r.t. pads.
> >>
> >> In several v4l-subdev ioctls you need to pass the pad. There the pad is an index
> >> for the corresponding entity. I.e. an entity has 3 pads, so the pad argument is
> >> [0-2].
> >>
> >> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use that
> >> in the v4l-subdev ioctls, so how do I translate that to a pad index in my application?
> >>
> >> It seems to be a missing feature in the API. I assume this information is available
> >> in the core, so then I would add a field to struct media_v2_pad with the pad index
> >> for the entity.  
> > 
> > No, this was designed this way by purpose, back in 2015, when this was
> > discussed at the first MC workshop. It was a consensus on that time that
> > parameters like PAD index, PAD name, etc should be implemented via the
> > properties API, as proposed by Sakari [1]. We also had a few discussions 
> > about that on both IRC and ML.
> > 
> > [1] See: https://linuxtv.org/news.php?entry=2015-08-17.mchehab
> > 
> > 	3.3 Action items
> > 	...
> > 	media_properties: RFC userspace API: Sakari
> > 
> > Unfortunately, Sakari never found the time to send us a patch series
> > implementing a properties API, even as RFC.
> > 
> > One of the other missing features is to add a new version for setting
> > links (I guess we called it as S_LINKS_V2 at the meetings there).
> > The hole idea is to provide a way to setup the entire pipeline using
> > a single ioctl, on an atomic way.
> > 
> > The big problem with pad indexes happen on entities that have PADs with
> > different types of signal input or output, like for example a TV tuner.
> > 
> > On almost all PC consumers hardware supported by the Kernel, the same
> > PCI/USB ID may come with different types of hardware. This may also
> > happen with embedded TV sets, as, depending on the market is is
> > sold, the same product may come with a different tuner.
> > 
> > A "classic" TV tuner usually has those types of output signals:
> > 
> > 	- analog TV luminance IF;
> > 	- analog TV chrominance IF [1];
> > 	- digital TV OFDM IF;
> > 	- audio IF;
> > 
> > [1] As both luminance and chrominance should go to the same TV
> >     demod, in practice, we can group both signals together on a
> >     single pad.
> > 
> > More modern tuners also have an audio demod integrated, meaning that
> > they also have another PAD:
> > 	- digital mono or stereo audio.
> > 
> > At the simplest possible scenario, let's say that we have a TV device
> > has those entities (among others), each with a single PAD input:
> > 
> > 	- entity #0: a TV tuner;
> > 	- entity #1: an audio demod;
> > 	- entity #2: an analog TV demod;
> > 	- entity #3: a digital TV demod.
> > 
> > And the TV tuner has 4 output pads:
> > 
> > 	- pad #0 -> analog TV luminance/chrominance;
> > 	- pad #1 -> digital TV IF;
> > 	- pad #2 -> audio IF;
> > 	- pad #3 -> digital audio.
> > 
> > There, pad #0 can only be connected to entity #2. You cannot
> > connect any other pad to entity #2. The same apply to every other
> > TV tuner output PAD.
> > 
> > In this specific scenario, entity #1 can only be connected to pad #2,
> > and pad #3 can't be connected anywhere, as, on this model opted to
> > have a separate audio demod, and didn't wired the digital audio output.
> > Yet, the subdev has it.
> > 
> > Another TV set may have different pad numbers - placing them even on a
> > different order, and opting to use the audio demod tuner, wiring the
> > digital audio output.
> > 
> > Currently, there's no way for an userspace application to know what pads
> > can be linked to each entity, as there's no way to tell userspace what
> > kind of signal each pad supports.
> > 
> > In any case, the Kernel should either detect the tuner model or know
> > it (via a different DT entry), but userspace need such information,
> > in order to be able to properly set the pipelines.
> > 
> > So, what we really need here is passing an optional set of properties
> > to userspace in order to allow it to do the right thing.  
> 
> I fail to see the problem. Entities have pads. Pads have both a unique
> ID and an index within the entity pad list. I.e. the pad ID and the
> (entity ID + pad index) tuple both uniquely identify the pad.
> 
> Whether a pad is connected to anything or what type it is is unrelated
> to this. Passing the pad index of an unconnected pad to e.g. SUBDEV_S_FMT
> will just result in an error. All I need is to be able to obtain the
> pad index so I can call SUBDEV_S_FMT at all!

The problem is not at S_FMT. It happens before that: How an userspace 
application will know what pad index or pad ID should be used to set the
pipeline?

I mean, how it will know that tuner #0 pad #0 should be connected to
entity #0 (an analog TV decoder) or to entity #2 (an audio decoder)?
It has to know if pad #0 contains analog TV signals or audio signals.
The API doesn't provide such information, and adding a pad index
won't solve it.

Ok, there is an obvious solution: it could hardcode pad indexes and pad IDs
per each hardware model it needs to work with (and the Kernel version, as
PAD order and even number of pads may change on future versions), but 
that defeats the purpose of having any topology API: if the application
already knows what to expect for a given hardware on a given Kernel version,
it could just setup the links without even querying about the topology.

But, if we want apps to rely on G_TOPOLOGY, it should describe the pads
in a way that apps can use the information provided there.

On devices with multiple inputs, if *all* inputs receive the same kind
of signal, just a pad index is enough. The same applies to devices
that have multiple outputs: if *all* outputs have the same type, a
pad index is enough to allow setting the pipelines via
MEDIA_IOC_SETUP_LINK (or a new PAD ID-based atomic setup links ioctl,
as discussed in the past).

However, on the general case, apps can only call MEDIA_IOC_SETUP_LINK
(or an equivalent pad-id based ioctl) when they know what signal types
each pad contains.

On other words, a pad index is one important information for devices 
with multiple pad inputs or outputs, but it works fine only if all 
inputs receive the same type of signals, and all pad outputs produce
the same type of signals.

> 
> I actually like G_TOPOLOGY, it's nice. But it just does not give all the
> information needed.

Agreed.

> > Yet, I agree with you: we should not wait anymore for a properties API,
> > as it seems unlikely that we'll add support for it anytime soon.
> > 
> > So, let's add two fields there:
> > 	- pad index number;  
> 
> So should I also add a flag to signal that the pad index is set? 

A flag won't solve. If userspace doesn't know if it is running on
a new Kernel with a G_TOPOLOGY with new flags, it won't expect a
flags there.

IMO, the best thing to do here is to increment the API version reported
via MEDIA_IOC_DEVICE_INFO.

> Since
> current and past kernels never set this. Obviously none of the current
> applications using G_TOPOLOGY would use a pad index because there isn't
> one. It would only be a problem for new applications that switch to
> G_TOPOLOGY, use subdevs and assume that the kernel that is used supports
> the pad index. I'm not sure if this warrants a new pad flag though.

Perhaps it is time to write an ioctl that would allow setting the
pipelines via pad ID and allow setting multiple links at once on
an atomic way.

> 
> > 	- pad type.
> > 
> > In order to make things easy, I guess the best would be to use a string
> > for the pad type, and fill it only for entities where it is relevant
> > (like TV tuners and demods).  
> 
> struct media_v2_pad {
>         __u32 id;
>         __u32 entity_id;
>         __u32 flags;
>         __u32 reserved[5];
> } __attribute__ ((packed));
> 
> This does not easily lend itself to a string.

Yes. The original idea were to add it via properties API as an
string. That's why we didn't add extra space there to store strings.

We could get 32 bits or 64 bits there to be used as an index pointer to a
strings type, stored at the end of G_TOPOLOGY data output, but not sure 
if I like this idea.

> A pad type u16 would be easy to add though.

Due to alignment issues, I would prefer to make it u32, although
u16 is probably more than enough.

> That said, adding a pad type is a completely separate issue
> and needs an RFC or something to define this. If there such an RFC was posted
> in the past, can you provide a link to refresh my memory?

We had some discussions in the past, but we didn't come with a RFC.

For our current needs, I'd say we just need a handful set of types:

#define MEDIA_PAD_TYPE_DEFAULT		0
#define MEDIA_PAD_TYPE_ANALOG_IF	1
#define MEDIA_PAD_TYPE_AUDIO_IF		2
#define MEDIA_PAD_TYPE_DIGITAL_TV_IF	3
#define MEDIA_PAD_TYPE_DIGITAL_AUDIO	4

Values different than zero would be used only when not all inputs
or not all outputs would have the same type. Whey they're all the
same, it would use MEDIA_PAD_TYPE_DEFAULT.

I would use just a single PAD and a single type (MEDIA_PAD_TYPE_ANALOG_IF)
for the cases where a tuner provides Y and C signals, as they're always
grouped altogether when a tuner is connected to an analog TV demod.

It shouldn't be hard to add support for it at the existing subdevs.

Thanks,
Mauro
