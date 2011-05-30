Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1584 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1E3Gyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 02:54:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices - was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Mon, 30 May 2011 08:54:35 +0200
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
References: <4DDAC0C2.7090508@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE237D9.8090306@redhat.com>
In-Reply-To: <4DE237D9.8090306@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300854.35246.hverkuil@xs4all.nl>
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
> 
> > 
> >>
> >> 2.3) Functions to get device associations
> >>      ====================================
> >>
> >> The API provides 3 methods to get the associated devices:
> >>
> >> a) get_associated_device: returns the next device associated with another one
> >>
> >> 	char *get_associated_device(void *opaque,
> >> 				    char *last_seek,
> >> 				    enum device_type desired_type,
> >> 				    char *seek_device,
> >> 				    enum device_type seek_type);
> > 
> > const char *? Ditto elsewhere.
> 
> OK.
> 
> >> The parameters are:
> >>
> >> 	opaque:		media devices opaque descriptor
> >> 	last_seek:	last seek result. Use NULL to get the first result
> >> 	desired_type:	type of the desired device
> >> 	seek_device:	name of the device with you want to get an association.
> >> 	seek_type:	type of the seek device. Using NONE produces the same
> >> 			result of using NULL for the seek_device.
> >>
> >> This function seeks inside the media_devices struct for the next device
> >> that it is associated with a seek parameter.
> >> It can be used to get an alsa device associated with a video device. If
> >> the seek_device is NULL or seek_type is NONE, it will just search for
> >> devices of the desired_type.
> >>
> >>
> >> b) fget_associated_device: returns the next device associated with another one
> >>
> >> 	char *fget_associated_device(void *opaque,
> >> 				    char *last_seek,
> >> 				    enum device_type desired_type,
> >> 				    int fd_seek_device,
> >> 				    enum device_type seek_type);
> >>
> >> The parameters are:
> >>
> >> 	opaque:		media devices opaque descriptor
> >> 	last_seek:	last seek result. Use NULL to get the first result
> >> 	desired_type:	type of the desired device
> >> 	fd_seek_device:	file handler for the device where the association will
> >> 			be made
> >>  	seek_type:	type of the seek device. Using NONE produces the same
> >> 			result of using NULL for the seek_device.
> >>
> >> This function seeks inside the media_devices struct for the next device
> >> that it is associated with a seek parameter.
> >> It can be used to get an alsa device associated with an open file descriptor
> >>
> >> c) get_not_associated_device: Returns the next device not associated with
> >> 			      an specific device type.
> >>
> >> char *get_not_associated_device(void *opaque,
> >> 			    char *last_seek,
> >> 			    enum device_type desired_type,
> >> 			    enum device_type not_desired_type);
> >>
> >> The parameters are:
> >>
> >> opaque:			media devices opaque descriptor
> >> last_seek:		last seek result. Use NULL to get the first result
> >> desired_type:		type of the desired device
> >> not_desired_type:	type of the seek device
> >>
> >> This function seeks inside the media_devices struct for the next physical
> >> device that doesn't support a non_desired type.
> >> This method is useful for example to return the audio devices that are
> >> provided by the motherboard.
> > 
> > Hmmm. What you really want IMHO is to iterate over 'media hardware', and for
> > each piece of hardware you can find the associated device nodes.
> 
> The v4l2-sysfs-patch util does that, using those API calls [1]
> 	http://git.linuxtv.org/v4l-utils.git?a=blob;f=utils/v4l2-sysfs-path/v4l2-sysfs-path.c;h=7579612bdcd888d49e78772ed7ff8c5e410b7687;hb=HEAD
> 
> > 
> > It's what you expect to see in an application: a list of USB/PCI/Platform
> > devices to choose from.
> 
> A missing function is to return the device address, but it should be easy
> to add it if needed.

This is the v4l2-sysfs-path output for an ivtv card (PVR-350):

/sys/class/dvb: No such file or directory
Video device: video1
        video: video17 
        vbi: vbi1 
        radio: radio1 
Video device: video17
        video: video25 
        vbi: vbi1 
        radio: radio1 
Video device: video25
        video: video33 
        vbi: vbi1 
        radio: radio1 
Video device: video33
        video: video49 
        vbi: vbi1 
        radio: radio1 
Video device: video49
        vbi: vbi1 
        radio: radio1

This list of 'devices' is pretty useless for apps.

(BTW: note the initial 'No such file or dir' error at the top: it's perfectly
fine not to have any dvb devices)

The output of v4l2-sysfs-path -d is much more useful:

Device pci0000:00/0000:00:14.4/0000:04:05.0:
        video1(video, dev 81:1) video17(video, dev 81:6) video25(video, dev 81:4) video33(video, dev 81:2) video49(video, dev 81:9) vbi1(vbi, dev 81:3) vbi17(vbi, dev 81:8) vbi9(vbi, dev 81:7) radio1(radio, dev 81:5) 

Here at least all devices of the PCI card are grouped together.

While it would be nice to have the device address exported, it isn't enough:
first of all you want a more abstract API when the app iterates over the hardware
devices, secondly such an API would map muchmore nicely to the MC, and thirdly
doing this in the library will allow us to put more intelligence into the code.
For example, if I'm not mistaken cx88 devices consist of multiple PCI devices.
It's not enough to group them by PCI address. You can however add code to this
library that will detect that it is a cx88 device and attempt to group the
video/audio/dvb devices together.

Regards,

	Hans
