Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1E2Ojd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 10:39:33 -0400
Message-ID: <4DE25AA1.2050707@redhat.com>
Date: Sun, 29 May 2011 11:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE237D9.8090306@redhat.com>
In-Reply-To: <4DE237D9.8090306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-05-2011 09:11, Mauro Carvalho Chehab escreveu:
> Em 29-05-2011 08:19, Hans Verkuil escreveu:

>>> 	enum device_type {
>>> 		UNKNOWN = 65535,
>>> 		NONE    = 65534,
>>> 		MEDIA_V4L_VIDEO = 0,
>>
>> Can you add MEDIA_V4L_RADIO as well? And MEDIA_V4L_SUBDEV too.

>> It might be better to start at a new offset here, e.g. MEDIA_DVB_FRONTEND = 100
>> Ditto for SND. That makes it easier to insert new future device nodes.
> 
> Good point.

>>> 	char *media_device_type(enum device_type type);
>>
>> const char *?
> 
> Ok.
> 

>> const char *? Ditto elsewhere.
> 
> OK.
>> I did some testing: vivi video nodes do not show up at all. 
> 
> Hmm... vivi nodes are not linked to any physical hardware: they are virtual devices:
> 
> $ tree /sys/class/video4linux/
> /sys/class/video4linux/
> └── video0 -> ../../devices/virtual/video4linux/video0
> 
> The current implementation discards virtual devices, as there's no way to associate
> them with a physical device. I'll fix the code to allow it to show also virtual devices.

The above comments were addressed. I added also an option at v4l2-sysfs-path[1] to allow
showing all discovered info as-is. By default, it will show something close to what a
V4L2 application would do.

I didn't care enough to add support for midi and midiC0D0 type of devices, as I don't have
any here for testing, and they're doubtful to be used by a V4L2 application, but it would
be good to latter add support for them (or to remove them from the list of parsed devices),
just to avoid reporting a device as of the type unknown. Not sure if is there any other
alsa device not parsed.

On normal mode, it outputs the device based on /dev/video? topology:

$  ./utils/v4l2-sysfs-path/v4l2-sysfs-path 
Video device: video2
	vbi: vbi0 
	sound card: hw:2 
	pcm capture: hw:2,0 
	mixer: hw:2 
Video device: video1
	sound card: hw:1 
	pcm output: hw:1,0 
	mixer: hw:1 
Video device: video0
Alsa playback device(s): hw:0,0 hw:0,1 

On device mode, it will show:

$  ./utils/v4l2-sysfs-path/v4l2-sysfs-path -d
Device pci0000:00/0000:00:1b.0:
	hw:0(sound card, dev 0:0) hw:0,0(pcm capture, dev 116:6) hw:0,0(pcm output, dev 116:5) hw:0,1(pcm output, dev 116:4) hw:0(mixer, dev 116:8) hw:0,0(sound hardware, dev 116:7) 
Device pci0000:00/0000:00:1d.7/usb1/1-7:
	video2(video, dev 81:2) vbi0(vbi, dev 81:3) hw:2(sound card, dev 0:0) hw:2,0(pcm capture, dev 116:11) hw:2(mixer, dev 116:12) 
Device pci0000:00/0000:00:1d.7/usb1/1-8:
	video1(video, dev 81:1) hw:1(sound card, dev 0:0) hw:1,0(pcm output, dev 116:9) hw:1(mixer, dev 116:10) 
Device virtual0:
	video0(video, dev 81:0) 
Device virtual1:
	timer(sound timer, dev 116:2) 
Device virtual2:
	seq(sound sequencer, dev 116:3) 

In order, the above devices are:
	- HDA Intel integrated at the motherboard chipset.
	- USB Sirius webcam, with integrated audio output;
	- USB HVR 950 (em28xx based);
	- Vivi (the device at "virtual0").

[1] btw, we should rename it ;) Its name makes not much sense with the current approach
