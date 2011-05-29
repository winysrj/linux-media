Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1E2MLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 08:11:10 -0400
Message-ID: <4DE237D9.8090306@redhat.com>
Date: Sun, 29 May 2011 09:11:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl>
In-Reply-To: <201105291319.47207.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-05-2011 08:19, Hans Verkuil escreveu:
>> Each device type that is known by the API is defined inside enum device_type,
>> currently defined as:
>>
>> 	enum device_type {
>> 		UNKNOWN = 65535,
>> 		NONE    = 65534,
>> 		MEDIA_V4L_VIDEO = 0,
> 
> Can you add MEDIA_V4L_RADIO as well? And MEDIA_V4L_SUBDEV too.

It doesn't make sense to add anything at the struct without having a code
for discovering it. This RFC were made based on a real, working code.

That's said, the devices I used to test didn't create any radio node. I'll add it.
the current class parsers should be able to get it with just a trivial change.

With respect to V4L_SUBDEV, a separate patch will likely be needed for it.
No sure how this would appear at sysfs.

> 
>> 		MEDIA_V4L_VBI,
>> 		MEDIA_DVB_FRONTEND,
> 
> It might be better to start at a new offset here, e.g. MEDIA_DVB_FRONTEND = 100
> Ditto for SND. That makes it easier to insert new future device nodes.

Good point.

> 
>> 		MEDIA_DVB_DEMUX,
>> 		MEDIA_DVB_DVR,
>> 		MEDIA_DVB_NET,
>> 		MEDIA_DVB_CA,
>> 		MEDIA_SND_CARD,
>> 		MEDIA_SND_CAP,
>> 		MEDIA_SND_OUT,
>> 		MEDIA_SND_CONTROL,
>> 		MEDIA_SND_HW,
> 
> Should we have IR (input) nodes as well? That would associate a IR input with
> a particular card.

>From the implementation POV, IR's are virtual devices, so they're not bound
to an specific board at sysfs. So, if this will ever need, a different logic
will be required.

>From the usecase POV, I don't see why such type of relationship should be
useful. The common usecase is that just one RC receiver/transmitter to be
used on a given environment. The IR commands should be able to control
everything.

For example, I have here one machine with 2 cards installed: one with 2 DVB-C
independent adapters and another with one analog/ISDB-T adapter. I want to 
control all three devices with just one remote controller. Eventually, 2
rc devices will be shown, but just one will be connected to a sensor.
In this specific case, I don't use the RC remotes, but I prefer to have a 
separate USB HID remote controller adapter for them.

There are some cases, however, where more than one remote controller may be
desired, like having one Linux system with several independent consoles,
each one with its own remote controller. On such scenario, what is needed
is to map each mouse/keyboard/IR/video adapter set to an specific Xorg
configuration, not necessarily matching the v4l devices order. If not
specified, X will just open all input devices and mix all of them.

In other words, for event/input devices, if someone needs to have more than
one IR, each directed to a different set of windows/applications, he will 
need to manually configure what he needs. So, grouping RC with video apps
doesn't make sense.

>> 	};
>>
>> The first function discovers the media devices and stores the information
>> at an internal representation. Such representation should be opaque to
>> the userspace applications, as it can change from version to version.
>>
>> 2.1) Device discover and release functions
>>      =====================================
>>
>> The device discover is done by calling:
>>
>> 	void *discover_media_devices(void);
>>
>> In order to release the opaque structure, a free method is provided:
>>
>> 	void free_media_devices(void *opaque);
>>
>> 2.2) Functions to help printing the discovered devices
>>      =================================================
>>
>> In order to allow printing the device type, a function is provided to
>> convert from enum device_type into string:
>>
>> 	char *media_device_type(enum device_type type);
> 
> const char *?

Ok.

>>
>> All discovered devices can be displayed by calling:
>>
>> 	void display_media_devices(void *opaque);
> 
> This would be much more useful if a callback is provided.

I can't see any usecase for a callback. Can you explain it better?

> 
>>
>> 2.3) Functions to get device associations
>>      ====================================
>>
>> The API provides 3 methods to get the associated devices:
>>
>> a) get_associated_device: returns the next device associated with another one
>>
>> 	char *get_associated_device(void *opaque,
>> 				    char *last_seek,
>> 				    enum device_type desired_type,
>> 				    char *seek_device,
>> 				    enum device_type seek_type);
> 
> const char *? Ditto elsewhere.

OK.

>> The parameters are:
>>
>> 	opaque:		media devices opaque descriptor
>> 	last_seek:	last seek result. Use NULL to get the first result
>> 	desired_type:	type of the desired device
>> 	seek_device:	name of the device with you want to get an association.
>> 	seek_type:	type of the seek device. Using NONE produces the same
>> 			result of using NULL for the seek_device.
>>
>> This function seeks inside the media_devices struct for the next device
>> that it is associated with a seek parameter.
>> It can be used to get an alsa device associated with a video device. If
>> the seek_device is NULL or seek_type is NONE, it will just search for
>> devices of the desired_type.
>>
>>
>> b) fget_associated_device: returns the next device associated with another one
>>
>> 	char *fget_associated_device(void *opaque,
>> 				    char *last_seek,
>> 				    enum device_type desired_type,
>> 				    int fd_seek_device,
>> 				    enum device_type seek_type);
>>
>> The parameters are:
>>
>> 	opaque:		media devices opaque descriptor
>> 	last_seek:	last seek result. Use NULL to get the first result
>> 	desired_type:	type of the desired device
>> 	fd_seek_device:	file handler for the device where the association will
>> 			be made
>>  	seek_type:	type of the seek device. Using NONE produces the same
>> 			result of using NULL for the seek_device.
>>
>> This function seeks inside the media_devices struct for the next device
>> that it is associated with a seek parameter.
>> It can be used to get an alsa device associated with an open file descriptor
>>
>> c) get_not_associated_device: Returns the next device not associated with
>> 			      an specific device type.
>>
>> char *get_not_associated_device(void *opaque,
>> 			    char *last_seek,
>> 			    enum device_type desired_type,
>> 			    enum device_type not_desired_type);
>>
>> The parameters are:
>>
>> opaque:			media devices opaque descriptor
>> last_seek:		last seek result. Use NULL to get the first result
>> desired_type:		type of the desired device
>> not_desired_type:	type of the seek device
>>
>> This function seeks inside the media_devices struct for the next physical
>> device that doesn't support a non_desired type.
>> This method is useful for example to return the audio devices that are
>> provided by the motherboard.
> 
> Hmmm. What you really want IMHO is to iterate over 'media hardware', and for
> each piece of hardware you can find the associated device nodes.

