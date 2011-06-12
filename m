Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1568 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1FLMaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 08:30:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
Date: Sun, 12 Jun 2011 14:30:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <4DF4AA3F.5040005@redhat.com> <4DF4AD6A.3080003@redhat.com>
In-Reply-To: <4DF4AD6A.3080003@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121430.03114.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 12, 2011 14:13:30 Mauro Carvalho Chehab wrote:
> Em 12-06-2011 08:59, Mauro Carvalho Chehab escreveu:
> > Em 12-06-2011 08:36, Hans Verkuil escreveu:
> >>>> What about this:
> >>>>
> >>>> Opening /dev/radio effectively starts the radio mode. So if there is TV
> >>>> capture in progress, then the open should return -EBUSY. Otherwise it
> >>>> switches the tuner to radio mode. And it stays in radio mode until the
> >>>> last filehandle of /dev/radio is closed. At that point it will automatically
> >>>> switch back to TV mode (if there is one, of course).
> >>>
> >>> No. This would break existing applications. The mode switch should be done
> >>> at S_FREQUENCY (e. g. when the radio application is tuning into a channel).
> >>
> >> This is not what happens today as the switch to radio occurs as soon as you open
> >> the radio node. It's the reason for the s_radio op.
> > 
> > The s_radio op is something that I wanted to remove. It was there in the past to feed
> > the TV/radio hint logic. I wrote a patch for it, but I ended by discarding from my
> > final queue (I can't remember why).
> > 
> > I think that the hint logic were completely removed, but we may need to take a look
> > on the callers for s_radio. I'll check it right now.
> > 
> 
> The s_radio callback requires some care, as it is used on several places. It is probably
> safe to remove it from tuner, but a few sub-drivers like msp3400 needs it. The actual
> troubles seem to happen at the bridge drivers that call it during open(). It should be
> called only at s_frequency. I opted to keep the callback just to avoid having a bridge
> driver switching its registers to radio mode, and not having the tuner following it.
> 
> If we move the radio mode switch at the bridge drivers to s_frequency only, we can just
> remove this callback from tuner, letting it to be implemented only at the audio decoders.

Why would the audio decoders need it? If we do the mode switch when s_freq is
called, then the audio decoders can do the same and s_radio can disappear completely.

I would like that, but I'm a bit afraid of application breakage since we're changing
the behavior of /dev/radio. It seems that pretty much every video driver with radio
capability is calling s_radio during open(): bttv, ivtv, saa7134, usbvision, em28xx,
cx18, cx88, cx231xx and tm6000.

Regards,

	Hans
