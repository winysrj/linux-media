Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab1IGDXP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 23:23:15 -0400
Message-ID: <4E66E3A0.5030406@redhat.com>
Date: Wed, 07 Sep 2011 00:23:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com>
In-Reply-To: <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-09-2011 23:58, Devin Heitmueller escreveu:
> On Tue, Sep 6, 2011 at 11:29 AM, Mauro Carvalho Chehab 
> <mchehab@redhat.com> wrote:
>> There are several issues with the original alsa_stream code that
>> got fixed on xawtv3, made by me and by Hans de Goede. Basically,
>> the code were re-written, in order to follow the alsa best
>> practises.
>> 
>> Backport the changes from xawtv, in order to make it to work on a 
>> wider range of V4L and sound adapters.
>> 
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Mauro,
> 
> What tuners did you test this patch with?

I tested with some em28xx-based devices, like HVR-950 and WinTV USB2.

> I went ahead and did a git pull of your patch series into my local
> git tree, and now my DVC-90 (an em28xx device) is capturing at 32 KHz
> instead of 48 (this is one of the snd-usb-audio based devices, not
> em28xx-alsa).

The new approach tries to match an speed that it is compatible between
the audio and the video card. The algorithm tries first to not use
software interpolation for audio, as it would reduce the audio quality.

If it can't do it without interpolation, it will enable interpolation
and seek again. By default, pulseaudio does interpolation, if you request
it to use a different resolution.

> Note I tested immediately before pulling your patch series and the 
> audio capture was working fine.



Had you test to disable pulseaudio and see what speeds your boards
accept? If you enable verbose mode, you'll see more details about
the device detection.


For example, this is what I get here with hvr-950, calling "tvtime -v":

alsa: starting copying alsa stream from hw:1,0 to hw:0,0
videoinput: Using video4linux2 driver 'em28xx', card 'Hauppauge WinTV HVR 950' (bus usb-0000:00:1d.7-1).
videoinput: Version is 196608, capabilities 5030051.
alsa: Capture min rate is 48000
alsa: Capture max rate is 48000
alsa: Playback min rate is 44100
alsa: Playback max rate is 192000
alsa: Will search a common rate between 48000 and 48000
alsa: Using Rate 48000
alsa: capture periods range between 2 and 98. Want: 2
alsa: capture period time range between 333 and 65334. Want: 15000
alsa: playback periods range between 2 and 32. Want: 4
alsa: playback period time range between 666 and 10922667. Want: 15000
alsa: capture period set to 2 periods of 15000 time
alsa: playback period set to 4 periods of 15333 time
alsa: Negociated configuration:
  stream       : PLAYBACK
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 2944
  period_size  : 736
  period_time  : 15333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 736
  period_event : 0
  start_threshold  : 1440
  stop_threshold   : 2944
  silence_threshold: 0
  silence_size : 0
  boundary     : 1543503872
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 1440
  period_size  : 720
  period_time  : 15000
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 720
  period_event : 0
  start_threshold  : 720
  stop_threshold   : 1440
  silence_threshold: 0
  silence_size : 0
  boundary     : 1509949440
alsa: Parameters are 48000Hz, S16_LE, 2 channels
alsa: Set bitrate to 48000, buffer size is 1440
alsa: stream started from hw:1,0 to hw:0,0 (48000 Hz, buffer delay = 30,00 ms)

And those are the results with WinTV USB2:

videoinput: Using video4linux2 driver 'em28xx', card 'Hauppauge WinTV USB 2' (bus usb-0000:00:1d.7-1).
videoinput: Version is 196608, capabilities 5030041.
alsa: starting copying alsa stream from hw:1,0 to hw:0,0
alsa: Capture min rate is 32000
alsa: Capture max rate is 32000
alsa: Playback min rate is 44100
alsa: Playback max rate is 192000
alsa: Will search a common rate between 44100 and 32000
alsa: Couldn't find a rate that it is supported by both playback and capture
alsa: Trying plughw:0,0 for playback
alsa: Resample enabled.
alsa: Capture min rate is 32000
alsa: Capture max rate is 32000
alsa: Playback min rate is 4000
alsa: Playback max rate is 4294967295
alsa: Will search a common rate between 32000 and 32000
alsa: Using Rate 32000
alsa: capture periods range between 2 and 1024. Want: 2
alsa: capture period time range between 500 and 4096000. Want: 15000
alsa: playback period time range between 333 and 5461334. Want: 15000
alsa: capture period set to 2 periods of 15000 time
alsa: playback period set to 4 periods of 15000 time
alsa: Negociated configuration:
  stream       : PLAYBACK
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 32000
  exact rate   : 32000 (32000/1)
  msbits       : 16
  buffer_size  : 1920
  period_size  : 480
  period_time  : 15000
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 480
  period_event : 0
  start_threshold  : 960
  stop_threshold   : 1920
  silence_threshold: 0
  silence_size : 0
  boundary     : 503316480
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 32000
  exact rate   : 32000 (32000/1)
  msbits       : 16
  buffer_size  : 960
  period_size  : 480
  period_time  : 15000
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 480
  period_event : 0
  start_threshold  : 480
  stop_threshold   : 960
  silence_threshold: 0
  silence_size : 0
  boundary     : 2013265920
alsa: Parameters are 32000Hz, S16_LE, 2 channels
alsa: Set bitrate to 32000 with resample enabled at playback, buffer size is 960
alsa: stream started from hw:1,0 to plughw:0,0 (32000 Hz, buffer delay = 30,00 ms)

You should notice that snd-usb-audio only reports 32 kHz speed for this
device.

> I think this patch series is going in the right direction in
> general, but this patch in particular seems to cause a regression.
> Is this something you want to investigate?  I think we need to hold
> off on pulling this series into the new tvtime master until this
> problem is resolved.
> 
> Devin
> 

/
