Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:37783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1E1MpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 08:45:00 -0400
Message-ID: <4DE0EE44.8060000@infradead.org>
Date: Sat, 28 May 2011 09:44:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl> <4DDB5C6B.6000608@redhat.com> <4DDBBC29.80009@infradead.org> <4DDBD504.5020109@redhat.com>
In-Reply-To: <4DDBD504.5020109@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-05-2011 12:55, Hans de Goede escreveu:
> Hi,
> 
> On 05/24/2011 04:09 PM, Mauro Carvalho Chehab wrote:
>> Em 24-05-2011 04:21, Hans de Goede escreveu:
>>> Hi,
>>
>>> My I suggest that we instead just copy over the single get_media_devices.c
>>> file to xawtv, and not install the not so much a lib lib ?
>>
>> If we do that, then all other places where the association between an alsa device
>> and a video4linux node is needed will need to copy it, and we'll have a fork.
>> Also, we'll keep needing it at v4l-utils, as it is now needed by the new version
>> of v4l2-sysfs-path tool.
>>
>> Btw, this lib were created due to a request from the vlc maintainer that something
>> like that would be needed. After finishing it, I decided to add it at xawtv in order
>> to have an example about how to use it.
>>
> 
> I'm not saying that this is not useful to have, I'm just worried about
> exporting the API before it has had any chance to stabilize, and about
> also throwing in the other random libv4l2util bits.
> 
>>> Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
>>> consider it unpolite to revert other peoples commits, so I would prefer for you
>>> to revert the install libv4l2util.a patch yourself. But if you don't (or don't
>>> get around to doing it before I do the release), I will revert it, as this
>>> clearly needs more discussion before making it into an official release
>>> tarbal (we can always re-introduce the patch after the release).
>>
>> I'm not a big fan or exporting the rest of stuff at libv4l2util.a either
> 
> Glad we agree on that :)
> 
>> but I
>> think that at least the get_media_devices stuff should be exported somewhere,
> 
> Agreed.
> 
>> maybe as part of libv4l.
> 
> That would be a logical place to put it, otoh currently libv4l mostly mimics the
> raw /dev/video# node API, so adding this API is not a logical fit there ...
> 
> It may make more sense to have something in libv4l2 like:
> 
> enum libv4l2_associated_device_types {
>     libv4l2_alsa_input,
>     libv4l2_alsa_output,
>     libv4l2_vbi
> };

While, on a large amount of the usecases the above will work, the association is not that 
simple, as it may have more than one device associated for each type, but I liked the basic 
idea.

In fact, I was thinking on implementing something like the above for the media
devices structure, but I opted to use a simple sorted device list, as the code
will be simpler, clearer to read and without the need of implementing complex
allocation schemes.


> int libv4l2_get_associated_devive(int fd, enum libv4l2_associated_device_types type, ...);
> Where fd is the fd of an open /dev/video node, and ... is a param through
> which the device gets returned (I guess a char * to a buffer of MAX_PATH
> length where the device name gets stored, this could
> be an also identifier like hw:0.0 or in case of vbi a /dev/vbi# path, etc.

Using the fd will be more complex, as we'll loose the device node (is there a
glibc way to get the device path from the fd?). Well, we may associate the fd 
descriptor with the device node internally at libv4l.

> Note that an API for enumerating available /dev/video nodes would also
> be a welcome addition to libv4l2.

This comes with a bonus from the sysfs enum approach. Of course if the udev 
rules are not doing weird things like creating video devices under /dev/v4l
(that happens on some distros).

Yet, it makes sense to add a method there that will seek for the device nodes
and return /dev/video0 or /dev/v4l/video0 depending on how the distro is
using it. 

Some distros even use both. For example, at Fedora 15 and RHEL6, this is 
currently:

/dev/v4l/
├── by-id
│   └── usb-2040_WinTV_USB2_0002819348-video-index0 -> ../../video0
└── by-path
    └── pci-0000:00:1d.7-usb-0:7:1.0-video-index0 -> ../../video0
/dev/video0

On RHEL5, it is just:

/dev/video0

The last time I used Mandriva (3 years ago), they used to have it at just
/dev/v4l/video0. Not sure what they're doing currently. I think that 
Ubuntu/Debian just use /dev/video0.

> Anyways I think we're are currently
> doing this the wrong way up. We should first discuss what such an API
> should look like and then implement it. Hopefully we can re-use a lot
> of the existing code when we do this, but I think it is better
> to first design the API and then write code to the API, the current
> API at least to me feels somewhat like an API written around existing
> code rather then the other way around.

No, was just the opposite: the API were designed to fulfil the needs by
the alsa streaming methods implemented by Devin at tvtime:

int alsa_thread_startup(const char *pdevice, const char *cdevice);

The two arguments are the alsa playback device and the alsa capture device.

the API were designed around that, to do something like:

	struct some_opaque_struct *opaque = discover_media_devices();
	alsa_playback = alsa_playback(opaque);
	alsa_capture = alsa_capture(opaque);
	alsa_thread_startup(alsa_playback, alsa_capture);
	free_media_devices(opaque);

PS.: I'm not using the real names/arguments at the above, to keep the example
     simpler and clearer. The actual code is not that different from the above:

	struct media_devices *md;
	unsigned int size = 0;
	char *alsa_cap, *alsa_out, *p;
	char *video_dev = "/dev/video0";

	md = discover_media_devices(&size);
	p = strrchr(video_dev, '/');
	alsa_cap = get_first_alsa_cap_device(md, size, p + 1);
	alsa_out = get_first_no_video_out_device(md, size);
	if (alsa_cap && alsa_out)
		alsa_handler(alsa_out, alsa_cap);
	free_media_devices(md, size);
	...
	fd = open(video_dev, "rw");

>> Anyway, as you're releasing today a new v4l-utils, I agree that it is too early
>> to add such library, as it is still experimental. I'm not considering make any
>> new xawtv release those days, so I'm OK to postpone it.
>>
>> I'll commit a few patches commenting the install procedure for now, re-adding it
>> after the release, for those that want to experiment it with xawtv with the new
>> support.
> 
> Thanks!
> 
> Regards,
> 
> Hans
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