The v4l2-sysfs-patch util does that, using those API calls [1]
	http://git.linuxtv.org/v4l-utils.git?a=blob;f=utils/v4l2-sysfs-path/v4l2-sysfs-path.c;h=7579612bdcd888d49e78772ed7ff8c5e410b7687;hb=HEAD

> 
> It's what you expect to see in an application: a list of USB/PCI/Platform
> devices to choose from.

A missing function is to return the device address, but it should be easy
to add it if needed.

It may make sense to have a function that will open each device, do a
VIDIOC_QUERYCTL and export an enrich list of devices based on what's returned
there.

>>
>> 3) Examples with typical usecases
>>    ==============================
>>
>> a) Just displaying all media devices:
>>
>> 	void *md = discover_media_devices();
>> 	display_media_devices(md);
>> 	free_media_devices(md);
>>
>> The devices will be shown at the order they appear at the computer buses.
>>
>> b) For video0, prints the associated alsa capture device(s):
>>
>> 	void *md = discover_media_devices();
>> 	char *devname = NULL, video0 = "/dev/video0";
>> 	do {
>> 		devname = get_associated_device(md, devname, MEDIA_SND_CAP,
>> 						video0, MEDIA_V4L_VIDEO);
>> 		if (devname)
>> 			printf("Alsa capture: %s\n", devname);
>> 	} while (devname);
>> 	free_media_devices(md);
>>
>> Note: the video0 string can be declarated as "/dev/video0" or as just "video0",
>> as the search functions will discard any patch on it.
>>
>> c) Get the alsa capture device associated with an opened file descriptor:
>>
>> 	int fd = open("/dev/video0", O_RDWR);
>> 	...
>> 	void *md = discover_media_devices();
>> 	vid = fget_associated_device(md, NULL, MEDIA_SND_CAP, fd, 
>> 				     MEDIA_V4L_VIDEO);
>> 	printf("\n\nAlsa device = %s\n", vid);
>> 	close(fd);
>> 	free_media_devices(md);
>>
>> d) Get the mainboard alsa playback devices:
>>
>> 	char *devname = NULL;
>> 	void *md = discover_media_devices();
>> 	do {
>> 		devname = get_not_associated_device(md, devname, MEDIA_SND_OUT,
>> 						    MEDIA_V4L_VIDEO);
>> 		if (devname)
>> 			printf("Alsa playback: %s\n", devname);
>> 	} while (devname);
>> 	free_media_devices(md);
>>
>> e) Get all video devices:
>>
>> 	md = discover_media_devices();
>>
>> 	char *vid = NULL;
>> 	do {
>> 		vid = get_associated_device(md, vid, MEDIA_V4L_VIDEO,
>> 					    NULL, NONE);
>> 		if (!vid)
>> 			break;
>> 		printf("Video device: %s\n", vid);
>> 	} while (vid);
>> 	free_media_devices(md);
>>
> 
> I did some testing: vivi video nodes do not show up at all. 

Hmm... vivi nodes are not linked to any physical hardware: they are virtual devices:

$ tree /sys/class/video4linux/
/sys/class/video4linux/
└── video0 -> ../../devices/virtual/video4linux/video0

The current implementation discards virtual devices, as there's no way to associate
them with a physical device. I'll fix the code to allow it to show also virtual devices.

> And since there is
> no concept of 'media hardware' in this API the handling of devices with multiple
> video nodes (e.g. ivtv) is very poor. 

As I said before, with just one line of code, grouping multiple video nodes into
different groups will work with sysfs. All it needs to know is the group name,
passed via uevent interface.

> One thing that we wanted to do with the MC
> is to select default nodes for complex hardware. This gives applications a hint
> as to what is the default video node to use for standard capture/output. This
> concept can be used here as well. Perhaps we should introduce a 'V4L2_CAP_DEFAULT'
> capabity that drivers can set?

We may add one uevent for that too.

> I think this library would also be more useful if it can filter devices: e.g.
> filter on capture devices or output devices. Actually, I can't immediately think
> of other useful filters than capture vs output.

Yes, that makes sense: just like with SND devices, the library may classify the
outputs and inputs with different types.

> We also need some way to tell apps that certain devices are mutually exclusive.
> Even if we cannot tell the app that through sysfs at the moment, this information
> will become available in the future through the MC, so we should prepare the API
> for this.

Makes sense. Please propose a way for it. We may use group info for that, but
in a few cases (like video/vbi), having two devices grouped don't mean that they're
mutually exclusive.

> Did anyone test what happens when the user renames device nodes using udev rules?
> I haven't had the chance to test that yet.

We'll probably need to do some glue with udev or dbus. Not sure if it announces
it somehow.

Cheers,
Mauro
