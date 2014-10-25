Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:45857 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaJYSzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 14:55:05 -0400
Date: Sat, 25 Oct 2014 10:44:48 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Lars-Peter Clausen <lars@metafoo.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"ramakrmu@cisco.com" <ramakrmu@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	prabhakar.csengg@gmail.com, Antti Palosaari <crope@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	"olebowle@gmx.com" <olebowle@gmx.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
Message-id: <20141025104448.41d9b1f0.m.chehab@samsung.com>
In-reply-to: <544804F1.7090606@linux.intel.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
 <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
 <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com>
 <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com>
 <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com>
 <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl>
 <s5hbnp5z9uy.wl-tiwai@suse.de>
 <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
 <544804F1.7090606@linux.intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Oct 2014 14:26:41 -0500
Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com> escreveu:

> On 10/21/14, 11:08 AM, Devin Heitmueller wrote:
> >> Sorry, I'm not convinced by that.  If the device has to be controlled
> >> exclusively, the right position is the open/close.  Otherwise, the
> >> program cannot know when it becomes inaccessible out of sudden during
> >> its operation.
> >
> > I can say that I've definitely seen cases where if you configure a
> > device as the "default" capture device in PulseAudio, then pulse will
> > continue to capture from it even if you're not actively capturing the
> > audio from pulse.  I only spotted this because I had a USB analyzer on
> > the device and was dumbfounded when the ISOC packets kept arriving
> > even after I had closed VLC.
> 
> this seems like a feature, not a bug. PulseAudio starts streaming before 
> clients push any data and likewise keeps sources active even after for 
> some time after clients stop recording. Closing VLC in your example 
> doesn't immediately close the ALSA device. look for 
> module-suspend-on-idle in your default.pa config file.

This could be a feature for an audio capture device that is standalone,
but for sure it isn't a feature for an audio capture device where the
audio is only available if video is also being streamed.

A V4L device with ALSA capture is a different beast than a standalone
capture port. In a simplified way, it will basically follow the following
state machine:

     +---------------+
     |     start     |
     +---------------+
       |
       |
       v
     +--------------------------------+
     |              idle              | <+
     +--------------------------------+  |
       |                ^           |    |
       |                |           |    |
       v                |           |    |
     +---------------+  |           |    |
     | configuration |  |           |    |
     +---------------+  |           |    |
       |                |           |    |
       |                |           |    |
       v                |           |    |
     +---------------+  |           |    |
  +> |   streaming   | -+           |    |
  |  +---------------+              |    |
  |    |                            |    |
  |    |                            |    |
  |    v                            v    |
  |  +---------------+-----------+----+  |
  +- |       1       | suspended |  2 | -+
     +---------------+-----------+----+


1) start state

This is when the V4L2 device gots probed. It checks if the hardware is
present and initializes some vars/registers, turning off everything
that can be powered down.

The tuner on put in sleep mode, analog audio/video decoders and the
dvb frontend and demux are also turned off.

2) idle state

As the device is powered off, audio won't produce anything. 

Depending on the device, reading for audio may return a sequence of 
zeros, or may even fail, as the DMA engine is not ready yet for
streaming.

Also, the audio mixer is muted, but the audio input switch is on a
random state.

2) configuration state

When V4L2 node device is opened and configured, the audio mixer will
be switched to input audio from the same source of the video stream.
The corresponding audio input is also unmuted. Almost all devices have 
at least two audio/video inputs: TV TUNER and COMPOSITE. Other devices
may also have S-VIDEO, COMPOSITE 2, RADIO TUNER, etc.

If the device is set on TUNER mode, on modern devices, a tuner firmware
will be loaded. That may require a long time. Typically, most devices
take 1/2 seconds to load a firmware, but some devices may take up to 30
seconds. The firmware may depend on the TV standard that will be used,
so this can't be loaded at driver warm up state. 

Also, the power consumption of the tuners is high (it can be ~100-200 mW
or more when powered, and ~16mW when just I2C is powered). We don't want
to keep it powered when the device is not used, as this spends battery.
Also, the life of the device reduces a lot if we keep it always powered.

During this stage, if an ALSA call is issued, it may interfere at the
device settings and/or firmware load, with can cause the audio to fail. 
On such cases, applications might need to close the V4L2 node and re-open
again.

3) streaming state

The change to this staging requires a V4L2 ioctl.

Please notice, however, that some apps will open the audio device before
the V4L2 node, while others will open it after that.

In any case, audio will only start to produce data after the V4L2 ioctl
at V4L2 that starts the DMA engine there.

After that ioctl:
 - Audio PCM capture will work;
 - The mixers will be in a good state: unmuted, and switched to the
   corresponding input as the video stream.

If the user wants to do something unusual, like mixing the composite audio
input with the tuner audio input, it can use the ALSA mixer for doing
that. Otherwise, the only part of the ALSA device that will be used is
the PCM engine.

4) streaming->stop transition

When the V4L2 device is closed (or an ioctl for stream stop is issued),
the driver will release the resources. What will be released vary from
driver to driver.

Some drivers will stop both audio and video DMA engine (as they actually
have just one DMA engine for both). Other devices will still be streaming
audio until the alsa trigger stops it.

In any case, the driver will put the tuner into sleep mode. Some drivers
do it immediately. Others will wait for a few seconds before doing that.

Ether way, from the PCM capture audio PoV, the device is now useless: it
will either not return anything, or it will just return a stream with
all zeros.

5) suspend/resume transitions

When the machine suspends to disk or memory, the DMA engine will stop, and
the devices will be powered off.

The logic of returning from suspend will depend on the previous state.

If the device were in stop pode, at resume time, it should return to 
idle state.

If the device is streaming, it should return to streaming state.
In such case, no ALSA ioctls should happen while V4L2 is suspending 
or resuming, otherwise the device will be on an unknown state, and
will only return to work after replugging the device.


> I also agree that the open/close of the alsa device is the only way to 
> control exclusion.

This will break apps, as they can open the alsa device before configuring
the stream with V4L2. They can also close alsa either before or after
stopping the V4L2 stream.

> -Pierre

-

As a reference, the state machine above came from this dot config, using
graph-easy to produce an ascii output:

digraph media {
  node [shape=record]
  suspended[label = "<streaming> 1 | <suspended> suspended | <idle> 2"]
  start -> idle
  idle -> configuration
  configuration -> streaming
  streaming -> idle
  idle -> "suspended":idle
  "suspended":idle -> idle
  streaming -> "suspended":streaming
  "suspended":streaming -> streaming
}
