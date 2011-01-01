Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4903 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1AAVSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 16:18:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: V4L2 spec behavior for G_TUNER and T_STANDBY
Date: Sat, 1 Jan 2011 22:18:36 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTi=3ekVmf-gVU=bO2dHn4svMbExZ3TKGeiV1Jrrd@mail.gmail.com>
In-Reply-To: <AANLkTi=3ekVmf-gVU=bO2dHn4svMbExZ3TKGeiV1Jrrd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101012218.36967.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, January 01, 2011 21:52:35 Devin Heitmueller wrote:
> I have been doing some application conformance for VLC, and I noticed
> something interesting with regards to the G_TUNER call.
> 
> If you have a tuner which supports sleeping, making a G_TUNER call
> essentially returns garbage.
> ===
> root@devin-laptop2:~# v4l2-ctl -d /dev/video1 --get-tuner
> Tuner:
>     Name                 : Auvitek tuner
>     Capabilities         : 62.5 kHz stereo lang1 lang2
>     Frequency range      : 0.0 MHz - 0.0 MHz
>     Signal strength/AFC  : 0%/0
>     Current audio mode   : stereo
>     Available subchannels: mono
> ===
> Note that the frequency range is zero (the capabilities and name are
> populated by the bridge or video decoder).  Some digging into the
> tuner_g_tuner() function in tuner core shows that the check_mode()
> call fails because the device's mode is T_STANDBY.  However, it does
> this despite the fact that none of values required actually interact
> with the tuner.  The capabilities and frequency ranges should be able
> to be populated regardless of whether the device is in standby.

Agreed.

> This is particularly bad because devices normally come out of standby
> when a s_freq call occurs, but some applications (such as VLC) will
> call g_tuner first to validate the target frequency is inside the
> valid frequency range.  So you have a chicken/egg problem:  The
> g_tuner won't return a valid frequency range until you do a tuning
> request to wake up the tuner, but apps like VLC won't do a tuning
> request unless it has validated the frequency range.
> 
> Further, look at the following block:
> 
>         if (t->mode != V4L2_TUNER_RADIO) {
>                 vt->rangelow = tv_range[0] * 16;
>                 vt->rangehigh = tv_range[1] * 16;
>                 return 0;
>         }
> 
> This basically means that a video tuner will bail out, which sounds
> good because the rest of the function supposedly assumes a radio
> device.  However, as a result the has_signal() call (which returns
> signal strength) will never be executed for video tuners.  You
> wouldn't notice this if a video decoder subdev is responsible for
> showing signal strength, but if you're expecting the tuner to provide
> the info, the call will never happen.

I am not aware of any tuner that does that. I think that for video this
is always done by a video decoder. That said, it isn't pretty, but a lot
of this is legacy code and I wouldn't want to change it.
 
> Are these known issues?

No.

> Am I misreading the specified behavior?  I
> don't see anything in the spec that suggests that this call should
> return invalid data if the tuner happens to be powered down.

You are correct, G_TUNER should return valid data, even when powered down.
I suspect that G_FREQUENCY has the same problem.

This should be fixed so that both work when the tuner is powered down.

And if this is fixed, then the switch_v4l2, using_v4l2 and check_v4l2 symbols
can also be removed since they are no longer in use.


After digging some more I think that check_mode is a poor function. There are
two things that check_mode does: checking if the tuner support radio and/or tv
mode (that's fine), and if it is in standby: not so fine. That should be a
separate function since filling in frequency ranges can be done regardless of
the standby state.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
