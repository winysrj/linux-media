Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2ESSRM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 14:17:12 -0400
Message-ID: <4FB7E489.10803@redhat.com>
Date: Sat, 19 May 2012 20:20:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Ondrej Zary <linux@rainbow-software.org>
Subject: RFC: V4L2 API and radio devices with multiple tuners
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans et all,

Currently the V4L2 API does not allow for radio devices with more then 1 tuner,
which is a bit of a historical oversight, since many radio devices have 2
tuners/demodulators 1 for FM and one for AM. Trying to model this as 1 tuner
really does not work well, as they have 2 completely separate frequency bands
they handle, as well as different properties (the FM part usually is stereo
capable, the AM part is not).

It is important to realize here that usually the AM/FM tuners are part
of 1 chip, and often have only 1 frequency register which is used in
both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
and from a V4L2 API pov these modes are best modeled as 2 tuners.
This is at least true for the radio-cadet card and the tea575x,
which are the only 2 AM capable radio devices we currently know about.

Currently the V4L2 spec says the following on this subject:
http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html
"Radio devices have exactly one tuner with index zero, no video inputs."

This text can easily be changed into allowing multiple tuners, without
any API change from the app pov, existing apps will be limited to
accessing just the first tuner though (probably best to always
make this the FM one).

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html
"... call the VIDIOC_S_TUNER ioctl. This will not change the current tuner,
which is determined by the current video input."

This is a problem, video devices when they have multiple tuners often
do so with the purpose of being able to watch/record multiple channels
at the same time, and thus multiple tuners are usually connected to
different inputs / frame-grabbers, and the input <-> tuner mapping done
for video devices makes sense there.

As the spec states, radio devices have no video inputs, so
VIDIOC_S_INPUT cannot be used on them. Which means we need another
way to get/set the active tuner (the tuner mode) for a radio device.

Lets look at the getting of the active tuner first. We cannot use
VIDIOC_G_TUNER for this, since this is used to enumerate tuners,
so it should return info on the tuner with the specified index,
rather then the active tuner.

VIDEOC_G_FREQUENCY otoh looks like a good candidate to use for this,
for radio devices we can simply ignore the passed in tuner field,
and instead return the active tuner and the current frequency.
This means there will be no way to get the frequency for the non
active tuner (mode), this is fine, since the non active tuner
does not have a (valid) frequency anyways.

If we choose for VIDIOC_G_FREQUENCY to always return info on the
active tuner it makes sense to use VIDIOC_S_FREQUENCY to select
the active tuner. So for radio devices it will not only change
the currently tuned frequency for the indicated tuner, but if
the indicated tuner was not the active tuner it will make it the
active tuner.

Which leaves the question of what to do with VIDIOC_S_HW_FREQ_SEEK,
since VIDIOC_S_HW_FREQ_SEEK needs a valid begin frequency as a pre
condition, and the frequency ranges differ between different
tuners it makes sense to only allow VIDIOC_S_HW_FREQ_SEEK on
the active tuner. So this leaves one last problem, what to
return from VIDIOC_S_HW_FREQ_SEEK if it tries to seek for
a non active tuner. I'm tending towards saying -EBUSY, since some
parts of the tuners are shared, so the non active tuner cannot
seek because those shared parts are otherwise used.

Regards,

Hans
