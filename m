Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55139 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562AbcCUOkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 10:40:52 -0400
Date: Mon, 21 Mar 2016 11:40:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
Message-ID: <20160321114045.00f200a0@recife.lan>
In-Reply-To: <56EC3BF3.5040100@xs4all.nl>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
	<1457550566-5465-2-git-send-email-javier@osg.samsung.com>
	<56EC2294.603@xs4all.nl>
	<56EC3BF3.5040100@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Mar 2016 18:33:39 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/18/2016 04:45 PM, Hans Verkuil wrote:
> > On 03/09/2016 08:09 PM, Javier Martinez Canillas wrote:  
> >> The enum demod_pad_index list the PADs that an analog TV demod has but
> >> in some decoders the S-Video Y (luminance) and C (chrominance) signals
> >> are carried by different connectors. So a single DEMOD_PAD_IF_INPUT is
> >> not enough and an additional PAD is needed in the case of S-Video for
> >> the additional C signal.
> >>
> >> Add a DEMOD_PAD_C_INPUT that can be used for this case and the existing
> >> DEMOD_PAD_IF_INPUT can be used for either Composite or the Y signal.
> >>
> >> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >>
> >> ---
> >> Hello,
> >>
> >> This change was suggested by Mauro in [0] although is still not clear
> >> if this is the way forward since changing PAD indexes can break the
> >> uAPI depending on how the PADs are looked up. Another alternative is
> >> to have a PAD type as Mauro mentioned on the same email but since the
> >> series are RFC, I'm making this change as an example and hopping that
> >> the patches can help with the discussion.
> >>
> >> [0]: http://www.spinics.net/lists/linux-media/msg98042.html
> >>
> >> Best regards,
> >> Javier
> >>
> >>  include/media/v4l2-mc.h | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> >> index 98a938aabdfb..47c00c288a06 100644
> >> --- a/include/media/v4l2-mc.h
> >> +++ b/include/media/v4l2-mc.h
> >> @@ -94,7 +94,8 @@ enum if_aud_dec_pad_index {
> >>   * @DEMOD_NUM_PADS:	Maximum number of output pads.
> >>   */
> >>  enum demod_pad_index {
> >> -	DEMOD_PAD_IF_INPUT,
> >> +	DEMOD_PAD_IF_INPUT, /* S-Video Y input or Composite */
> >> +	DEMOD_PAD_C_INPUT,  /* S-Video C input or Composite */
> >>  	DEMOD_PAD_VID_OUT,
> >>  	DEMOD_PAD_VBI_OUT,
> >>  	DEMOD_PAD_AUDIO_OUT,
> >>  
> > 
> > These pad index enums are butt ugly and won't scale in the long run. An entity
> > should have just as many pads as it needs and no more.
> > 
> > If you want to have an heuristic so you can find which pad carries e.g.
> > composite video, then it is better to ask the subdev for that.
> > 
> > E.g.: err = v4l2_subdev_call(sd, pad, g_signal_pad, V4L2_PAD_Y_SIG_INPUT, &pad)
> > 
> > The subdev driver knows which pad has which signal, so this does not rely on
> > hardcoding all combinations of possible pad types and you can still heuristically
> > build a media graph for legacy drivers.

Yes, accessing PADs via a hardcoded index is butt ugly.

For sure, we need a better strategy than that. This is one of the things
we need to discuss at the media summit.

> > What we do now is reminiscent of the bad old days when the input numbers (as
> > returned by ENUMINPUT) where mapped to the i2c routing (basically pads). I worked
> > hard to get rid of that hardcoded relationship and I don't like to see it coming
> > back.

No, this is completely unrelated with ENUMINPUT. 

With VIDIOC_*INPUT ioctls, a hardcoded list of inputs can happen only at
the Kernel side, as, userspace should not rely on the input index, but,
instead, should call VIDIOC_ENUMINPUT.

However, the media controller currently lacks an "ENUMPADS" ioctl that
would tell userspace what kind of data each PAD contains. Due to that,
on entities with more than one sink pad and/or more than one source
pad, the application should rely on the PAD index.

That also reflects on the Kernel side, that forces drivers to do
things like:

	struct tvp5150 *core = to_tvp5150(sd);
	int res;

	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;

	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);

hardcoding the PAD indexes.

The enums that are right now at v4l2-mc.h just prevents the mess to
spread all over the drivers, while we don't have a better solution, as
at least it will prevent two different devices with the very same type
to have a completely different set of PADs, with would cause lots of
pain on drivers that work with a multiple set of entities of the same
type.

Please notice that this is not a problem with connectors. It is a
broader problem at the MC infra and API, with affects all subdevs.

> > Actually, I am not sure if a new subdev op will work at all. This information
> > really belongs to the device tree or card info. Just as it is done today with
> > the audio and video s_routing op. The op basically sets up the routing (i.e.
> > pads). We didn't have pads (or an MC) when I made that op, but the purpose
> > is the same.

I didn't think yet on the implementation, but it should be something that the
core should be able to get, if we want to avoid having to add a huge block
of MC-specific routines on each driver, with a really complex logic.

The problem is that the routines that builds the V4L2 graph and
enables/disables the PADs should know what PADs to use.

A subdev ops seem to be a good way for doing that, as it is the subdev
that will create the pads when running its .probe() function.

If we move the media-controller specific initialization out of .probe(), like
what I proposed at:
	https://patchwork.linuxtv.org/patch/33466/

Then, we can let the caller driver to tell the subdev-specific PAD init
code to create only the PADs that the driver will be using.

For example, on em28xx driver, devices with certain chips in the family
(like em2820 and em28xx) don't support VBI. So, the driver could ask
the demod to not create a VBI out PAD, creating only 2 pads.

Yet, it sounds painful to create a generic media_init() callback that
would allow to control the number and the meaning of the PADs that
would cover all cases.

> > Although I guess that a g_signal_pad might be enough in many cases. I don't
> > know what is the best solution, to be honest. All I know is that the current
> > approach will end in tears.
> > 
> > Hmm, looking at saa7134-cards you have lists of inputs. You could add a pad_type
> > field there and use the g_signal_pad to obtain the corresponding pad of the
> > subdev entity. You'd have pad types TV, COMPOSITE[1-N], SVIDEO[1-N], etc.
> > 
> > Note that input 1 could map to pad type COMPOSITE3 since that all depends on
> > how the board is wired up.
> > 
> > But at least this approach doesn't force subdevs to have more pads than they
> > need.  
> 
> Actually, there is really no need for these 'pad types'. Why not just put the
> actual pads in the card info? You know that anyway since you have to configure
> the routing. So just stick it in the board info structs.

If we hardcode the PAD indexes at the board info, that would mean that
we can't have a generic core routine to create the graph or enable/disable
the sources. We should get rid of hardcoding it, and not adding more
hardcoded values.

> Why this rush to get all this in? Can we at least disable the media device
> creation for these usb and pci devices until we are sure we got all the details
> right? As long as we don't register the media device these pads aren't used and
> we can still make changes.
> 
> Let's be honest: nobody is waiting for media devices for these chipsets. We want
> it because we want to be consistent and it is great for prototyping, but other
> than us no one cares.

No, we want this for two reasons:

1) To fix the locking troubles with analog, digital and audio parts of
the driver;

2) To report userspace apps what devnodes belong to each devices.

Both are longstanding bugs. (2) is partially solved via libmedia_dev, with
was actually added inside tvtime and xawtv, as we never agreed with the
library's API.

> This stuff is really hard to get right, and I feel these things are exposed too
> soon. And once it is part of the public API it is very hard to revert.

Well, this problem is there already, as userspace relies on
hardcoded index values since when the media controller got merged.

What we did with connectors was actually your suggestion: we removed
the definition of the connectors from the uAPI, with should give
us flexibility to change it as needed.

We could, instead, not be calling media_devnode_register() at the
new drivers and at PCI/USB drivers until we fix it, but we'll
still have to address backward compat with the legacy drivers.

Regards,
Mauro
