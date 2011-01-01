Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34391 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1AAUwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 15:52:37 -0500
Received: by eye27 with SMTP id 27so5556216eye.19
        for <linux-media@vger.kernel.org>; Sat, 01 Jan 2011 12:52:35 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 1 Jan 2011 15:52:35 -0500
Message-ID: <AANLkTi=3ekVmf-gVU=bO2dHn4svMbExZ3TKGeiV1Jrrd@mail.gmail.com>
Subject: V4L2 spec behavior for G_TUNER and T_STANDBY
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I have been doing some application conformance for VLC, and I noticed
something interesting with regards to the G_TUNER call.

If you have a tuner which supports sleeping, making a G_TUNER call
essentially returns garbage.
===
root@devin-laptop2:~# v4l2-ctl -d /dev/video1 --get-tuner
Tuner:
    Name                 : Auvitek tuner
    Capabilities         : 62.5 kHz stereo lang1 lang2
    Frequency range      : 0.0 MHz - 0.0 MHz
    Signal strength/AFC  : 0%/0
    Current audio mode   : stereo
    Available subchannels: mono
===
Note that the frequency range is zero (the capabilities and name are
populated by the bridge or video decoder).  Some digging into the
tuner_g_tuner() function in tuner core shows that the check_mode()
call fails because the device's mode is T_STANDBY.  However, it does
this despite the fact that none of values required actually interact
with the tuner.  The capabilities and frequency ranges should be able
to be populated regardless of whether the device is in standby.

This is particularly bad because devices normally come out of standby
when a s_freq call occurs, but some applications (such as VLC) will
call g_tuner first to validate the target frequency is inside the
valid frequency range.  So you have a chicken/egg problem:  The
g_tuner won't return a valid frequency range until you do a tuning
request to wake up the tuner, but apps like VLC won't do a tuning
request unless it has validated the frequency range.

Further, look at the following block:

        if (t->mode != V4L2_TUNER_RADIO) {
                vt->rangelow = tv_range[0] * 16;
                vt->rangehigh = tv_range[1] * 16;
                return 0;
        }

This basically means that a video tuner will bail out, which sounds
good because the rest of the function supposedly assumes a radio
device.  However, as a result the has_signal() call (which returns
signal strength) will never be executed for video tuners.  You
wouldn't notice this if a video decoder subdev is responsible for
showing signal strength, but if you're expecting the tuner to provide
the info, the call will never happen.

Are these known issues?  Am I misreading the specified behavior?  I
don't see anything in the spec that suggests that this call should
return invalid data if the tuner happens to be powered down.

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
