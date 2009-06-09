Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1637 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZFIPqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 11:46:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv6 5 of 7] FMTx: si4713: Add files to add radio interface for si4713
Date: Tue, 9 Jun 2009 17:46:23 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
References: <1244449087-5543-1-git-send-email-eduardo.valentin@nokia.com> <20090609111111.GA16911@esdhcp037198.research.nokia.com> <200906091402.01581.hverkuil@xs4all.nl>
In-Reply-To: <200906091402.01581.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091746.23411.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 09 June 2009 14:02:01 Hans Verkuil wrote:
> On Tuesday 09 June 2009 13:11:11 Eduardo Valentin wrote:
> > Hi Hans,
> >
> > On Tue, Jun 09, 2009 at 12:41:38PM +0200, ext Hans Verkuil wrote:
>
> <snip>
>
> > > > +static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
> > > > +     .vidioc_g_input         = radio_si4713_vidioc_g_input,
> > > > +     .vidioc_s_input         = radio_si4713_vidioc_s_input,
> > > > +     .vidioc_g_audio         = radio_si4713_vidioc_g_audio,
> > > > +     .vidioc_s_audio         = radio_si4713_vidioc_s_audio,
> > > > +     .vidioc_querycap        = radio_si4713_vidioc_querycap,
> > > > +     .vidioc_queryctrl       = radio_si4713_vidioc_queryctrl,
> > > > +     .vidioc_g_ext_ctrls     = radio_si4713_vidioc_g_ext_ctrls,
> > > > +     .vidioc_s_ext_ctrls     = radio_si4713_vidioc_s_ext_ctrls,
> > > > +     .vidioc_g_ctrl          = radio_si4713_vidioc_g_ctrl,
> > > > +     .vidioc_s_ctrl          = radio_si4713_vidioc_s_ctrl,
> > > > +     .vidioc_g_tuner         = radio_si4713_vidioc_g_tuner,
> > > > +     .vidioc_s_tuner         = radio_si4713_vidioc_s_tuner,
> > >
> > > It's a modulator device, so it should implement g/s_modulator rather
> > > than g/s_tuner.
> > >
> > > Now, here I am running into a problem: looking at section 1.6.2 in
> > > the v4l2 spec I see that in QUERYCAP you are supposed to return
> > > CAP_TUNER and rely on ENUMOUTPUT to determine which output has a
> > > modulator. I think it is nuts that there is no CAP_MODULATOR. I
> > > propose adding this. There are currently NO modulator drivers in
> > > v4l-dvb, nor have I ever heard from out-of-tree modulator drivers
> > > (not that I particularly care about that), so it should be safe to
> > > add it.
> > >
> > > The next problem is that ENUMOUTPUT does not apply to a radio
> > > modulator. This problem is actually also present on radio tuners.
> > > Currently all radio tuner drivers implement g/s_input and g/s_audio
> > > but no enuminput or enumaudio.
> > >
> > > I think g/s_input is bogus since these devices have no video inputs.
> > > However, neither g/s_audio nor enumaudio can currently tell the
> > > application whether the audio input is connected to a tuner. Only
> > > enuminput can do that currently. This would be an argument for using
> > > g/s_input if it wasn't for the fact that none of the radio drivers
> > > actually implements enuminput.
> > >
> > > I propose adding a V4L2_AUDCAP_TUNER capability telling this
> > > application that the audio input is connected to a tuner, and adding
> > > a
> > > V4L2_AUDOUTCAP_MODULATOR capability for struct v4l2_audioout to do
> > > the same for a modulator.
> > >
> > > Comments?
> >
> > Ok. Here comes the real needed changes to support the radio modulator.
> > You may not remember, but in previous versions of this series I
> > commented that this driver was fully based on fm receiver existing
> > drivers.
> >
> > I think that's why I went in the mistake of implementing g_audio,
> > s_audio instead of g_audout, s_audout. Also, the same mistake of
> > implementing the s,g_input done in fm receiver drivers was repeated
> > here.
> >
> > Also, I think another thing has biased me to add this wrong callbacks.
> > I use fmtools to test the driver, for setting fm freq for instance.
> >
> > I admit, there are wrong callbacks.
> >
> > So, I'd ask which application to use to test the driver ?
>
> You have the honor of adding the first modulator driver to the kernel, so
> there are no apps yet. That said, I suggest adding support for
> g/s_modulator to the v4l2-ctl tool (in v4l2-apps/util). It's the swiss
> army knife utility of v4l2 and can call most ioctls from the command
> line.
>
> > About the suggested changes (adding V4L2_AUDCAP_TUNER and
> > V4L2_AUDOUTCAP_MODULATOR), I think it is a reasonable way to do it.
> > However, it'd be nice to hear more opinions. But, if I understood
> > correctly, this would be the method to determine if the driver is a fm
> > transmitter (aka modulator) ?
>
> The CAP_MODULATOR capability is used to determine if the driver supports
> a modulator, and the new capabilities for v4l2_audio and v4l2_audioout
> can be used to determine which audio input/output is hooked up to a tuner
> or modulator. In theory there may be multiple inputs and outputs where
> some are connected to a tuner/modulator and others are straight
> inputs/outputs.
>
> It is common for video capture cards (tuner input vs. Composite/Line-In
> inputs), but there is a case to be made that this is very unlikely for
> radio tuners/modulators. So perhaps I'm paranoid :-)
>
> Actually, looking at it a bit closer it is not enough to just set the
> capability, you also need to set the index of the associated tuner or
> modulatory, which would mean using one of the reserved fields.
>
> Hmm, this is getting complicated. Perhaps we should just add a
> CAP_MODULATOR capability and leave it at that for now. I think the
> MODULATOR capability is really needed, otherwise there is no easy way to
> check whether it is a tuner or modulator device.
>
> Regards,
>
> 	Hans

I've made a separate tree that adds support for a string control type and 
for a modulator capability. It also adds modulator support to the v4l2-ctl 
utility.

Note that strings are NOT automatically copied between kernel and userspace, 
you will have to do that manually. I thought about it, but that would mean 
allocating memory, copying from user to kernel space, and then the driver 
will normally copy it again into some local buffer. Better to let the 
driver do the copying.

My tree doesn't contain the subdev changes, so you will have to pull from 
both my v4l-dvb-str tree and my v4l-dvb-subdev tree.

The string implementation is very simple: just set the new length field to 
the size of the char buffer and point the new string field to that buffer.

It's just to play with, let's see how well it works.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
