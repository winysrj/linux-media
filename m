Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4528 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FKR12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:27:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
Date: Sat, 11 Jun 2011 19:27:15 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <2a85334a8d3f0861fc10f2d6adbf46946d12bb0e.1307798213.git.hans.verkuil@cisco.com> <4DF373B3.4000601@redhat.com>
In-Reply-To: <4DF373B3.4000601@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111927.15981.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 15:54:59 Mauro Carvalho Chehab wrote:
> Em 11-06-2011 10:34, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > According to the spec the tuner type field is not used when calling
> > S_TUNER: index, audmode and reserved are the only writable fields.
> > 
> > So remove the type check. Instead, just set the audmode if the current
> > tuner mode is set to radio.
> 
> I suspect that this patch also breaks support for a separate radio tuner.
> if tuner-type is not properly filled, then the easiest fix would be to
> revert some changes done at the tuner cleanup/fixup patches applied on .39.
> Yet, the previous logic were trying to hint the device mode, with is bad
> (that's why it was changed).
> 
> The proper change seems to add a parameter to this callback, set by the
> bridge driver, informing if the device is using radio or video mode.
> We need also to patch the V4L API specs, as it allows using a video node
> for radio, and vice versa. This is not well supported, and it seems silly
> to keep it at the specs and needing to add hints at the drivers due to
> that.

So, just to make sure I understand correctly what you want. The bridge or
platform drivers will fill in the vf->type (for g/s_frequency) or vt->type
(for g/s_tuner) based on the device node: RADIO if /dev/radio is used,
TV for anything else.

What about VIDIOC_S_FREQUENCY? The spec says that the app needs to fill this
in. Will we just overwrite vf->type or will we check and return -EINVAL if
the app tries to set e.g. a TV frequency on /dev/radio?

Is VIDIOC_S_FREQUENCY allowed to change the tuner mode? E.g. if /dev/radio was
opened, and now I open /dev/video and call S_FREQUENCY with the TV tuner type,
should that change the tuner to tv mode?

I think the type passed to S_FREQUENCY should 1) match the device node's type
(if not, then return -EINVAL) and 2) should match the current mode (if not,
then return -EBUSY). So attempts to change the TV frequency when in radio
mode should fail. This second rule should also be valid for S_TUNER.

What should G_TUNER return on a video node when in radio mode or vice versa?
For G_FREQUENCY you can still return the last used frequency, but that's
much more ambiguous for G_TUNER. One option is to set rxsubchans, signal and
afc all to 0 if you query G_TUNER when 'in the wrong mode'.

The VIDIOC_G/S_MODULATOR ioctls do not have a type and they are RADIO only,
so that's OK.

And how do we switch between radio and TV? Right now opening the radio node
will set the tuner in radio mode, and calling S_STD will change the mode to
TV again. As mentioned above, what S_FREQUENCY is supposed to do is undefined
at the moment.

What about this:

Opening /dev/radio effectively starts the radio mode. So if there is TV
capture in progress, then the open should return -EBUSY. Otherwise it
switches the tuner to radio mode. And it stays in radio mode until the
last filehandle of /dev/radio is closed. At that point it will automatically
switch back to TV mode (if there is one, of course).

While it is in radio mode calls to S_STD and S_FREQUENCY from /dev/video
will return -EBUSY. Any attempt to start streaming from /dev/video will
also return -EBUSY (radio 'streaming' is in progress after all).

Effectively, S_STD no longer switches back to TV mode. That only happens when
the last user of /dev/radio left. It certainly sounds a lot saner to me.

Of course, I'm ignoring DVB in this story. You may have to negotiate between
radio, Tv and DVB.

Anyway, this all sounds very nice, but it's a heck of a lot of work. I'd much
rather just fix this bug without changing the spec and behavior of drivers.
That's a nice project perhaps for a rainy day (or week...), but not for a fix
that is needed asap and that works for kernel v3.0.

The whole radio/tv/dvb tuner selection is a big mess and needs to be solved,
but let's do that in a separate project.

Regards,

	Hans
