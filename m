Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1E1OKw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 10:10:52 -0400
Message-ID: <4DE10266.1070709@redhat.com>
Date: Sat, 28 May 2011 11:10:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl> <4DDB5C6B.6000608@redhat.com> <4DDBBC29.80009@infradead.org> <4DDBD504.5020109@redhat.com> <4DE0EE44.8060000@infradead.org>
In-Reply-To: <4DE0EE44.8060000@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-05-2011 09:44, Mauro Carvalho Chehab escreveu:

>> Anyways I think we're are currently
>> doing this the wrong way up. We should first discuss what such an API
>> should look like and then implement it. Hopefully we can re-use a lot
>> of the existing code when we do this, but I think it is better
>> to first design the API and then write code to the API, the current
>> API at least to me feels somewhat like an API written around existing
>> code rather then the other way around.
> 
> No, was just the opposite: the API were designed to fulfil the needs by
> the alsa streaming methods implemented by Devin at tvtime:
> 
> int alsa_thread_startup(const char *pdevice, const char *cdevice);
> 
> The two arguments are the alsa playback device and the alsa capture device.
> 
> the API were designed around that, to do something like:
> 
> 	struct some_opaque_struct *opaque = discover_media_devices();
> 	alsa_playback = alsa_playback(opaque);
> 	alsa_capture = alsa_capture(opaque);
> 	alsa_thread_startup(alsa_playback, alsa_capture);
> 	free_media_devices(opaque);
> 
> PS.: I'm not using the real names/arguments at the above, to keep the example
>      simpler and clearer. The actual code is not that different from the above:
> 
> 	struct media_devices *md;
> 	unsigned int size = 0;
> 	char *alsa_cap, *alsa_out, *p;
> 	char *video_dev = "/dev/video0";
> 
> 	md = discover_media_devices(&size);
> 	p = strrchr(video_dev, '/');
> 	alsa_cap = get_first_alsa_cap_device(md, size, p + 1);
> 	alsa_out = get_first_no_video_out_device(md, size);
> 	if (alsa_cap && alsa_out)
> 		alsa_handler(alsa_out, alsa_cap);
> 	free_media_devices(md, size);
> 	...
> 	fd = open(video_dev, "rw");

I decided to re-organize the way the API will handle the devices, in order
to make clearer that the internal struct should be opaque to the applications
using the library [1].

[1] http://git.linuxtv.org/v4l-utils.git?a=commitdiff;h=435f4ba896f76d92a800a2089e06618d8c3d93f0

Now, the functions will just return a void pointer that is used as a parameter
for the other functions.

So, the typical usecase is, currently:

	void *md;
	char *alsa_playback, *alsa_capture, *p;

	md = discover_media_devices();
	if (!md)
		return;
	alsa_capture = get_first_alsa_cap_device(md, video_dev);
	alsa_playback = get_first_no_video_out_device(md);
	if (alsa_capture && alsa_playback)
		alsa_handler(alsa_playback, alsa_capture);
	free_media_devices(md);

I'll be working on improving the API, in order to read the uevent information from the
media nodes (were device major/minor info are stored) and to associate a device with
its file descriptor.

Cheers,
Mauro
