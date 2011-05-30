Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4675 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1E3Gei (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 02:34:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices - was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Mon, 30 May 2011 08:34:32 +0200
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
References: <4DDAC0C2.7090508@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE237D9.8090306@redhat.com>
In-Reply-To: <4DE237D9.8090306@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300834.32362.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, May 29, 2011 14:11:05 Mauro Carvalho Chehab wrote:
> Em 29-05-2011 08:19, Hans Verkuil escreveu:
> >> Each device type that is known by the API is defined inside enum device_type,
> >> currently defined as:
> >>
> >> 	enum device_type {
> >> 		UNKNOWN = 65535,
> >> 		NONE    = 65534,
> >> 		MEDIA_V4L_VIDEO = 0,
> > 
> > Can you add MEDIA_V4L_RADIO as well? And MEDIA_V4L_SUBDEV too.
> 
> It doesn't make sense to add anything at the struct without having a code
> for discovering it. This RFC were made based on a real, working code.
> 
> That's said, the devices I used to test didn't create any radio node. I'll add it.
> the current class parsers should be able to get it with just a trivial change.
> 
> With respect to V4L_SUBDEV, a separate patch will likely be needed for it.
> No sure how this would appear at sysfs.
> 
> > 
> >> 		MEDIA_V4L_VBI,
> >> 		MEDIA_DVB_FRONTEND,
> > 
> > It might be better to start at a new offset here, e.g. MEDIA_DVB_FRONTEND = 100
> > Ditto for SND. That makes it easier to insert new future device nodes.
> 
> Good point.
> 
> > 
> >> 		MEDIA_DVB_DEMUX,
> >> 		MEDIA_DVB_DVR,
> >> 		MEDIA_DVB_NET,
> >> 		MEDIA_DVB_CA,
> >> 		MEDIA_SND_CARD,
> >> 		MEDIA_SND_CAP,
> >> 		MEDIA_SND_OUT,
> >> 		MEDIA_SND_CONTROL,
> >> 		MEDIA_SND_HW,
> > 
> > Should we have IR (input) nodes as well? That would associate a IR input with
> > a particular card.
> 
> From the implementation POV, IR's are virtual devices, so they're not bound
> to an specific board at sysfs. So, if this will ever need, a different logic
> will be required.
> 
> From the usecase POV, I don't see why such type of relationship should be
> useful. The common usecase is that just one RC receiver/transmitter to be
> used on a given environment. The IR commands should be able to control
> everything.
> 
> For example, I have here one machine with 2 cards installed: one with 2 DVB-C
> independent adapters and another with one analog/ISDB-T adapter. I want to 
> control all three devices with just one remote controller. Eventually, 2
> rc devices will be shown, but just one will be connected to a sensor.
> In this specific case, I don't use the RC remotes, but I prefer to have a 
> separate USB HID remote controller adapter for them.
> 
> There are some cases, however, where more than one remote controller may be
> desired, like having one Linux system with several independent consoles,
> each one with its own remote controller. On such scenario, what is needed
> is to map each mouse/keyboard/IR/video adapter set to an specific Xorg
> configuration, not necessarily matching the v4l devices order. If not
> specified, X will just open all input devices and mix all of them.
> 
> In other words, for event/input devices, if someone needs to have more than
> one IR, each directed to a different set of windows/applications, he will 
> need to manually configure what he needs. So, grouping RC with video apps
> doesn't make sense.

I'm not so sure about that. Wouldn't it be at least useful that an application
can discover that an IR exists? That may exist elsewhere already, though. I'm
no IR expert.

> 
> >> 	};
> >>
> >> The first function discovers the media devices and stores the information
> >> at an internal representation. Such representation should be opaque to
> >> the userspace applications, as it can change from version to version.
> >>
> >> 2.1) Device discover and release functions
> >>      =====================================
> >>
> >> The device discover is done by calling:
> >>
> >> 	void *discover_media_devices(void);
> >>
> >> In order to release the opaque structure, a free method is provided:
> >>
> >> 	void free_media_devices(void *opaque);
> >>
> >> 2.2) Functions to help printing the discovered devices
> >>      =================================================
> >>
> >> In order to allow printing the device type, a function is provided to
> >> convert from enum device_type into string:
> >>
> >> 	char *media_device_type(enum device_type type);
> > 
> > const char *?
> 
> Ok.
> 
> >>
> >> All discovered devices can be displayed by calling:
> >>
> >> 	void display_media_devices(void *opaque);
> > 
> > This would be much more useful if a callback is provided.
> 
> I can't see any usecase for a callback. Can you explain it better?

Right now display_media_devices outputs to stdout. But what if the apps wants
to output to stderr? To some special console? To a GUI?

Regards,

	Hans
