Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38648 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424070Ab2LGDV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 22:21:59 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so26809qcr.19
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 19:21:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C1490E.8040203@pyther.net>
References: <50B5779A.9090807@pyther.net>
	<50B67851.2010808@googlemail.com>
	<50B69037.3080205@pyther.net>
	<50B6967C.9070801@iki.fi>
	<50B6C2DF.4020509@pyther.net>
	<50B6C530.4010701@iki.fi>
	<50B7B768.5070008@googlemail.com>
	<50B80FBB.5030208@pyther.net>
	<50BB3F2C.5080107@googlemail.com>
	<50BB6451.7080601@iki.fi>
	<50BB8D72.8050803@googlemail.com>
	<50BCEC60.4040206@googlemail.com>
	<50BD5CC3.1030100@pyther.net>
	<CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
	<50BD6310.8000808@pyther.net>
	<CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com>
	<50BE65F0.8020303@googlemail.com>
	<50BEC253.4080006@pyther.net>
	<50BF3F9A.3020803@iki.fi>
	<50BFBE39.90901@pyther.net>
	<50BFC445.6020305@iki.fi>
	<50BFCBBB.5090407@pyther.net>
	<50BFECEA.9060808@iki.fi>
	<50BFFFF6.1000204@pyther.net>
	<50C11301.10205@googlemail.com>
	<50C12302.80603@pyther.net>
	<50C1490E.8040203@pyther.net>
Date: Thu, 6 Dec 2012 22:21:58 -0500
Message-ID: <CAGoCfiwCUhBdkL3c9ppB42s5UpqooWP5P=H454ff_+4Jzxom4w@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matthew Gyurgyik <matthew@pyther.net>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:40 PM, Matthew Gyurgyik <matthew@pyther.net> wrote:
> I was able to do a bit of testing tonight and this is what I found.
>
> A channel scan was unsuccessful:
> http://pyther.net/a/digivox_atsc/dec06/scan.txt (no errors in dmesg)
>
> Changing channels by pressing "h" in "mplayer dvb://" caused mplayer to
> crash and this messages to be logged in dmesg
> http://pyther.net/a/digivox_atsc/dec06/dmesg_mplayer_switch_channels.txt

This looks like a combination of a misconfiguration of GPIOs and
mplayer not properly handling an exception condition.  You should
definitely bring this up with the mplayer developers since their app
shouldn't crash under this circumstance.

> Audio is out-of-sync in mplayer. Using cache helps, but over time the audio
> still goes out of sync.
> http://pyther.net/a/digivox_atsc/dec06/mplayer_audio_out_of_sync.txt

This has nothing to do with the tuner.  The tuner delivers the MPEG2
stream already compressed and synchronized.  If you're playback is
out-of-sync, it's probably your ALSA drivers, PulseAudio, or mplayer
that is the culprit.

> Using azap to tune and using cat /dev/dvb/adapter0/dvr0 > test.mpg to
> generate a test.mpg
>
> mplayer plays the file fine without audio-sync issues, but VLC and Xine
> refuse to play it. (is this normal?)

What errors are VLC or Xine showing?  Unless the stream is really
corrupt VLC and Xine should play it fine.  And if the stream were
corrupt it wouldn't play with mplayer either?  This sounds like bugs
in VLC and Xine.

There's definitely something going on in the tuner which is causing
the channel scan to fail (and probably the tuning failure in mplayer).
 But all the stuff with actual playback causing segfaults, A/V sync
issues, and failures to play back in certain applications are all
userland problems that you would need to raise with the developers for
those respective projects.

Cheers,

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
