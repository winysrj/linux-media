Return-path: <linux-media-owner@vger.kernel.org>
Received: from ny01.nytud.hu ([193.6.194.1]:34382 "EHLO ny01.nytud.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaGFSCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jul 2014 14:02:14 -0400
Received: (from oravecz@localhost)
	by ny01.nytud.hu (8.11.6/8.11.6) id s66HpRN32267
	for linux-media@vger.kernel.org; Sun, 6 Jul 2014 19:51:27 +0200
Message-Id: <201407061751.s66HpRN32267@ny01.nytud.hu>
Subject: HVR 900 (USB ID 2040:6500) loses sound with recent em28xx drivers
To: linux-media@vger.kernel.org
Date: Sun, 6 Jul 2014 19:51:27 +0200 (CEST)
Reply-To: oravecz@nytud.mta.hu
From: Oravecz Csaba <oravecz@nytud.mta.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I see there has been a major rewrite of em28xx (and some related)
drivers and this card somehow might have fallen victim to it.
It's been working fairly steadily so far but now sound is gone.

There is some conspicuous difference in logs (see below), however, being
nothing more just a naive end user I have no idea whether it is relevant or not.

Working 'old' drivers:

[357377.630498] em2882/3 #0: Config register raw data: 0x50
[357377.631455] em2882/3 #0: AC97 vendor ID = 0xffffffff
[357377.631875] em2882/3 #0: AC97 features = 0x6a90
[357377.631880] em2882/3 #0: Empia 202 AC97 audio processor detected

Not working current drivers from git:

nothing like the above just this as far as audio is concerned:

[  432.256779] em28xx audio device (2040:6500): interface 1, class 1
[  432.256809] em28xx audio device (2040:6500): interface 2, class 1
...
[  432.291066] usbcore: registered new interface driver snd-usb-audio

Card seems to be present:

arecord -l:
card 1: HVR900 [WinTV HVR-900], device 0: USB Audio [USB Audio]
Subdevices: 1/1
Subdevice #0: subdevice #0

but gives only these errors with xawtv (i'm not sure these are of any help):
ALSA lib pcm.c:7843:(snd_pcm_recover) overrun occurred
ALSA lib pcm.c:7843:(snd_pcm_recover) underrun occurred

and these with tvtime:
videoinput: Can't mute card.  Post a bug report with your
videoinput: driver info to http://tvtime.net/
videoinput: Include this error: 'Invalid argument'

None of these is present with the older drivers (working well e.g.
in Fedora stock 3.9.5 kernel), when using e.g.
arecord -D hw:1,0 -f dat | aplay -
to play the analog sound.

As an added bonus there are nice kernel oops with most recent drivers now
losing video as well (this problem is not there yet e.g. with 
Fedora stock 3.14.8 kernel i'm using, 
there is only the sound issue there, video is ok)

WARNING: CPU: 1 PID: 0 at /home/oravecz/src/kernel/media_build/v4
l/videobuf2-core.c:1165 vb2_buffer_done+0x1fa/0x220 [videobuf2_core]()
...

WARNING: CPU: 0 PID: 4706 at /home/oravecz/src/kernel/media_build/v4l/videobuf2-core.c:2091__vb2_queue_cancel+0x180/0x220 [videobuf2_core]()
...

I can send full logs if needed but perhaps this can already give some hint if
something might have gone wrong or else I might be blundering something.

best,
o.cs.

