Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1EVQfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 12:35:51 -0400
Message-ID: <4DD93B5F.9020000@redhat.com>
Date: Sun, 22 May 2011 13:35:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <4DD6899D.5020004@redhat.com> <201105201855.53240.remi@remlab.net> <4DD6B77A.2010800@redhat.com>
In-Reply-To: <4DD6B77A.2010800@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-05-2011 15:48, Mauro Carvalho Chehab escreveu:
> Em 20-05-2011 12:55, Rémi Denis-Courmont escreveu:
>> Le vendredi 20 mai 2011 18:32:45 Mauro Carvalho Chehab, vous avez écrit :
>>> However, I have serious concerns about media_controller API usage on
>>> generic drivers, as it is required that all drivers should be fully
>>> configurable via V4L2 API alone, otherwise we'll have regressions, as no
>>> generic applications use the media_controller.
>>
>> If VLC counts as a generic application, I'd be more than API to use the 
>> media_controller (or whatever else) if only to find which ALSA (sub)device, if 
>> any, corresponds to the V4L2 node of a given USB webcam or such.
>>
>> I don't know any solution at the moment, and this is a major inconvenience on 
>> Linux desktop compared to DirectShow.
> 
> You don't need the media controller for it.
> 
> The proper solution for it is to use the sysfs to identify the alsa sub-device.
> 
> For example, I have this on one of my machines:
> 
> $ lspci |grep Multimedia
> 1c:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 04)
> 37:09.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> 
> $ $ lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 004: ID 0409:005a NEC Corp. HighSpeed Hub
> Bus 001 Device 005: ID 0ac8:3330 Z-Star Microelectronics Corp. 
> Bus 008 Device 002: ID 2101:020f ActionStar 
> Bus 001 Device 003: ID 2040:4200 Hauppauge 
> Bus 001 Device 006: ID 0d8c:0126 C-Media Electronics, Inc. 
> 
> I wrote an utility in the past that dig into the sysfs stuff to identify it, but
> I'm not sure if it is still working fine, as some changes at sysfs might affect it,
> as I never intended to maintain such utility.
> 
> I'll seek for some time to re-write it with another approach and add it as a 
> library, inside v4l2-utils, eventually together with libv4l.
> 
> Basically, all V4L devices are under video4linux class:
> 
> $ tree /sys/class/video4linux/
> /sys/class/video4linux/
> ├── vbi0 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/video4linux/vbi0
> ├── video0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:1c:00.0/video4linux/video0
> ├── video1 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.0/video4linux/video1
> ├── video2 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/video4linux/video2
> └── video3 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.2/1-6.2:1.0/video4linux/video3
> 
> And all alsa devices are under sound class:
> 
> $ tree /sys/class/sound/
> /sys/class/sound/
> ├── card0 -> ../../devices/pci0000:00/0000:00:1b.0/sound/card0
> ├── card1 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/sound/card1
> ├── card2 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/sound/card2
> ├── card3 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.3/1-6.3:1.0/sound/card3
> ├── controlC0 -> ../../devices/pci0000:00/0000:00:1b.0/sound/card0/controlC0
> ├── controlC1 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/sound/card1/controlC1
> ├── controlC2 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/sound/card2/controlC2
> ├── controlC3 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.3/1-6.3:1.0/sound/card3/controlC3
> ├── hwC0D0 -> ../../devices/pci0000:00/0000:00:1b.0/sound/card0/hwC0D0
> ├── pcmC0D0c -> ../../devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0c
> ├── pcmC0D0p -> ../../devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0p
> ├── pcmC1D0c -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/sound/card1/pcmC1D0c
> ├── pcmC2D0c -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/sound/card2/pcmC2D0c
> ├── pcmC3D0p -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.3/1-6.3:1.0/sound/card3/pcmC3D0p
> ├── seq -> ../../devices/virtual/sound/seq
> └── timer -> ../../devices/virtual/sound/timer
> 
> All that such library/utility/function needs do to is to parse the two above sysfs directories
> and associate the devices based on the provided aliases.
> 
> For example, on the above, we have 4 V4L cards:
> 
> PCI card (in this case, a saa7134-based card)
> ├── vbi0 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/video4linux/vbi0
> ├── video2 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/video4linux/video2
> └── card2 -> ../../devices/pci0000:00/0000:00:1e.0/0000:37:09.0/sound/card2
> 
> All tree are at the PCI device 0000:37:09.0.
> 
> USB card (in this example, an em28xx-based card, that uses snd-usb-audio for alsa)
> ├── video1 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.0/video4linux/video1
> └── card1 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.1/sound/card1
> 
> All two are at the USB 1-5 device.
> 
> DVB-C/DVB-T PCI card (in this case cx23885, without any alsa-associated device)
> └── video0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:1c:00.0/video4linux/video0
> 
> This one is at PCI device 0000:1c:00.0.
> 
> UVC webcam (with audio provided by snd-usb-audio)
> ├── video3 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.2/1-6.2:1.0/video4linux/video3
> └── card3 -> ../../devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.3/1-6.3:1.0/sound/card3
> 
> All two are at the USB 1-6 device.
> 
> So, it is easy to associate video and audio for each device. You can even associate the volume
> controls and the PCM input/outputs using the above info.

