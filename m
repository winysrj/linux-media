Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57946 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbcCBTb7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 14:31:59 -0500
Date: Wed, 2 Mar 2016 16:31:54 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160302163154.1239551a@recife.lan>
In-Reply-To: <56D731F6.8010008@xs4all.nl>
References: <20160226091317.5a07c374@recife.lan>
	<1753279.MBUKgSvGQl@avalon>
	<20160302081323.36eddba5@recife.lan>
	<1736605.4kGg8lYGrV@avalon>
	<56D6CE4A.1000208@xs4all.nl>
	<20160302090857.49ff68e4@recife.lan>
	<56D731F6.8010008@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 02 Mar 2016 19:33:26 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/02/2016 01:08 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 02 Mar 2016 12:28:10 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> On 03/02/16 12:16, Laurent Pinchart wrote:  
> >>> Hi Mauro,
> >>>
> >>> On Wednesday 02 March 2016 08:13:23 Mauro Carvalho Chehab wrote:    
> >>>> Em Wed, 02 Mar 2016 12:34:42 +0200 Laurent Pinchart escreveu:    
> >>>>> On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:    
> >>>
> >>> [snip]
> >>>     
> >>>>>> NOTE:
> >>>>>>
> >>>>>> The labels at the PADs currently can't be represented, but the
> >>>>>> idea is adding it as a property via the upcoming properties API.    
> >>>>>
> >>>>> Whether to add labels to pads, and more generically how to differentiate
> >>>>> them from userspace, is an interesting question. I'd like to decouple it
> >>>>> from the connectors entities discussion if possible, in such a way that
> >>>>> using labels wouldn't be required to leave the discussion open on that
> >>>>> topic. If we foresee a dependency on labels for pads then we should open
> >>>>> that discussion now.    
> >>>>
> >>>> We can postpone such discussion. PAD labels are not needed for
> >>>> what we have so far (RF, Composite, S-Video). Still, I think that
> >>>> we'll need it by the time we add connector support for more complex
> >>>> connector types, like HDMI.    
> >>>
> >>> If we don't add pad labels now then they should be optional for future 
> >>> connectors too, including HDMI. If you think that HDMI connectors will require 
> >>> them then we should discuss them now.
> >>>     
> >>
> >> Pad labels are IMHO only useful for producing human readable output. For complex
> >> designs that helps a lot to understand what is going on.
> >>
> >> But for kernel/applications all you need are #defines with the pad numbers (e.g.
> >> HDMI_PAD_TMDS, HDMI_PAD_CEC, HDMI_PAD_ARC) to use for connectors.  
> > 
> > As we add complexity to MC graph, just hardcoding PAD numbers don't work
> > fine even at the Kernel level. 
> > 
> > Basically, what we currently call as "PAD number", is actually a PAD
> > number+type, as different PADs have different types/functions on most
> > cases.
> > 
> > Any code that needs to connect PADs need to know which type corresponds
> > to a pad number on a given entity.
> > 
> > See for example the code at : it only
> > works because we've created a generic enum demod_pad_index that
> > is been used by the analog TV demods currently supported by the
> > drivers that enable the MC API.
> > 
> > There, we had to standardize the PAD numbers for the analog TV
> > demod, as we need to be able to link the connectors for v4l2-interface
> > centric devices, in order to have a generic function to build the
> > links:
> > 
> > enum demod_pad_index {
> > 	DEMOD_PAD_IF_INPUT,
> > 	DEMOD_PAD_VID_OUT,
> > 	DEMOD_PAD_VBI_OUT,
> > 	DEMOD_NUM_PADS
> > };
> > 
> > (I'll ommit DEMOD_NUM_PADS on the discussions below, just to make
> > the enums clearer)
> > 
> > Due to S-Video, we'll need to add an extra input PAD there
> > (and one extra PAD for audio output - currently only supported
> > by au0828 driver):
> > 
> > enum demod_pad_index {
> > 	/* Input PADs */
> > 	DEMOD_PAD_IF_INPUT,	/* Composite or Y input */
> > 	DEMOD_PAD_C_INPUT,
> > 
> > 	/* Output PADs*/
> > 	DEMOD_PAD_VID_OUT,
> > 	DEMOD_PAD_VBI_OUT,
> > 	DEMOD_PAD_AUDIO_OUT,
> > };
> > 
> > But, an HDMI-only demod would need, instead:
> > 
> > enum hdmi_demod_pad_index {
> > 	/* HDMI-specific input PADs*/
> > 	DEMOD_HDMI_PAD_TMDS,
> > 	DEMOD_HDMI_PAD_CEC,
> > 	DEMOD_HDMI_PAD_ARC,
> > 
> > 	/* Output PADs */
> > 	DEMOD_HDMI_PAD_VID_OUT,
> > 	DEMOD_HDMI_PAD_VBI_OUT,
> > 	DEMOD_HDMI_PAD_AUDIO_OUT,
> > };
> > 
> > If we do that, an extra logic to handle the "HDMI" special case
> > would need at v4l2_mc_create_media_graph(), and we'll need to
> > use a different function for such entity, for it to work.
> > 
> > A demod capable of handling both HDMI and analog TV would need a mix
> > of the above enums:
> > 
> > enum hdmi_and_composite_demod_pad_index {
> > 	/* HDMI-specific input PADs*/
> > 	DEMOD2_PAD_HDMI_TMDS,
> > 	DEMOD2_PAD_HDMI_CEC,
> > 	DEMOD2_PAD_HDMI_ARC,
> > 
> > 	/* non-HDMI Input PADs */
> > 	DEMOD2_PAD_IF_INPUT,	/* Composite or Y input */
> > 	DEMOD2_PAD_C_INPUT,
> > 
> > 	/* Output PADs */
> > 	DEMOD2_PAD_VID_OUT,
> > 	DEMOD2_PAD_VBI_OUT,
> > };
> > 
> > Again, we'll need an extra logic v4l2_mc_create_media_graph(), and
> > a different function for the entity.
> > 
> > We could, instead, just add those new PADs at the existing 
> > enum demod_pad_index, but, if add pad numbers to existing enums, 
> > we will be breaking binary compatibility on every new release,
> > and entities will be exporting PADs that the hardware don't support.
> > 
> > The same trouble will happen also at userspace side, as a generic
> > application written to work with subdev-centric devices would need to
> > know the PAD numbers for each PAD type and for each entity type.
> > 
> > Also, a given entity type would need to have a fixed number of PADs,
> > and such pad numbers are actually part of the uAPI/ABI.
> > 
> > So, IMHO, the proper fix is to create, inside the Kernel, a PAD type
> > field, with will be used by the Kernel generic functions and allow each
> > driver to create as many PADs it needs, without needing to add
> > PADs for non-supported types. So, a demod like saa7115 will never have
> > DEMOD_HDMI_PAD_*. It will be driver's responsibility to fill the PAD
> > type for each PAD.
> > 
> > The core will then use the PAD type to create the pads via
> > v4l2_mc_create_media_graph().
> > 
> > For a generic mc-centric application, the PAD type (or PAD label?)
> > will need to be exported to userspace, for the userspace logic
> > that would be equivalent to what's done at v4l2_mc_create_media_graph().  
> 
> I would have to think about this much more carefully. Perhaps this could be
> a topic if we're having a media mini/micro summit.

Yes, I guess it would be worth to have a topic about that, and about
the properties we want to export via the properties API.

> 
> I don't see the HDMI ever hooked up to a demod. It's all digital after all,
> I don't think there is anything to demod. I have certainly never seen anything
> like that in the various HDMI receivers/transmitters that I am familiar with.

"demod" name is a misleading name for devices that handle pure digital
video, but a device like adv7604 with has 12-channel analog input mux
and is also an HDMI receiver is a demod (for the analog input entries).

We might export it as two separate entities, one for the analog demod
and another one for the HDMI receiver, but this doesn't seem right.

So, at the end of the day, we'll need to support one entity that
will have both analog TV demod and HDMI receiver on it, and we'll
need the core or the userspace to know that such entity will have
more PADs than a normal demod, and what types are associated with
each pad number.

Regards,
Mauro
