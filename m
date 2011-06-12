Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1FLO2h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:28:37 -0400
Message-ID: <4DF4CD0F.3030909@redhat.com>
Date: Sun, 12 Jun 2011 11:28:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner
 mode.
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>	<201106121430.03114.hverkuil@xs4all.nl>	<1307883186.2592.10.camel@localhost>	<201106121523.15127.hverkuil@xs4all.nl>	<1307886285.2592.31.camel@localhost> <BANLkTiktMGy_7e0VDs=VDy0rb1rZwk9rXw@mail.gmail.com>
In-Reply-To: <BANLkTiktMGy_7e0VDs=VDy0rb1rZwk9rXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 10:57, Devin Heitmueller escreveu:
> On Sun, Jun 12, 2011 at 9:44 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> BTW, the cx18-alsa module annoys me as a developer.  PulseAudio holds
>> the device nodes open, pinning the cx18-alsa and cx18 modules in kernel.
>> When killed, PulseAudio respawns rapidly and reopens the nodes.
>> Unloading cx18 for development purposes is a real pain when the
>> cx18-alsa module exists.
> 
> We've talked about this before, but something just feels wrong about
> this.  I don't have this problem with other drivers that provide an
> "-alsa" module.  For example, my ngene tree has four ALSA PCM devices
> and 16 mixer controls, yet PulseAudio doesn't keep the module in use.
> 
> The more I think about this, the more I suspect this is just some sort
> of subtle bug in the cx18 ALSA driver where some resource is not being
> freed.

It is not just cx18 that have this trouble. All drivers under media/video
with *-alsa have this issue. Also, all sound drivers suffer from the same 
issue:

# lsmod|grep snd_hda
snd_hda_codec_analog    84955  1 
snd_hda_intel          25261  2 

See: pulseaudio keep the device opened, so dev refcount were incremented.

# rmmod snd_hda_codec_analog snd_hda_intel 
ERROR: Module snd_hda_codec_analog is in use
ERROR: Module snd_hda_intel is in use

The same happens, for example, with em28xx with snd-usb-audio:

# lsmod |grep snd
snd_usb_audio          91303  1 

# rmmod snd-usb-audio
ERROR: Module snd_usb_audio is in use

What happens is that open() increments the device refcount.

Maybe the ngene has some trick for allowing it, or PulseAudio has some logic to 
detect ngene (or otherwise it fails to open ngene audio nodes).

It may have some dirty ways to trick PulseAudio, for example returning -ENODEV if
the process name is pulseaudio, but I can't think on a proper kernel solution
for it.

The proper solution is to fix PulseAudio.

Cheers,
Mauro