Ok, I wrote a small library for handling it. I added it at the v4l-utils tree:
	http://git.linuxtv.org/v4l-utils.git?a=commitdiff;h=0ec88068b8f227798e5ecf9d7c375f008d98743a

For the same above devices, it parses the V4L, DVB and sound subsystem info at
/sys/class and outputs the relevant information about them:

Device pci0000:00/0000:00:1a.7/usb1/1-5:
	video1(video) card1(sound card) pcmC1D0c(pcm capture) controlC1(mixer) 
Device pci0000:00/0000:00:1a.7/usb1/1-6:
	video0(video) card2(sound card) pcmC2D0p(pcm output) controlC2(mixer) 
Device pci0000:00/0000:00:1b.0:
	card0(sound card) pcmC0D0c(pcm capture) pcmC0D0p(pcm output) controlC0(mixer) hwC0D0(sound hardware) 
Device pci0000:00/0000:00:1c.0/0000:1c:00.0:
	video2(video) dvb0.frontend0(dvb frontend) dvb0.frontend1(dvb frontend) dvb1.frontend0(dvb frontend) dvb1.frontend1(dvb frontend) dvb0.demux0(dvb demux) dvb0.demux1(dvb demux) dvb1.demux0(dvb demux) dvb1.demux1(dvb demux) dvb0.dvr0(dvb dvr) dvb0.dvr1(dvb dvr) dvb1.dvr0(dvb dvr) dvb1.dvr1(dvb dvr) dvb0.net0(dvb net) dvb0.net1(dvb net) dvb1.net0(dvb net) dvb1.net1(dvb net) dvb0.ca0(dvb conditional access) dvb1.ca0(dvb conditional access) 
Device pci0000:00/0000:00:1e.0/0000:37:09.0:
	video3(video) vbi0(vbi) dvb2.frontend0(dvb frontend) dvb2.demux0(dvb demux) dvb2.dvr0(dvb dvr) dvb2.net0(dvb net) card3(sound card) pcmC3D0c(pcm capture) controlC3(mixer) 

The library, for now, is very simple: it provides just 3 functions:

struct media_devices *discover_media_devices(unsigned int *md_size);
void free_media_devices(struct media_devices *md, unsigned int md_size);
void display_media_devices(struct media_devices *md, unsigned int size);

The discover_media_devices() provide a list of device names inside the subsystem,
the PCI/USB device path and device type.

The list is freed with free_media_devices(), and the above output is produced with
display_media_devices().

It probably makes sense to add more methods there, like, for example, a method to
find the device path at /dev, but I opted to make the initial version as simple as 
possible. Feel free to contribute.

Cheers,
Mauro.
