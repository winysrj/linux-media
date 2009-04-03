Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4028 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763469AbZDCL3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 07:29:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCH 0/3] FM Transmitter driver
Date: Fri, 3 Apr 2009 13:29:27 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
References: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com> <200904031236.53965.hverkuil@xs4all.nl> <20090403104819.GM13493@esdhcp037198.research.nokia.com>
In-Reply-To: <20090403104819.GM13493@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904031329.27880.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 03 April 2009 12:48:19 Eduardo Valentin wrote:
> Hi,
>
> On Fri, Apr 03, 2009 at 12:36:53PM +0200, ext Hans Verkuil wrote:
> > On Friday 03 April 2009 12:12:30 Eduardo Valentin wrote:
> > > On Thu, Apr 02, 2009 at 06:36:37PM +0200, ext Hans Verkuil wrote:
> > > > On Thursday 02 April 2009 14:02:11 Eduardo Valentin wrote:
> > > > > Hi Hans,
> > > > >
> > > > > On Thu, Apr 02, 2009 at 09:47:11AM +0200, ext Hans Verkuil wrote:
> > > > > > On Wednesday 01 April 2009 11:43:28 Eduardo Valentin wrote:
> > > > > > > Hello Mauro and v4l guys,
> > > > > > >
> > > > > > > This series contains a v4l2 radio driver which
> > > > > > > adds support for Silabs si4713 devices. That is
> > > > > > > a FM transmitter device.
> > > > > > >
> > > > > > > As you should know, v4l2 does not contain representation
> > > > > > > of FM Transmitters (at least that I know). So this driver
> > > > > > > was written highly based on FM receivers API, which can
> > > > > > > cover most of basic functionality. However, as expected,
> > > > > > > there are some properties which were not covered.
> > > > > > > For those properties, sysfs nodes were added in order
> > > > > > > to get user interactions.
> > > > > > >
> > > > > > > Comments are wellcome.
> > > > > >
> > > > > > Can you explain in reasonable detail the extra properties
> > > > > > needed for a device like this? You will need to document that
> > > > > > anyway :-) Rather than implementing a private API it would be
> > > > > > much more interesting to turn this into a public V4L2 API that
> > > > > > everyone can use.
> > > > >
> > > > > Yes, here is a little description of them:
> > > > >
> > > > > Pilot is an audible tone sent by the device.
> > > > >
> > > > > pilot_frequency - Configures the frequency of the stereo pilot
> > > > > tone. pilot_deviation - Configures pilot tone frequency deviation
> > > > > level. pilot_enabled - Enables or disables the pilot tone
> > > > > feature.
> > > > >
> > > > > The si4713 device is capable of applying audio compression to the
> > > > > transmitted signal.
> > > > >
> > > > > acomp_enabled - Enables or disables the audio dynamic range
> > > > > control feature. acomp_gain - Sets the gain for audio dynamic
> > > > > range control. acomp_threshold - Sets the threshold level for
> > > > > audio dynamic range control. acomp_attack_time - Sets the attack
> > > > > time for audio dynamic range control. acomp_release_time - Sets
> > > > > the release time for audio dynamic range control.
> > > > >
> > > > > Limiter setups audio deviation limiter feature. Once a over
> > > > > deviation occurs, it is possible to adjust the front-end gain of
> > > > > the audio input and always prevent over deviation.
> > > > >
> > > > > limiter_enabled - Enables or disables the limiter feature.
> > > > > limiter_deviation - Configures audio frequency deviation level.
> > > > > limiter_release_time - Sets the limiter release time.
> > > > >
> > > > > power_level - Sets the output power level for signal
> > > > > transmission.
> > > >
> > > > Hmm, there are two ways to implement these: either make a bunch of
> > > > VIDIOC's for each of these categories, or use extended controls to
> > > > set all these values. I'm hardly an expert on FM transmitters, but
> > > > it all seems reasonable to me (i.e., not too specific for this
> > > > chip).
> > > >
> > > > I am leaning towards extended controls, since that's so easy to
> > > > extend if needed in the future. And I still intend to add sysfs
> > > > support to controls in the future. On the other hand, it's a bit
> > > > harder to use compared to normal VIDIOCs.
> > >
> > > Could you please explain more about extended controls vs. VIDIOC's?
> > > Pointing drivers which uses one of those also would be worth. But
> > > yes, looks like moving this properties to some sort of v4l2 control
> > > looks better implementation.
> >
> > The spec explains it pretty well. The most up to date version of the
> > spec is available here: http://www.xs4all.nl/~hverkuil/spec/v4l2.html.
> >
> > Basically the extended controls API is more flexible than the older
> > VIDIOC_S/G_CTRL ioctls, allowing to set controls atomically (either all
> > are applied or none) and allowing for a wider range of types, although
> > currently that feature isn't used.
> >
> > It's used by uvcvideo and by MPEG encoders (e.g. cx18, ivtv and
> > others).
> >
> > Using VIDIOCs is easier, but much harder to make future-proof. One
> > disadvantage of using extended controls is that it is harder to
> > implement in drivers, although I plan on creating a much better
> > solution for that in the coming months. With the new v4l framework it
> > should be possible to move much of the control handling into the
> > framework and so simplifying the drivers.
> >
> > > > > RDS related
> > > > >
> > > > > rds_enabled - Enables or disables the RDS feature.
> > > > > rds_ps_name - Sets the RDS ps name field for transmission.
> > > > > rds_radio_text - Sets the RDS radio text for transmission.
> > > > > rds_pi - Sets the RDS PI field for transmission.
> > > > > rds_pty - Sets the RDS PTY field for transmission.
> > > >
> > > > So you set the fields and the RDS encoder will just start using
> > > > them?
> > >
> > > Once you have rds_enabled set, yes, it will transmit them.
> > >
> > > > This too can be done with controls (needs some work, though, to
> > > > support string controls).
> > >
> > > Yes, true.
> > >
> > > > > Region related
> > > > >
> > > > > Setting region will affect other region properties.
> > > > >
> > > > > region_bottom_frequency
> > > > > region_channel_spacing
> > > > > region_preemphasis
> > > > > region_top_frequency
> > > >
> > > > I do not know enough about FM transmissions to judge this. Are
> > > > these region properties something that is regulated by some
> > > > standards commision? Do they also apply when you modulate this over
> > > > a TV/radio cable system? Do you have some documentation or links
> > > > that I can look at to learn more about this?
> > > >
> > > > > stereo_enabled - Enables or disables stereo mode.
> > > > >
> > > > > > How does one pass the audio and rds data to the driver? Note
> > > > > > that for 2.6.31 we will finalize the V4L2 RDS decoder API (I
> > > > > > recently posted an RFC for that, but I haven't had the time to
> > > > > > implement the few changes needed). It would be nice if rds
> > > > > > modulator support would be modeled after this demodulator API
> > > > > > if possible.
> > > > >
> > > > > I see. This is good. I think the best way is to have a rds
> > > > > modulator interface. This driver have implemented it as sys
> > > > > properties, as described above.
> > > >
> > > > I don't think there is that much overlap, though. The similarities
> > > > are probably limited to some flags.
> > > >
> > > > > > Does region information really belong in the driver? Perhaps
> > > > > > this should be in a user-space library? (just a suggestion, I'm
> > > > > > not sure at this stage).
> > > > >
> > > > > Ok. Yes, this could be better to implement in user land. However,
> > > > > depending on region that would restrict other properties as well.
> > > > > So, letting user space control that, would allow device operate
> > > > > in wrong intervals for frequencies for instance.
> > > >
> > > > But if you are in region A and you setup the device for region B,
> > > > then it's wrong as well, right?
> > > >
> > > > I also wonder if there are legal requirements that have to be
> > > > followed here?
> > >
> > > Yes, the region thing is somehow bound to limits of specific area
> > > rules / regulation. For instance, Europe frequencies limits are
> > > 	.bottom_frequency	= 8750,
> > > 	.top_frequency		= 10800,
> > >
> > >
> > > BTW, maybe I'm making some confusion, but is there two different APIs
> > > for radios? What is the difference in roles of things that goes into
> > > drivers/media/radio and drivers/media/common/tuners?
> >
> > common/tuners is for the tuner devices (usually i2c). But in
> > media/radio you find the actual v4l2 drivers. However, in a few cases
> > this split wasn't done and there is no separate i2c driver created for
> > the radio device: instead it is hardcoded into the v4l2 driver. This is
> > bad and should be avoided for new drivers. We didn't always pay enough
> > attention to this in the past.
>
> Good stuff. So I see a few things in this code I sent:
> 1. Move properties to extended controls

