Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1683 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2HMOwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:52:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Mon, 13 Aug 2012 16:52:11 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com>
In-Reply-To: <5028FD7E.1010402@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131652.11182.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 13 2012 15:13:34 Hans de Goede wrote:
> Hi,
> 
> <snip>
> 
> > 5) How to handle tuner ownership if both a video and radio node share the same
> >     tuner?
> >
> >     Obvious rules:
> >
> >     - Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will change owner
> >       or return EBUSY if streaming is in progress.
> 
> That won't work, as there is no such thing as streaming from a radio node,

There is, actually: read() for RDS data and alsa streaming (although that might
be hard to detect in the case of USB audio).

> I suggest we go with the simple approach we discussed at our last meeting in
> your Dutch House: Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will
> make an app the tuner-owner, and *closing* the device handle makes an app
> release its tuner ownership. If an other app already is the tuner owner
> -EBUSY is returned.

So the ownership is associated with a filehandle?

> 
> >     - Ditto for STREAMON, read/write and polling for read/write.
> 
> No, streaming and tuning are 2 different things, if an app does both, it
> will likely tune before streaming, but in some cases a user may use a streaming
> only app together with say v4l2-ctl to do the actual tuning. I think keeping
> things simple here is key. Lets just treat the "tuner" and "stream" as 2 separate
> entities with a separate ownership.

That would work provided the ownership is associated with a filehandle.

> 
> >     - Ditto for ioctls that expect a valid tuner configuration like QUERYSTD.
> 
> QUERY is a read only ioctl, so it should not be influenced by any ownership, nor
> imply ownership.

It is definitely influenced by ownership, since if the tuner is in radio mode,
then it can't detect a standard. Neither is this necessarily a passive call as
some (mostly older) drivers need to switch the receiver to different modes in
order to try and detect the current standard.

> >     - Just opening a device node should *not* switch ownership.
> Ack!
> 
> >     But it is not clear what to do when any of these ioctls are called:
> >
> >     - G_FREQUENCY: could just return the last set frequency for radio or TV:
> >       requires that that is remembered when switching ownership. This is what
> >       happens today, so G_FREQUENCY does not have to switch ownership.
> 
> Ack.
> 
> >     - G_TUNER: the rxsubchans, signal and afc fields all require ownership of
> >       the tuner. So in principle you would want to switch ownership when
> >       G_TUNER is called. On the other hand, that would mean that calling
> >       v4l2-ctl --all -d /dev/radio0 would change tuner ownership to radio for
> >       /dev/video0. That's rather unexpected.
> >
> >       It is possible to just set rxsubchans, signal and afc to 0 if the device
> >       node doesn't own the tuner. I'm inclined to do that.
> 
> Right, G_TUNER should not change ownership, if the tuner is currently in radio
> mode and a G_TUNER is done on the video node just 0 out the fields which we cannot
> fill with useful info.
> 
> >     - Should closing a device node switch ownership? E.g. if nobody has a radio
> >       device open, should the tuner switch back to TV mode automatically? I don't
> >       think it should.
> 
> +1 on delaying the mode switch until it is actually necessary to switch mode.
> 
> >     - How about hybrid tuners?
> 
> No opinion.

Regards,

	Hans
