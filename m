Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56611 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbbBOK1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 05:27:22 -0500
Date: Sun, 15 Feb 2015 08:27:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv4 00/25] dvb core: add basic support for the media
 controller
Message-ID: <20150215082716.45165770@recife.lan>
In-Reply-To: <54DF34E2.2020709@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<54DF1625.20808@xs4all.nl>
	<20150214090019.798b6d18@recife.lan>
	<54DF34E2.2020709@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Feb 2015 12:43:30 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/14/2015 12:00 PM, Mauro Carvalho Chehab wrote:
> > Em Sat, 14 Feb 2015 10:32:21 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> >>> This patch series adds basic support for the media controller at the
> >>> DVB core: it creates one media entity per DVB devnode, if the media
> >>> device is passed as an argument to the DVB structures.
> >>>
> >>> The cx231xx driver was modified to pass such argument for DVB NET,
> >>> DVB frontend and DVB demux.
> >>>
> >>> -
> >>>
> >>> version 4:
> >>>
> >>> - Addressed the issues pointed via e-mail
> >>
> >> No, you didn't. Especially with regards to the alsa node definition. I'm
> >> pretty sure you need at least the subdevice information which is now removed.
> > 
> > Well, back on Jan, 26 I answered your issues about that at:
> > 	http://www.spinics.net/lists/linux-media/msg85857.html
> > 
> > As you didn't reply back in a reasonable amount of time, I assumed that
> > you're happy with that.
> > 
> > In any case, the definitions are still there, as nothing got dropped
> > from the external header.
> > 
> > So, when ALSA media controller support will be added at the Kernel, we
> > can decide if it will use major/minor or card/device/subdevice or both.
> > 
> > As I said back in Jan, 26, IMO, the best would be to use both:
> > 
> > struct media_entity_desc {
> > 	...
> > 	union {
> > 		struct {
> > 			u32 major;
> > 			u32 minor;
> > 		} dev;
> > 		/* deprecated fields */
> > 		...
> > 	}
> > 	union {
> > 		struct {
> > 			u32 card;
> > 			u32 device;
> > 			u32 subdevice;
> > 		} alsa_props;
> > 		__u8 raw[172];
> > 	}
> > }
> > 
> > (additional and deprecated fields removed just to simplify its
> >  representation above)
> > 
> > Even for ALSA, it is a way easier for libmediactl.c to keep using
> > major/minor to get the device node name via both udev/sysfs than
> > using anything else, as I don't think that udev has any method to
> > find the associated name without major,minor information. Ok, there
> > are indirect methods using the ALSA API to get such association, but
> > it is just easier to fill everything at the struct than to add the
> > extra complexity for the media control clients to convert between
> > major/minor into card/device/subdevice.
> > 
> > What I'm saying is that the card/device/subdevice really seems to be
> > an extra property for this specific type of devnode, and not a
> > replacement.
> > 
> > In any case, I think we should take the decision on how to properly
> > map the ALSA specific bits when we merge ALSA media controller patches,
> > and not before.
> > 
> >> I also do *not* like the fact that you posted a v4 and immediately applied
> >> these patches to the master without leaving any time for more discussions.
> >>
> >> These patches change the kernel API and need to go to proper review and need
> >> a bunch of Acks, Laurent's at the very minimum since he's MC maintainer.
> >>
> >> Please revert the whole patch series from master, then we can discuss this
> >> more.
> >>
> >> For the record, for patch 02/25:
> >>
> >> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> I do *not* agree with this API change.
> >>
> >> We can discuss this more on Monday.
> > 
> > This hole series is for discussions for a long time (since the beginning of
> > January), without rejection, and its now starting to receive patches from
> > other authors. Keeping it OOT just makes harder to discuss and for people to
> > test. It is time to move on.
> 
> No, it isn't. Laurent and myself actually discussed it during FOSDEM, and
> we did have concerns about the API changes. Since he's the MC maintainer I
> assumed he would get back to you, but I think he's been very busy since FOSDEM.
> In fact, I believe he attended the Linaro Connect last week, so it is very
> likely he will not have had time to do anything with what we discussed at
> FOSDEM.

