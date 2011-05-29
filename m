Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53709 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab1E2LrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 07:47:06 -0400
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl>
In-Reply-To: <201105291319.47207.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFCv2] Add a library to retrieve associated media devices - was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 29 May 2011 07:47:11 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Message-ID: <bcae2b56-57c0-4936-b4c5-1d57f65125fc@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>Hi Mauro,
>
>Thanks for the RFC! Some initial comments below. I'll hope to do some
>more
>testing and reviewing in the coming week.
>
>On Sunday, May 29, 2011 03:01:43 Mauro Carvalho Chehab wrote:
>> Em 28-05-2011 13:20, Mauro Carvalho Chehab escreveu:
>> > Em 28-05-2011 12:24, Hans Verkuil escreveu:
>> >> But I would really like to see an RFC with a proposal of the API
>and how
>> >> it is to be used. Then after an agreement has been reached the
>library can
>> >> be modified accordingly and we can release it.
>> > 
>> > Ok, that's the RFC for the API. The code is already committed, on a
>separate
>> > library at v4l-utils. So, feel free to test.
>> http://git.linuxtv.org/v4l-utils.gi
>> Just finished a version 2 of the library. I've addressed on it the
>two
>> comments from Hans de Goede: to allow calling the seek method for the
>> associated devices using an open file descriptor, and to allow
>listing
>> all video nodes. The library is at utils/libmedia_dev dir, at 
>> http://git.linuxtv.org/v4l-utils.git. IMO, the proper step is to move
>it
>> to the libv4l, but it is better to wait to the release of the current
>> version. After that, I'll change xawtv3 to link against the new
>library.
>> 
>> Btw, it may be a good idea to also move the alsa thread code from
>xawtv3
>> (and tvtime) to v4l-utils.
>> 
>> -
>> 
>> 1) Why such library is needed
>>    ==========================
>> 
>> Media devices can be very complex. It is not trivial how to detect
>what's the
>> other devices associated with a video node.
>> 
>> This API provides the capabilities of getting the associated devices
>with a
>> video node.
>> 
>> It is currently implemented at http://git.linuxtv.org/v4l-utils.git,
>at the
>> utils/libmedia_dev/. After validating it, it makes sense to move it
>to be
>> part of libv4l.
>> 
>> 2) Provided functions
>>    ==================
>> 
>> The API defines a macro with its current version. Currently, it is:
>> 
>> 	#define GET_MEDIA_DEVICES_VERSION	0x0104
>> 
>> Each device type that is known by the API is defined inside enum
>device_type,
>> currently defined as:
>> 
>> 	enum device_type {
>> 		UNKNOWN = 65535,
>> 		NONE    = 65534,
>> 		MEDIA_V4L_VIDEO = 0,
>
>Can you add MEDIA_V4L_RADIO as well? And MEDIA_V4L_SUBDEV too.
>
>> 		MEDIA_V4L_VBI,
>> 		MEDIA_DVB_FRONTEND,
>
>It might be better to start at a new offset here, e.g.
>MEDIA_DVB_FRONTEND = 100
>Ditto for SND. That makes it easier to insert new future device nodes.
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
>Should we have IR (input) nodes as well? That would associate a IR
>input with
>a particular card.
>
>> 	};
>> 
>> The first function discovers the media devices and stores the
>information
>> at an internal representation. Such representation should be opaque
>to
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
>const char *?
>
>> 
>> All discovered devices can be displayed by calling:
>> 
>> 	void display_media_devices(void *opaque);
>
>This would be much more useful if a callback is provided.
>
>> 
>> 2.3) Functions to get device associations
>>      ====================================
>> 
>> The API provides 3 methods to get the associated devices:
>> 
>> a) get_associated_device: returns the next device associated with
>another one
>> 
>> 	char *get_associated_device(void *opaque,
>> 				    char *last_seek,
>> 				    enum device_type desired_type,
>> 				    char *seek_device,
>> 				    enum device_type seek_type);
>
>const char *? Ditto elsewhere.
>
>> The parameters are:
>> 
>> 	opaque:		media devices opaque descriptor
>> 	last_seek:	last seek result. Use NULL to get the first result
>> 	desired_type:	type of the desired device
>> 	seek_device:	name of the device with you want to get an association.
>> 	seek_type:	type of the seek device. Using NONE produces the same
>> 			result of using NULL for the seek_device.
>> 
>> This function seeks inside the media_devices struct for the next
>device
>> that it is associated with a seek parameter.
>> It can be used to get an alsa device associated with a video device.
>If
>> the seek_device is NULL or seek_type is NONE, it will just search for
>> devices of the desired_type.
>> 
>> 
>> b) fget_associated_device: returns the next device associated with
>another one
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
>> 	fd_seek_device:	file handler for the device where the association
>will
>> 			be made
>>  	seek_type:	type of the seek device. Using NONE produces the same
>> 			result of using NULL for the seek_device.
>> 
>> This function seeks inside the media_devices struct for the next
>device
>> that it is associated with a seek parameter.
>> It can be used to get an alsa device associated with an open file
>descriptor
>> 
>> c) get_not_associated_device: Returns the next device not associated
>with
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
>> This function seeks inside the media_devices struct for the next
>physical
>> device that doesn't support a non_desired type.
>> This method is useful for example to return the audio devices that
>are
>> provided by the motherboard.
>
>Hmmm. What you really want IMHO is to iterate over 'media hardware',
>and for
>each piece of hardware you can find the associated device nodes.
>
>It's what you expect to see in an application: a list of
>USB/PCI/Platform
>devices to choose from.
>
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
>> The devices will be shown at the order they appear at the computer
>buses.
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
>> Note: the video0 string can be declarated as "/dev/video0" or as just
>"video0",
>> as the search functions will discard any patch on it.
>> 
>> c) Get the alsa capture device associated with an opened file
>descriptor:
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
>I did some testing: vivi video nodes do not show up at all. And since
>there is
>no concept of 'media hardware' in this API the handling of devices with
>multiple
>video nodes (e.g. ivtv) is very poor. One thing that we wanted to do
>with the MC
>is to select default nodes for complex hardware. This gives
>applications a hint
>as to what is the default video node to use for standard
>capture/output. This
>concept can be used here as well. Perhaps we should introduce a
>'V4L2_CAP_DEFAULT'
>capabity that drivers can set?
>
>I think this library would also be more useful if it can filter
>devices: e.g.
>filter on capture devices or output devices. Actually, I can't
>immediately think
>of other useful filters than capture vs output.
>
>We also need some way to tell apps that certain devices are mutually
>exclusive.
>Even if we cannot tell the app that through sysfs at the moment, this
>information
>will become available in the future through the MC, so we should
>prepare the API
>for this.
>
>Did anyone test what happens when the user renames device nodes using
>udev rules?
>I haven't had the chance to test that yet.
>
>Regards,
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Framebuffer devices are missing from the list.  Ivtv provides one at the moment.

-Andy 
