Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4948 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2ETOfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 10:35:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
Date: Sun, 20 May 2012 16:34:58 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ondrej Zary <linux@rainbow-software.org>,
	manjunatha_halli@ti.com
References: <4FB7E489.10803@redhat.com> <201205201223.19055.hverkuil@xs4all.nl> <4FB8DA9C.3030604@redhat.com>
In-Reply-To: <4FB8DA9C.3030604@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205201634.58434.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I propose that once I have received my radio-cadet card and I have had some
time to test it that we talk it over on irc.

It seems we are close to a result.

BTW, multiple tuners for a radio device should definitely be possible and we
do need to clarify the spec in that respect.

There isn't actually any board with multiple tuners, although the Hauppauge
PVR-500 (ivtv based) comes close as it has separate TV and radio tuners instead
of the usual 'one tuner fits all' approach.

Regards,

	Hans

On Sun May 20 2012 13:50:52 Hans de Goede wrote:
> Hi,
> 
> On 05/20/2012 12:23 PM, Hans Verkuil wrote:
> > Hi Hans,
> >
> > I'm CC-ing Manjunatha Halli as well as due to his work on adding support
> > for the weather band:
> >
> > http://www.spinics.net/lists/kernel/msg1340986.html
> >
> > The question is whether the weather band and the AM band should be treated
> > the same. The wl128x will implement the weather band as part of the single
> > tuner, the cadet currently implements the AM band as a separate tuner.
> >
> > Given the fact that the wl128x and the radioSHARK both have only one
> > physical tuner (and that's almost certainly the case for the cadet radio
> > as well) I am not so sure whether we should handle this as two tuners. The
> > approach taken for the wl128x seems at first glance a better solution.
> >
> > However, when I have my cadet card I'd like to experiment with it first and
> > see what the best approach is to solve this problem.
> 
> I agree that since it is a single tuner, it makes sense to treat is as such :)
> The problem is that it has very distinctive properties depending on whether
> it is operating in AM or FM mode, ie the bands are: 87.5 - 108 Mhz and
> 530 - 1710 kHz. Now we can just represent that as the tuner being capable to
> tune from 530 kHz - 108 Mhz but that won't result in a good UI experience
> in userspace at all.
> 
> I still agree that since it is a single tuner, it makes sense to treat is as such,
> and since there are no overlapping frequencies, treating it as one tuner is
> not a problem for most of the API, the only trouble some part really is
> G_TUNER, since it cannot deal with having multiple frequency ranges, nor
> with different properties per frequency range.
> 
> We could introduce a subidx concept, and a related
> tuner capability. Add if that capability is present, then userspace
> can query different frequency ranges and there separate properties
> by calling g_tuner with the same index but a different subidx until
> it returns -EINVAL.
> 
> We can use one of the reserved fields for the subidx, or ...
> 
> We could store the subidx in the higher 16 bits of index, since index
> is way larger then we need anyways, and this also avoids the
> theoretical problems with apps not clearing the reserved fields we could
> use for a proper subidx again.
> 
> I personally prefer just using a separate field for it.
> 
> 
> >
> > On Sat May 19 2012 20:20:57 Hans de Goede wrote:
> >> Hi Hans et all,
> >>
> >> Currently the V4L2 API does not allow for radio devices with more then 1 tuner,
> >> which is a bit of a historical oversight, since many radio devices have 2
> >> tuners/demodulators 1 for FM and one for AM. Trying to model this as 1 tuner
> >> really does not work well, as they have 2 completely separate frequency bands
> >> they handle, as well as different properties (the FM part usually is stereo
> >> capable, the AM part is not).
> >>
> >> It is important to realize here that usually the AM/FM tuners are part
> >> of 1 chip, and often have only 1 frequency register which is used in
> >> both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
> >> and from a V4L2 API pov these modes are best modeled as 2 tuners.
> >> This is at least true for the radio-cadet card and the tea575x,
> >> which are the only 2 AM capable radio devices we currently know about.
> >>
> >> Currently the V4L2 spec says the following on this subject:
> >> http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html
> >> "Radio devices have exactly one tuner with index zero, no video inputs."
> >>
> >> This text can easily be changed into allowing multiple tuners, without
> >> any API change from the app pov, existing apps will be limited to
> >> accessing just the first tuner though (probably best to always
> >> make this the FM one).
> >
> > I agree. This text should change.
> 
> Well if we go with the actually it is a single tuner concept above it
> does not need to change, and we avoid the problems below...
> 
> >>
> >> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html
> >> "... call the VIDIOC_S_TUNER ioctl. This will not change the current tuner,
> >> which is determined by the current video input."
> >>
> >> This is a problem, video devices when they have multiple tuners often
> >> do so with the purpose of being able to watch/record multiple channels
> >> at the same time, and thus multiple tuners are usually connected to
> >> different inputs / frame-grabbers, and the input<->  tuner mapping done
> >> for video devices makes sense there.
> >>
> >> As the spec states, radio devices have no video inputs, so
> >> VIDIOC_S_INPUT cannot be used on them. Which means we need another
> >> way to get/set the active tuner (the tuner mode) for a radio device.
> >
> > Correct. The spec contradicts itself here for radio devices and that needs
> > to be solved.
> 
> Only if we assume there can be more then 1 tuner on a radio dev.
> 
> >> Lets look at the getting of the active tuner first. We cannot use
> >> VIDIOC_G_TUNER for this, since this is used to enumerate tuners,
> >> so it should return info on the tuner with the specified index,
> >> rather then the active tuner.
> >
> > I agree.
> >
> >> VIDEOC_G_FREQUENCY otoh looks like a good candidate to use for this,
> >> for radio devices we can simply ignore the passed in tuner field,
> >> and instead return the active tuner and the current frequency.
> >> This means there will be no way to get the frequency for the non
> >> active tuner (mode), this is fine, since the non active tuner
> >> does not have a (valid) frequency anyways.
> >
> > This would mean that the spec changes for this ioctl. I'm not certain I like
> > that.
> 
> I understand, note that this is what the cadet driver is currently
> doing, which is were I got my inspiration from :)
> 
> >> If we choose for VIDIOC_G_FREQUENCY to always return info on the
> >> active tuner it makes sense to use VIDIOC_S_FREQUENCY to select
> >> the active tuner. So for radio devices it will not only change
> >> the currently tuned frequency for the indicated tuner, but if
> >> the indicated tuner was not the active tuner it will make it the
> >> active tuner.
> >
> > Ack.
> >
> >> Which leaves the question of what to do with VIDIOC_S_HW_FREQ_SEEK,
> >> since VIDIOC_S_HW_FREQ_SEEK needs a valid begin frequency as a pre
> >> condition, and the frequency ranges differ between different
> >> tuners it makes sense to only allow VIDIOC_S_HW_FREQ_SEEK on
> >> the active tuner.
> >
> > I see S_HW_FREQ_SEEK as an extended variation on S_FREQUENCY, so I
> > believe calling S_HW_FREQ_SEEK should also change the current tuner.
> 
> Ok, this does mean caching the last set freq for AM/FM as S_FREQ does
> not provide a point where to start searching ...
> 
> >> So this leaves one last problem, what to
> >> return from VIDIOC_S_HW_FREQ_SEEK if it tries to seek for
> >> a non active tuner. I'm tending towards saying -EBUSY, since some
> >> parts of the tuners are shared, so the non active tuner cannot
> >> seek because those shared parts are otherwise used.
> >
> > *If* we decide that S_HW_FREQ_SEEK cannot change the current tuner, then
> > -EBUSY would be a good error code.
> >
> > The problem is really that you are trying to use G_FREQUENCY to figure out
> > what the active tuner is. That requires an API change (the tuner field now
> > only contains the current active tuner instead of the tuner whose frequency
> > is requested), and because of that API change you have to change S_HW_FREQ_SEEK
> > as well.
> 
> Right (more or less)
> 
> > In my view struct v4l2_tuner should be enhanced allowing it to return a
> > flag or something similar that tells the application whether the given tuner
> > index is the active index.
> >
> > Adding a flags field might do it, or perhaps (a bit hackish though) adding a
> > V4L2_TUNER_SUB_ACTIVE flag.
> >
> > All this is independent of the question whether we should model the AM and
> > weather bands as one or multiple tuners. Strictly speaking I think this would
> > depend on whether there is only one tuner or if there are two (or more)
> > independent tuners. In the second case I think modelling this using two tuners
> > is the right approach. In the first case keeping to one tuner seems better, but
> > it leads to the question how to query the frequency range of each band.
> 
> Right, the more I think about this, the more I tend towards treating it as a
> single tuner (which at least for the tea5757 based devices, as well as for
> the cadet is true). Which indeed makes the question how do we query the
> different bands (and the caps per band)
> 
> > I like much of the work done on frequency bands in Manjunatha's patches (I did
> > help with that, so I'm biased :-) ), but getting the frequency ranges for each
> > band wasn't addressed there.
> >
> > I would propose that we add a new capability:
> >
> > V4L2_TUNER_CAP_BANDS 0x1000
> >
> > If set, then frequency bands are supported and the correct band capabilities
> > from Manjunatha's patch series are set. In addition a new band field is added
> > to v4l2_tuner. It is unused if V4L2_TUNER_CAP_BANDS isn't set, otherwise the
> > application can set it to the band whose frequency range and capabilities it
> > wants to know.
> 
> Sounds like my subidx from above, your name is better though, +1
> 
> > If band == 0, or if an invalid band is passed, then the driver fills in the
> > current band and frequency range and capabilities.
> 
> Smart, this will help with old app compatiblity +1 again :)
> 
> > If non-zero, then the frequency range and capabilities of the given band are
> > returned. Fields like rxsubchans and audmode always return values for the
> > current selected frequency. Hmm, this doesn't feel right. Perhaps this should
> > only return correct values if the current frequency falls within the given
> > band, and otherwise these fields are set to 0.
> 
> How about rxsubchans and audmode only being valid when band == 0, iow when
> querying the current active band? That seems the right thing to do to me,
> as apps either want to find out info about available bands, or about the
> current mode and things like currently active audmode only makes sense for
> the current mode. Same for signal BTW.
> 
> > Since S_TUNER is an IOW ioctl, none of this applies to S_TUNER.
> 
> Right.
> 
> 
> Regards,
> 
> Hans
> 