I think this is probably the best approach. You would need to make a new 
class for such controls (RADIO_MODULATOR or something).

> 2. Split driver into i2c driver (common/tunner?) and media/radio

Not common/tuner, I think it can just go into media/radio. As long as it is 
a stand-alone i2c driver that can be reused.

> Possibly the rds modulator thing as well, but I think this
> will be for future (after the demodulator is done)?

Yes. Finishing the RDS demodulator API according to my RFCv2 of that API is 
high on my list and I hope to do this by the end of this month. And I will 
also need to add some support to the extended control API to allow strings 
to be passed.

> Is that correct or I missed something?

Documentation! All these new controls have to be documented in the V4L2 
spec. Initially just write it up in a simple text document since there will 
be no doubt one or two more review cycles, so spending a lot of time on 
integrating it into the spec when it might change later isn't wise.

>
> > Regards,
> >
> > 	Hans
>
> BTW, thanks for the good reviewing.

You're welcome. Just be prepared that you may have to go through additional 
rewrites: this is actually the first modulator driver to be added to 
v4l-dvb, so we will have to carefully determine what the best API will be 
for this. Once the API is chosen we can't easily (if at all) change it in 
the future, so it's good not to rush things at this stage.

I think this is a very interesting time for the v4l subsystem in particular: 
for a long time it was limited to consumer TV capture cards which was 
rather a niche market. It's good to see companies involved in embedded 
systems to start contributing code, that should move this subsystem to a 
more professional level.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