No, I hadn't any return from that, nor by e-mail or IRC, except for Devin's
emails saying he's ok, provided that we'll also look at the cases with
multiple DVB adapters. I have already some patches covering it, but, in
order to discuss, it is important to merge the work I have already done,
plus the patches from Rafael, as my patches are in the top of his ones.

> Patches changing the MC API need his Ack at minimum. You can't just post a
> v4 patch series and commit the same day. Not when it changes APIs and especially
> not since there were concerns raised about it in the past. You should have
> pinged Laurent and probably myself and ask for comments on v4.

My understanding from the last discussions on IRC with Laurent is that, while
he prefers to not get this merged for 3.20, he is ok if I do that. So, I
took the decision of waiting till the merge of the patches for 3.20 to be
merged and adding those patches for 3.21, giving us 2 Kernel cycles to
do a deeper review. 

This is basically the same thing I do with all API changes: try to merge
them before -rc1 (or at early -rc) at our development tree, in order to
let all of us to test and to fix needed things before it is too late.

> > 
> > As I said on IRC, as I opted to merge it for 3.21, we'll have 2 entire
> > Kernel cycles to make it mature before being merged upstream. During that
> > period, we can fix any issues on it.
> 
> That's not the way things are supposed to work. You wouldn't merge patches
> from us in a similar situation, and quite rightly. I know, we've tried :-)

No, we did fix API bits on stuff already merged on our development tree.
More than that, we did changes even after merging them upstream, during
-rc Kernels, including API variable renames. Several of such changes were
even done or requested by you ;)

One such example is changeset 87185c958de9cd4acd8392f00d6161f4e11807ff
wich was changed at v3.14-rc5-379-g87185c958de9.

For the record, the issue we're suffering with the MC is basically because
we didn't follow the proper procedure when MC got merged. 

The golden rule is that we don't add UAPIs at the Kernel without any
driver using it. However, for MC, we added support for DVB, FB and ALSA
before having any driver using.

That is the source of the problems we're needing to fix now, as just
patching the old structures could cause media controller userspace
applications to not build, so we're forced to deprecate the earlier
bad design decisions, in favor to something that would actually work.

Thankfully, FB is doing the right thing: using major/minor for devnodes,
but ALSA and DVB designs took a risky path.

In the case of DVB, there are as just an "ID" is meaningless there, as
a DVB device needs at least an adapter ID plus a "type" ID in order
to uniquely specify a device instance. For example, the DVB demux
devnodes are /dev/dvb/adapter?/demux?, if there's no udev rule renaming
it to something else.

The big issue of using an adapter_id/type_id, however, and the same applies
to ALSA using card/device/subdevice, is that udev may have rules renaming
the device node to something else. As udev knows nothing about DVB (or
ALSA or whatever), we need to get the device's major/minor, in order to
check what's the name of the devnode he actually created.

So, as properly pointed inside the media-ctl source code, the right and
direct way  to get the path name associated with a device node is to use
its major/minor and ask libudev about what's the path associated with
that given device.

In any case, for ALSA, we should do the right thing here: remove (actually
deprecate) whatever definition is there, and then re-add it only when we
actually have the patches inside the ALSA subsystem to support the media
controller, plus having the corresponding patches for the media-ctl in order
to support the devnode discovery using both udev and sysfs for their nodes.

> Just revert, try to setup an irc session next week, based on that post a v5
> and you are likely able to merge this within 2 weeks. Everyone agrees with
> *what* you want to do, just not about some of the details.

I'm in a holiday this week up to Tuesday. Even if I want, I can't revert
it right now. Let's schedule a meeting on Wed via IRC, in order to discuss
it.

In the mean time, if you have any patches that reflecting the approach
you think it is more appropriate, please feel free to send it to ML
for discussions. I'll try to take a look at my mailbox from time to time
during this holiday.

Regards,
Mauro
